# A brief scrip to compare CNV calls from Swanson-Wagner, 
# with CNVs called from cn.mops.
# Simon Renny-Byfield, UC Davis, Jan 2015

#load in the R modules 
library(dplyr)
library(GenomicRanges)
library(rtracklayer)

# set the wd
setwd("/Users/simonrenny-byfield/CNV_PAV")

####
# Load in the data
####

# firstly load in the gene and repeat data.
# gene.bed<-read.table("/Users/simonrenny-byfield/maize_genome/GeneZeaRefV3.bed")
# rep.bed<-read.table("/Users/simonrenny-byfield/maize_genome/RepeatZeaRefV3.bed")

# save(file="input_RData/beds.RData", list=c("rep.bed","gene.bed"))
load("input_RData/beds.RData")

# now load in the cnv calls
load("input_RData/cnv_calls.RData")

####
# Extract the useful data
####

#extract the TIL01 calls
TIL01<-cnvdf[,c(1,2,3,24)]
# get rid of the annoying "CN" stuff
# clean up the data a bit
TIL01<-sapply(TIL01, function(x) gsub("CN","",x))
# make the data numeric
TIL01<-matrix(as.numeric(TIL01), ncol =dim(TIL01)[2], byrow=FALSE)
# now remove those sites which are not variable in TIL01
TIL01<-subset(TIL01,TIL01[,4] != 2)
# now load in the SW CNV data
sw<-read.csv("SW_data/SW_cnv_calls.csv")
swAll<-sw
# extract TIL01 and the gene names
sw<-sw[,c(1,4,34)]
#produce a list of genes with no evidence for CNVs in TIL01
swNeg<-subset(sw,sw$TIL1 == 0 )

# remove rows that have no CNVs in TIL01, i.e. rows with 0.
sw<-subset(sw, sw$TIL1 != 0)
# try overlap between any of these called CNVs, as opposed to just TIL01
# how many CNVs are called in TIL01
dim(sw)

####
# Now find cn.mops CNVs that overlap genes
####

# make a genomic ranges object of the cnvs, genes and repeats
TIL01cnvs<-GRanges(seqnames = TIL01[,1], ranges = IRanges(start = TIL01[,2], end = TIL01[,3]))
GRrep<-GRanges(seqnames=rep.bed$V1, ranges = IRanges(start=rep.bed$V2, end=rep.bed$V3))
GRgenes<-GRanges(seqnames=gene.bed$V1, ranges = IRanges(start=gene.bed$V2, end=gene.bed$V3, names = gene.bed$V4))


# overlaps between genes and cnvs, return GRanges object for only those genes that overlap
hits<-subsetByOverlaps(GRgenes,TIL01cnvs,ignore.strand = TRUE, minoverlap=1, type="any")

# what about overlap with SW CNV calls and cn.mops cnv calls?
dualCalls<-intersect(names(hits),as.character(sw[,1]))
# The overlap is not very good... at all. We don't spot many of SW calls in our cn.mops calls... :(
length(dualCalls)

#how many gene annotations (without respecxt to CNVs) can we find in sw? All hopefully.
#intersect(names(GRgenes),as.character(sw[,1]))
length(intersect(names(GRgenes),as.character(sw[,1])))
####
# Now compare all vs all comparisons with Swanson-Wagner call vs all cn.mops calls
####

#all the cnvs, regardless of accession
cn.mopsCNVs<-GRanges(seqnames = cnvdf[,1], ranges = IRanges(start = cnvdf[,2], end = cnvdf[,3]))

hits<-subsetByOverlaps(GRgenes,TIL01cnvs,ignore.strand = TRUE, minoverlap=1, type="any")
dualCalls<-intersect(names(hits),as.character(sw[,1]))
length(dualCalls)

# overlaps between genes and cnvs, return GRanges object for only those genes that overlap
hitsAllvAll<-subsetByOverlaps(GRgenes,cn.mopsCNVs,ignore.strand = TRUE, minoverlap=1, type="any")

# what about overlap with SW CNV calls and cn.mops cnv calls?
dualCallsAllvAll<-intersect(as.character(hitsAllvAll$factor),as.character(swAll[,1]))
# The overlap is not very good... at all. We don't spot many of SW calls in our cn.mops calls... :(
length(dualCallsAllvAll)
dim(swAll)

###
# Now check the false positive rate
###

# How many of the "normal" Swanson-Wagner genes are called as CNVs in cn.mops runs
falseCalls<-length(intersect(names(hits),as.character(swNeg[,1])))
falsePosRate<-falseCalls/dim(swNeg)[1]
# so a reasonably low false positive rate of ~11%.

####
# Output the co-ordinates of the Swanson-Wagner CNVs
####

SWgenes<-GRgenes[names(GRgenes) %in% as.factor(sw[,1]), ]

#output the Granges object as a bed file
export.gff(SWgenes, con="SWgenes.gff", version ="3")

