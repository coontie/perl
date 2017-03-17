#!/usr/bin/perl -w

use strict;
use DBI;
use Data::Dumper;
use XML::XPath;
use XML::XPath::XMLParser;
use Spreadsheet::ParseExcel;

#-----------define variables------------
my $host='10.83.2.186';
my $sid='vtmcpd12';
my $port=1521;
my $username='ciadmin';
my $password='ciadmin';
#---------------------------------------
#
#
#define the database handle
my $dbh = DBI->connect( "dbi:Oracle:host=$host;sid=$sid;port=$port",
                        $username,
                        $password,
                      ) || die "Database connection not made: $DBI::errstr";

#set LongReadLen
#used to control the maximum length of 'long' type fields (LONG, BLOB, CLOB, MEMO, etc.)
#which the driver will read from the database automatically when it fetches each row of data.
$dbh->{LongReadLen} = 9000;


#define the query to execute
#
#my $sql_query='select xmltype.getClobval(metadata) from provider_metadata';
#my $sql_query='select xmltype.getClobval(metadata) from eams_ingest_package where rownum<35 and metadata is not null';
my $sql_query='select xmltype.getClobval(metadata) from eams_publish_package where rownum<5 and metadata is not null';
#my $sql_query='select instance_name from v$instance';

#prepare the statement, gets submitted to Oracle
my $sth=$dbh->prepare($sql_query) or die "Couldn't prepare statement: " . $dbh->errstr;

#execute the query
$sth->execute() or die "Couldn't execute statement: " . $sth->errstr;

#iterate over the results
while (my $row = $sth->fetchrow_arrayref) {

        #currently retrieved ADI metadata from the database
        my $currentADI = $row->[0];
#--------debugging section------------
#       print "_" x 32 . "\n";
#       print $currentADI;
#       print "_" x 32 . "\n";
#--------debugging section------------

        #assign the retrieved metadata to the XPath parser
        my $xp = XML::XPath->new(xml => $currentADI);

        #Xpath query to retrieve the package asset ID from the ADI XML
        my $packageAssetID = $xp->find('/ADI/Metadata/AMS/@Asset_ID');
        my $AssetName = $xp->find('/ADI/Metadata/AMS/@Asset_Name');
        print "Extracting asset $AssetName with a package ID $packageAssetID " . "\n";

        #write the extracted XML to a file
        open (FILEHANDLE, '>', $packageAssetID.'.xml') or die "Can't create file for writing";
        print FILEHANDLE $currentADI;
        close FILEHANDLE;
}

$sth->finish;
$dbh->disconnect;

