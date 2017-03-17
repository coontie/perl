#!/usr/bin/perl -w

use strict;

use Spreadsheet::ParseXLSX;
use GraphViz;
 
my $parser = Spreadsheet::ParseXLSX->new;
my $workbook = $parser->parse("vso_list.xlsx");
# see Spreadsheet::ParseExcel for further documentation
#
#my $graph = GraphViz->new(overlap => 'orthoyx', directed => 1, concentrate => 1, layout => 'circo');
my $graph = GraphViz->new(directed => 0, layout => 'sfdp');


open (OUTFILE, ">./fiosmap.png");

my $worksheet = $workbook->worksheet(0);

my ( $row_min, $row_max ) = $worksheet->row_range(); 

#for my $row ( $row_min++ .. $row_max ) {
for my $row ( 1 .. 500 ) {
	my $vso = $worksheet->get_cell( $row, 0 )->value();
	my $vho = $worksheet->get_cell( $row, 1 )->value();
	my $lata = $worksheet->get_cell( $row, 3 )->value();
        next unless $vso;


	my $currentCluster = {
		name	=> "$lata",
		style	=> 'filled',
		fillcolor =>'lightgray',
		fontname =>'arial',
		fontsize =>'12',
	};

#	$graph->add_node($vso, cluster=>$currentCluster); 
#	$graph->add_node($vho, cluster=>$currentCluster); 
 
        #print "Row, Col    = ($row, $col)\n";
#        print "Value       = ", $lata->value(),       "\n";
	$graph->add_edge($vho => $vso);

}

print OUTFILE $graph->as_png;
close OUTFILE;
