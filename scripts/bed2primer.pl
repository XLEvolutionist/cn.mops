#!/usr/bin/perl
use strict;
use warnings;
use Bio::DB::Fasta;

####
# A short script to generate primers from a set of intervals (bed file)
# given a reference genome, preferably masked.
####

# Simon Renny-Byfield, UC Davis Jan 2015

# usage script.pl <ref.bed> <ref.fa>

#declare global variables
my %intervals;

# generate a Bio::DB::Object
my $db = Bio::DB::Fasta->new($ARGV[1]);

####
# Open the files and read in the data
####

open ( BED , $ARGV[0] ) || die;

#open a TEMP file


while ( <BED> ) {
	open( TEMP , ">p3.input" ) || die;
	my @data = split /\t/;
	my $seqstr   = $db->seq($data[0], $data[1] => $data[2]);
	my $geneID = $data[3];
	chomp $geneID;
	# generate a input file for primer3
	print TEMP "SEQUENCE_ID=x
SEQUENCE_TEMPLATE=$seqstr
PRIMER_TASK=generic
PRIMER_PICK_LEFT_PRIMER=1
PRIMER_PICK_INTERNAL_OLIGO=0
PRIMER_PICK_RIGHT_PRIMER=1
PRIMER_OPT_SIZE=18
PRIMER_MIN_SIZE=15
PRIMER_MAX_SIZE=21
PRIMER_MAX_NS_ACCEPTED=0
PRIMER_NUM_RETURN=1
PRIMER_PRODUCT_SIZE_RANGE=75-300
P3_FILE_FLAG=1
PRIMER_EXPLAIN_FLAG=1
PRIMER_THERMODYNAMIC_PARAMETERS_PATH=/Users/simonrenny-byfield/primer3-2.3.6/src/primer3_config/
=";
	# now execute the primer 3 command and save the output;
	my $cmd="/Users/simonrenny-byfield/primer3-2.3.6/src/primer3_core p3.input";
	#store in an array
	my @output = `$cmd`;
	chomp @output;
	print "$geneID\t$output[25]\t$output[29]\t$output[26]\t$output[30]\n";
	# extract some info from the primer3 run.
	#my $
	close TEMP;
}#while

exit;