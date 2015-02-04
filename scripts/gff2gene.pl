#!/usr/bin/perl
use strict;
use warnings;

# usage script.pl <input>

# Simon Renny-Byfield, UC Davis, Jan 2015, version 1
# Access gene only entries in a gff3 file.

#open the gff file
open ( GFF , "<$ARGV[0]" ) || die;

#cycle through the file
while ( <GFF> ) {
	chomp;
	next if m/#/;
	my @data= split "\t";
	#only print lines where the third field is "gene"
	if ( $data[2] eq "gene" ) {
		m/ID=gene:(.+);b/;
		for my $i ( 0 .. 7 ) {
			print $data[$i] , "\t" ;			
		}#for
		print $1 ,"\n";
	}#if
}#while
close GFF;
exit;