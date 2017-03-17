#!/usr/bin/perl -w

use strict;

use XML::XPath;
use XML::XPath::XMLParser;
#use OpenOffice::OODoc;
use Graph;
use Graph::Traversal::DFS;
#use Data::Dumper;
use HTML::Table;



#list of all RSA models
my @emxFileList = `ls asset.emx`;

my $L1HeadingStyle = 'Heading 1';
my $L2HeadingStyle = 'Heading 2';

foreach my $modelFile (@emxFileList) {
	print "Current model file is " . $modelFile;
	chomp $modelFile;
	die "No file specified!" unless ($modelFile);

	my $parser = XML::XPath->new(filename => $modelFile);

	#get the model name, should only return one element - 0th element
	my @modelNameArray = $parser->find('//uml:Model')->get_nodelist;
	my $modelName = $modelNameArray[0]->getAttribute('name');
	#____________________________


	my @activityDiagrams = $parser->find('//packagedElement[@xmi:type="uml:Activity"]')->get_nodelist;
	#print "activities has ". scalar @activities ." elements \n";
	foreach my $activityDiagram (@activityDiagrams) {

		#get the table setup
		#my $mainTable = new HTML::Table(-style=>'color: blue');
		my $mainTable = new HTML::Table();
		$mainTable->setBorder(1);
		#__________________________________
		

		#this hash has the node to comment mapping
		my %nodes;

		#create the directed graph
		my $graph = Graph->new;

		#get the name
		my $activityDiagramName = $activityDiagram->getAttribute('name');
		print "Processing $activityDiagramName \n";

		#this is the SUC description
		my $sucDesc = $activityDiagram->find('ownedComment/body')->string_value;

		#construct filename
		my $fileName = 'output/'.$modelName."-".$activityDiagramName.'.doc';

		open (FILE, ">$fileName") or die $!;

		#get the HTML doc setup
		print FILE '<html>';
		#eliminate blanks
		$fileName =~ s/ +//g;
		
		#add a heading
		print FILE "<center><h1>".$activityDiagramName."</h1></center>";

		
		#place the description
		print FILE '<h2>SUC Description</h2>';
		print FILE "<p>$sucDesc</p>";

		#create the Actors heading
		print FILE '<h2>Actors</h2>';

		#actors live in ActivityPartitions
		my @actors = $parser->find('./group[@xmi:type="uml:ActivityPartition"]',$activityDiagram)->get_nodelist;

		my $row = 0;
		foreach my $actor (@actors) {
			my $actorName = $actor->getAttribute('name');
			print FILE "<p>$actorName</p>";
		}
		
		#new Activities heading
#		$document->appendHeading(text => 'Activities', level =>'1', style => $L1HeadingStyle);
		print FILE '<h2>Activities</h2>';
#------------
		my @edges = $parser->find('./edge', $activityDiagram)->get_nodelist;

		foreach my $edge (@edges) {
			my $source = $edge->getAttribute('source');
			my $target = $edge->getAttribute('target');
#			print "source: $source target: $target \n";
			$graph->add_edge($source,$target);
		}
#------------

		#how many activities?
		my @activities = $parser->find('./node',$activityDiagram)->get_nodelist;
		my $totalActivities = scalar @activities;

		my $columns = 2;

		my $precondition = '';
		my $postcondition = '';

		foreach my $node (@activities) {
			my $commentBody = $node->find('ownedComment/body')->string_value;
			my $nodeName = $node->getAttribute('name');
			my $nodeId = $node->getAttribute('xmi:id');
			my $nodeType = $node->getAttribute('xmi:type');
			my $nodeSource = $node->getAttribute('incoming');
			my $nodeTarget = $node->getAttribute('outgoing');

			#this hash is needed to match up the graph edges with the comments and edge(node) type	
			$nodes{$nodeId}{'nodeName'} = $nodeName;
			$nodes{$nodeId}{'commentBody'} = $commentBody;
			$nodes{$nodeId}{'nodeType'} = $nodeType;
		}

		#perform the DF search
		my $search = Graph::Traversal::DFS->new($graph);
		$search->dfs;
		my @searchedNodes = $search->postorder;
		#nodes come back End first, need to reverse this
		foreach (reverse $search->dfs) {
			my $skip = 0;
			my $nodeName = $nodes{$_}{'nodeName'};
			my $nodeType = $nodes{$_}{'nodeType'};
			my $commentBody = $nodes{$_}{'commentBody'};

			if (($nodeType eq 'uml:InitialNode') || ($nodeType eq 'uml:ActivityFinalNode') || ($nodeName eq '')) {
				$skip = 1;
			}

			$mainTable->addRow($nodeName,$commentBody) unless ($skip == 1);
			#printLine($nodeName,$commentBody) unless ($skip == 1);

			#populate the pre/post conditions which are stored as documentation within Intial|Final Nodes
			$precondition = $commentBody if ($nodeType eq 'uml:InitialNode');
			$postcondition = $commentBody if ($nodeType eq 'uml:ActivityFinalNode');
		}

		print FILE $mainTable->getTable;

		print FILE '<h2>Preconditions</h2>';
		print FILE "<p>$precondition</p>";

		print FILE '<h2>Postconditions</h2>';
		print FILE "<p>$postcondition</p>";


#		print "______________________________________\n";
		print FILE "</html>";
		close FILE;
	}
}

sub printLine {
	my $nodeName = shift;
	print FILE $nodeName."\n";
	my $comment = shift;
	print FILE '	'.$comment."\n";
}
