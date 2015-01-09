###
# A quick script to see overlap between CNV/PAV calls from
# cn.mops and those published in Swanson-Wagner et al., 2010
###

# Simon Renny-Byfield
# UC Davis, Jan 2015, version 1.

# In this instance we have one accession (TIL01) that has CNV/PAV
# calls in Swanson-Wagner and that we also have WGS Illumina data
# for. I have mapped the data to the reference genome, called the
# variants with cn.mops and will now compare these with the structural
# variants called with the CHIP in Swanson-Wagner et al. Hopefully 
# there will be some overlap.

#load in some R libraries
source("http://bioconductor.org/biocLite.R")
biocLite("GenomicRanges")
biocLite("GenomicFeatures")
biocLite("rtracklayer")
install.packages("devtools")
library(devtools)
library(GenomicRanges)
library("rtracklayer")
library(GenomicFeatures)

#firstly read in a gff of all the genes from RefV3.
gffRangedData<-import.gff("/Users/srbyfield/GitHub/cn.mops/geneRefV3.gff3")
genesGRanges<-as(gffRangedData, "GRanges")

# use gffRangedData$group to access the genes via name

#load in the swanson-wagner data
SWcnvs<-read.table("/Users/srbyfield/GitHub/cn.mops/sw_tables.txt", header = TRUE,sep = "\t")

# now filter the gene set to those genes with known PAVs/CNVs (i.e. SW genes)
SWgeneGRanges<-genesGRanges[gffRangedData$group %in% SWcnvs$GeneID]

# Note: Within the genotype columns a value of 1 indicates UpCNV while -1 indicates 
# DownCNV/PAV and 0 connotes no change.  
