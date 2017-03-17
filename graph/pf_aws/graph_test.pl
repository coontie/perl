#!/usr/bin/perl -w
#
use strict;
use warnings;

use Graph;
use Graph::Traversal::DFS;

my $graph = Graph->new();
$graph->add_edges( ['A','B'], ['B','C'], ['C','D'], ['D','E'], 
                   ['A','b'], ['b','c'], ['c','d'], ['d','e']);

my $trav = Graph::Traversal::DFS->new($graph);
print join("\n", $trav->dfs());
