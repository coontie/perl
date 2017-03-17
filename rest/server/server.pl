#!/usr/bin/perl -w

use strict;

use Dancer;
use Sys::Statistics::Linux;
use Data::Dumper;

set serializer => 'JSON'; 

my $interface = 'p5p1';
 
my $lxs = Sys::Statistics::Linux->new(
        cpustats  => 1,
        netstats  => 1,
    );


#print "cpu is $cpuIdle \n";

print Dumper($lxs);

get '/' => sub{
	my $stats = $lxs->get();
	my $cpu   = $stats->cpustats->{cpu};
	my $cpuUtil = 100 - $cpu->{idle};
    	#return {cpu => "$cpuUtil"};

	my $network   = $stats->netstats->{$interface};
	my $bandwidth = $network->{ttbyt};
	
    	return {cpu => rand(100),  bandwidth => "$bandwidth"};
};

get '/users/:name' => sub {
    my $user = params->{name};
    return {message => "Hello $user"};
};
 
get '/users' => sub{
    my %users = (
            id   => "1",
            name => "Carlos",
    );

    return \%users;
};

after sub {
    my $response = shift;

    $response->{content} = params->{callback} . '(' . $response->{content} . ')'
        if params->{callback};
};

dance;

