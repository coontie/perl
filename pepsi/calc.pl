#!/usr/bin/perl -w
use strict;

#first value from command line
my $maxCount = $ARGV[0];

#second value from command line
my $hatsToGet = $ARGV[1];

#total sets the limits, one cap in 8 (0-7) is bad
my $cap_range = 7;
my $bad_cap = 1;

#my team -- not used
my $team = 5;

#total teams in MLB
my $team_range = 30;

#used to compute average
my @results = ();

my $total = 0;

for (my $i=0; $i<$maxCount;$i++) {
	#array keeping track of how many hats a given team has
	my @count = ();

	#running tally of hats acquired thus far, per run
	my $totalHats = 0;
	my $indCount = 0;

	#stop when you get a specified # of hats
	while ($totalHats < $hatsToGet){
		my $random_cap = int(rand($cap_range));

		#skip this section if I get a bad cap
		if ($random_cap == $bad_cap) {} else
		{
			my $random_team = int(rand($team_range));
			$count[$random_team]++;
			#print "Team is $random_team \n";
			if ($count[$random_team] == 3) {
				#a given team got a hat, increment total hats by 1
				$totalHats++;
				#once you get a hat, reset the counter  back to zero
				$count[$random_team] = 0;
			}
		}

		#number of tries thus far
		$indCount++;
	}

	#save the number of tries in an array before resetting
#	push (@results, $indCount);
	$total = $total + $indCount;
}

#compute the average
my $average = $total / $maxCount;

print "Tried $maxCount times, average number of caps required to get $hatsToGet hats: $average \n";
