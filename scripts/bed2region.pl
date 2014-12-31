#!/usr/bin/perl
use strict;
use warnings;

# usage script.pl <input>

# Simon Renny-Byfield, UC Davis, December 2014, version 1
# A script to conver .bed style files to "region files" for 
# angsd input.

# Chr1	1000	2000

#to

# Chr1:1000-2000

#open the input file
open ( IN , $ARGV[0] ) || die "Could not open file $ARGV[0]: $!\n";

#cycle thru the input file
while ( <IN> ) {
	my @data = split , "\s+";
	print $data[0] , ":" , $data[1] , "-" , $data[2] , "\n";
}#while

exit;
