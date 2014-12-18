#load in the cn.mops data
load("/Users/simonrenny-byfield/bamDataRanges.RData")
#load in the Zea repeats bed file
rep.bed<-read.table("/Users/simonrenny-byfield/maize_genome/ZeaRefV3.bed")
library(dplyr)
library(GenomicRanges)
dim(cnvdf)
#now filter the CNV calls for those that are deleted in at least one individual
cnvdf<-cnvdf[rowSums(sapply(cnvdf, '%in%', "CN0") )>0,]

#make a genomic ranges object of the cnvs
GRcnvs<-GRanges(seqnames = cnvdf$chr, ranges = IRanges(start = cnvdf[,2], end = cnvdf[,3]))
GRrep<-GRanges(seqnames=rep.bed$V1, ranges = IRanges(start=rep.bed$V2, end=rep.bed$V3))

hits = overlapsAny(GRcnvs,GRrep,ignore.strand = TRUE)
countOverlaps(GRcnvs,GRrep,ignore.strand = TRUE)[1831]

#We may need a really funcky apply or for loop to get the minimum overlap correct.