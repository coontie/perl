#!/usr/bin/perl -w
#

use strict;

use XML::Tidy;
use File::Slurp;


my $slurped=read_file('/tmp/out.xml');

  # create new   XML::Tidy object from         MainFile.xml
my $tidy_obj = XML::Tidy->new('xml' => $slurped);
  #
  # Tidy up the indenting
$tidy_obj->tidy();
  #
  #            # Write out changes back to MainFile.xml
print $tidy_obj->toString();
  #
