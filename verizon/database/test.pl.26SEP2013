#!/usr/bin/perl -w

use strict;
use Text::Iconv;
use Spreadsheet::XLSX;
use XML::Twig;
use DBI;

#local ondisk sqlite connection string
my $dbh = DBI->connect("dbi:SQLite:test.db", "", "", {RaiseError => 1, AutoCommit => 1}) or die $DBI::errstr;

#define the queries
my $sql_select = 'select cid from vcms_log where cid = ?';
my $sql_insert = 'insert into vcms_log (id,TITLE_NAME,cid,alid) values (NULL,?,?,?)';


my $converter = Text::Iconv -> new ("utf-8", "windows-1251");

print "Get a list of all XMLs...";
#get a list of all excelFiles ending in xlsx extension
my @excelFiles = <*.xlsx>;
print "done\n";

foreach my $excelFile (@excelFiles) {

	print "Processing $excelFile...";

	#strip the trailing carriage return
	chomp ($excelFile);
	my $excel = Spreadsheet::XLSX->new($excelFile, $converter) or die "No Excel files found. Exiting.";

	print "done. \n";

	#use the first sheet only
	my $sheet = ${$excel->{Worksheet}}[0];

	#If $sheet->{'MaxRow'} has a value that evaluates to false, make
	#$sheet->{'MaxRow'} equal to $sheet->{'MinRow'}.
	$sheet->{MaxRow} ||= $sheet->{MinRow};

	foreach my $row ($sheet->{MinRow} .. $sheet->{MaxRow}) {
        	my $mpm_description = 	$sheet->{Cells}[$row][2]->{Val};
        	my $CID = 		$sheet->{Cells}[$row][10]->{Val};
        	my $ALID = 		$sheet->{Cells}[$row][11]->{Val};
#		print "MPM: $mpm_description \t\t CID: $CID \t\t ALID: $ALID \n" if defined $mpm_description;
#		print ".";

		#if mpm_description, i.e. the cell in Excel contains a title name, see if it exists in the XMLs
		#all 3 cells must be present to proceed
		if ($mpm_description && $CID && $ALID) {

			#init this to an empty string. If XMLs are found, it'll be set to the name of the XML file
			#containing the title
			my $matchedFile = '';

			#create a handle for the select query
			my $sth = $dbh->prepare($sql_select);

			#check whether the asset has been processed previously, CID is the parameter passed
			$sth->execute($CID) or die $DBI::errstr;

			#get just one row, don't need any more. Looking for a yes/no match.
			my @result = $sth->fetchrow_array();

#			print "Found $#result matches for $mpm_description|";

			my $titleMatch = 'Name=\"Title\" Value=\"'.$mpm_description.'\"';
	
#			print "title match is $titleMatch \n";

			#this grep returns a filename containing a title.
			#Need to know whether a string is in there or not.
			#skip this entirely if the previous sql select returned more than -1
			#-1 array index means an empty array, $#result is an index to the last
			#member of the array. If $#result is 0 that means there is one element,
			#i.e. the sql select found a previously processed title of the same name
			if ($#result == -1) {
				my $matchedFile = `grep -l "$titleMatch" *.xml`;
			} else {
				print "$mpm_description was previously processed, skipping. \n";
			}

			#strip the trailing carriage return
			chomp $matchedFile;

			if ($matchedFile ne '') {
				print "Found a match for $mpm_description in $matchedFile! \n";
				insertUV($matchedFile,$CID,$ALID) unless ($matchedFile eq '');
				
				#create a handle for the insert query
				$sth = $dbh->prepare($sql_insert);
				
				#insert this title into the db so if encountered again, it'll be skipped
				$sth->execute($mpm_description,$CID,$ALID)  or die $DBI::errstr;
			}
		}
	}
}


exit 0;

sub insertUV {
	my ($infile,$cid,$alid) = @_;
	print "Adding UV fields $cid | $alid to $infile \n";
	
	#create a new XML with a .UV extension
	my $outfile=$infile.".UV";

	my $twig=new XML::Twig (pretty_print  => 'indented',
			id => 'Asset_Class');

	$twig->parsefile($infile);

	my $titleClass = $twig->elt_id('title');

	$titleClass->insert_new_elt('after','App_Data', {App=>'MOD', Name=>'CID', Value=>$cid});
	$titleClass->insert_new_elt('after','App_Data', {App=>'MOD', Name=>'ALID', Value=>$alid});

	#create new .UV file, error if unable to create
	#this will ALWAYS overwrite any previously created .UV files
	open (my $fh_out, '>', $outfile) or die "unable to open '$outfile' for writing: $!";

	#write the new XML, with the UV fields added
	$twig->print($fh_out);
} 
