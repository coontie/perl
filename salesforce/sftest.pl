#!/usr/bin/perl -w
#
use strict;
use REST::Client;
use Data::Dumper;
use MIME::Base64;
use File::Slurp;
use JSON;

#
my $username='coontie@gmail.com';
my $password='Comment01yc19QUcqFPD8DfqNc6XjNsS4';
my $clientID='3MVG9yZ.WNe6byQAjqBJgR3JNqBDaxH.qFwub7jSsTevUkAn0Lq8i11R0V_RyEdqBkN6ExB1dwq3MSC_8xYlo';
my $secret='510805035098186381';
my $authHost='https://login.salesforce.com';
my $grant_type='password';
my $authURL='/services/oauth2/token';
my $client = REST::Client->new();
$client->setHost($authHost);

#my $getString="/services/oauth2/token&grant_type=$grant_type&client_id=$clientID&client_secret=$secret&username=$username&password=$password";
#print "string $getString \n";
my $params=$client->buildQuery([grant_type=>$grant_type,
				client_id=>$clientID,
				client_secret=>$secret,
				username=>$username,
				password=>$password]);

#perform the initial authentication, delete the leading ? with substr
$client->POST($authURL,substr($params,1), {'Content-type' => 'application/x-www-form-urlencoded'});

print "Status: ".$client->responseCode()."\n";

#read response
#print $client->responseContent();

my $decoded_json = decode_json( $client->responseContent() );
#print Dumper $decoded_json;
#print Dumper $params;

my $instance=$decoded_json->{'instance_url'};
my $accessToken=$decoded_json->{'access_token'};

my $headers = {Authorization => 'Bearer ' .$accessToken};
$client->setHost($instance);

my $objectUrl='/services/data/v26.0/sobjects/User/describe';

$client->GET($objectUrl,$headers);


print Dumper decode_json($client->responseContent());
