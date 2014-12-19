# Simon Renny-Byfield, University of California, Davis
# 17th Dec `14

library(dplyr)
library(GenomicRanges)

# define a function to fileter CNVs
# only works with apply
# Define a useful function(s)
lineByline<-function(x) {
  # find the name, start ,and end to habd to overlapsAny
  name<-as.character(x[1])
  s<-as.numeric(x[2])
  e<-as.numeric(x[3])
  # calculate 50% of the cnver size
  minoverlap<-(e-s)/2
  # return FALSE if there is not sufficient overlap, TRUE if there is
  return(overlapsAny(GRanges(seqnames = name, ranges = IRanges(start = s, end = e)), GRrep , minoverlap=minoverlap ))
  #return(overlapsAny(GRanges(seqnames = name, ranges = IRanges(start = s, end = e)), GRrep ))
}# lineByline  

# load in the cn.mops data
load("/Users/simonrenny-byfield/bamDataRanges100.RData")
# load in the Zea repeats bed file
rep.bed<-read.table("/Users/simonrenny-byfield/maize_genome/ZeaRefV3.bed")
dim(cnvdf)
# now filter the CNV calls for those that are deleted in at least one individual
cnvdf<-cnvdf[rowSums(sapply(cnvdf, '%in%', "CN0") )>0,]

# make a genomic ranges object of the cnvs
GRcnvs<-GRanges(seqnames = cnvdf$chr, ranges = IRanges(start = cnvdf[,2], end = cnvdf[,3]))
GRrep<-GRanges(seqnames=rep.bed$V1, ranges = IRanges(start=rep.bed$V2, end=rep.bed$V3))

hits = overlapsAny(GRcnvs,GRrep,ignore.strand = TRUE)
countOverlaps(GRcnvs,GRrep,ignore.strand = TRUE)[1831]

# We may need a really funcky apply or for loop to get the minimum overlap correct.
# what about making a GRanges object line by line over cnvdf and then seeing if the
# overlap is greater than 50%. This is really slow, but seems to do the job. We cannot 
# do it the regular way because minoverlap has to a single number, but the required
# overlap changes with each cnv.

screened<-cnvdf[!apply(cnvdf,1,function(x) lineByline(x)) ,]  
  