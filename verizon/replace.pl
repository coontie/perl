#!/usr/bin/perl -w

use strict;

my $filename = $ARGV[0];

open (INFILE, "<$filename");

my $i = 1;
while (<INFILE>) {
	if (/uml:OpaqueAction/) {
 		s/name=\"/name=\"$i\.\ /g;
		$i++;
	}
	if (/packagedElement/) {
		$i=1;
	}
	print $_;
}

close INFILE;
