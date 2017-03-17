#!/usr/bin/perl -w
#
use strict;
use REST::Client;
use Data::Dumper;
use MIME::Base64;
use File::Slurp;
use XML::Tidy;
use XML::XPath;
use XML::XPath::XMLParser;
    

#
my $username='V_Deloitte_C_Jake';
my $password='6122085773';
my $host='https://meqc.verizon.net';
my $headers = {Authorization => 'Basic ' . encode_base64($username.':'.$password)};
my $cookieFile='./cookie.txt';
my $cookie='';

my $client = REST::Client->new();
$client->setHost($host);

#retrieve the previous cookie, see if it's still valid
#my $cookie=read_file($cookieFile);

#perform the initial authentication, only need the HEAD
$client->HEAD('/qcbin/authentication-point/authenticate', $headers);

#read response
#my $response = $xmlResponse->XMLin($client->responseContent());
#print $client->responseContent();
#print "code: ". $client->responseCode(). "\n";

#get one field from the header
$cookie = $client->responseHeader('Set-Cookie'). "\n";

#get rid of the trailing fluff
$cookie=~s/;\ Path=\/,? ?//g;

#print "token ".$cookie."\n";

#using the token from the cookie, call the API. Change the header first to insert the token
#$client->GET('/qcbin/rest/domains/VAST/projects/VDMS_Gen2/customization/entities/requirement/fields',{Cookie => $cookie});
#$client->GET('/qcbin/rest/domains/VAST/projects/VDMS_Gen2/requirements/18816',{Cookie => $cookie});

#print Dumper($xmlResponse->XMLin($client->responseContent()));
#print $client->responseContent();
#my $file="/home/ig/Documents/scripts/perl/rest/new.xml";
#my $file="/home/ig/Documents/scripts/perl/rest/update_req.xml";

#my $entityUpdate=read_file($file);


#print Dumper($entityUpdate);

#print "Get requirement status\n";
#$client->GET('/qcbin/rest/domains/VAST/projects/VDMS_Gen2/requirements/18816',{Cookie => $cookie});
$client->GET('/qcbin/rest/domains/VAST/projects/VDMS_Gen2/requirements?query={user-14[=2958]}&fields=dev-comments',{Cookie => $cookie});
#print "Status: ".$client->responseCode()."\n";
#print $client->responseContent();
#my $tidyObj = XML::Tidy->new('xml' => $client->responseContent());
#$tidyObj->tidy();
#print $tidyObj->toString();

my $result=XML::XPath->new('xml' => $client->responseContent());
#my $path='//Field[@Name=\'dev-comments\']';
my $path='//Field/Value';
my $nodeset=$result->find($path);

foreach my $node ($nodeset->get_nodelist) {
        print XML::XPath::XMLParser::as_string($node), "\n";
}
#print Dumper($xmlResponse->XMLin($client->responseContent()));


#print "updating requirement \n";
#$client->PUT('/qcbin/rest/domains/VAST/projects/VDMS_Gen2/requirements/18816',$entityUpdate,{Cookie => $cookie, 'Content-Type' => 'application/xml', 'Accept'=>'application/xml'});
#print "Status: ".$client->responseCode()."\n";
#print Dumper($xmlResponse->XMLin($client->responseContent()));
#
#
#print "creating a defect \n";
#$client->POST('/qcbin/rest/domains/VAST/projects/VDMS_Gen2/requirements/18816',$entityUpdate,{Cookie => $cookie, 'Content-Type' => 'application/xml', 'Accept'=>'application/xml'});
#print "Status: ".$client->responseCode()."\n";
#print "Header: ".$client->responseHeader('Location')."\n";
#print Dumper($xmlResponse->XMLin($client->responseContent()));
