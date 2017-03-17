#!/usr/bin/perl -w

use strict;
use DateTime;

my $filename=$ARGV[0];
my $outputDir='output/';

#this extracts the duration from the media asset
my $retCode=`ffmpeg -i $filename &> /tmp/out.txt`;

open (FILEIN, '</tmp/out.txt');

my ($throwaway, $hours, $minutes, $seconds) = '';

while (<FILEIN>) {
	if (/Duration/) {

		#get rid of leading spaces
		s/\ //g;
		($throwaway, $hours, $minutes, $seconds) = split (/:/);

		#number of seconds is followed by ",start" - need to get rid of that
		($seconds, $throwaway)=split(/\./, $seconds);

		print "hours: $hours minutes: $minutes seconds: $seconds \n";
	}
}
close FILEIN;

#chunk size in seconds
my $interval = 5;

#set the current timecode duration to all 0s
my $timecode = DateTime->new(year=>2011,hour=> 00, minute => 00, second => 00);

#set the movie duration
my $duration = DateTime->new(year=>2011,hour=>$hours, minute => $minutes, second => $seconds);
#

#start chunk numbering at 0
my $i=0;
#print "starting with ".$timecode->hms;

while ($timecode lt $duration) {
#	print "current timecode ". $timecode->hms ."\n";

	my $command="ffmpeg -ss ".$timecode->hms." -t $interval -i $filename -acodec copy -vcodec copy $outputDir$i.mov";
	print $command."\n";
	`$command`;

	#seek to the next $interval seconds
	$timecode->add(seconds => $interval);

	#filename increment
	$i++;
}
