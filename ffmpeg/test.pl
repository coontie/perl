#!/usr/bin/perl -w

use strict;
use DateTime;

my $time=$ARGV[0];

my ($hours,$minutes,$seconds) = split (/:/,$time);
my $interval = $ARGV[1];

my $timecode = DateTime->new(year=>2011,hour=>$hours, minute => $minutes, second => $seconds);

$timecode->add(seconds => $interval);

print $timecode->hms;
