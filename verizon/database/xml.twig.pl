#!/usr/bin/perl -w
use strict;

use XML::Twig;

my $infile='./SONY2001081701004000.xml';
my $outfile=$infile.".NEW";

my $twig=new XML::Twig (pretty_print  => 'indented',
			id => 'Asset_Class');

$twig->parsefile($infile);

my $titleClass = $twig->elt_id('title');

$titleClass->insert_new_elt('after','App_Data', {App=>'MOD', 
							Name=>'CID',
							Value=>'222222222'});

open (my $fh_out, '>', $outfile) or die "unable to open '$outfile' for writing: $!";

$twig->print($fh_out);;
