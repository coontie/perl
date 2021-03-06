#!/usr/bin/perl -w

use strict;

use GD::Graph::linespoints;
use Data::Dumper;

require 'save.pl';

my @listOfFiles = `ls results/*`;

foreach my $fileName (@listOfFiles) {

    my $serverName = `/bin/basename $fileName`;
    chomp ($serverName);

    my ($data_ref,$max,$min) =  read_data_from_csv($fileName) or die "Cannot read data from $fileName";

    my @data = @$data_ref;

    #print Dumper(@data);

    #print "RETURNED: max is $max min is $min \n";

    my $my_graph = new GD::Graph::linespoints(1200,500);

    $my_graph->set( 
    	x_label => 'Time',
    	y_label => '',
        x_labels_vertical => 1,
    	title => $serverName,
    	y_max_value => $max,
    	y_min_value => $min,
        x_label_skip => 6,
        marker_size => 1,
#    	y_tick_number => 6,
#    	y_label_skip => 6,
#    	markers => [ 1, 5 ],

    	transparent => 0,
    );

#    $my_graph->set( markers => [7] );

    $my_graph->set_legend("Pending Messages","Connections","Inbound","Outbound");
    $my_graph->plot(\@data)->jpeg();
    save_chart($my_graph, "graphs/$serverName");
}


sub read_data_from_csv
{
	my $fn = shift;
	my @d = ();
    my $max = 0;
    my $min = 1000000;

	open(ZZZ, $fn) || return ();

	while (<ZZZ>)
	{
		chomp;
		# you might want Text::CSV here
		my @row = split /,/;

		for (my $i = 0; $i <= $#row; $i++)
		{
			undef $row[$i] if ($row[$i] eq 'undef');
			push @{$d[$i]}, $row[$i];
            if ((defined $row[1]) && ($row[1] > $max)) {
                $max = $row[1];
            }

            if ((defined $row[1]) && ($row[1] < $min)) {
                $min = $row[1];
            }
		}
	}

	close (ZZZ);
    
    #print "max is $max, min is $min \n";

    #must return references, o/w perl will munch all of the returns into 1 array
    $min=0;
	return (\@d, $max + 200, $min);
}

