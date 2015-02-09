# Simon Renny-Byfield
# 16/12/2014
# do a CNV call for 20 teosine lines (plus TIL01) from Palmar Chico
# modified from a script provided by Jinliang

args <- commandArgs(trailingOnly = TRUE)

#source("http://bioconductor.org/biocLite.R")
#biocLite("cn.mops")
#source("http://bioconductor.org/biocLite.R")
#biocLite("rtracklayer")

len<-1000
library(cn.mops)
library(rtracklayer)
library(GenomicRanges)
# make a GRanges object form the bed file
gene.bed<-read.table("/group/jrigrp4/freec/maize3/GeneZeaRefV3.bed")
# add 1 to each poisition (bed files are ofset by -1).
GRgenes<-GRanges(seqnames=gene.bed$V1, ranges = IRanges(start=gene.bed$V2-1, end=gene.bed$V3-1, names = gene.bed$V4))

BAMFiles <- list.files(path="/group/jrigrp4/cn.mops/data/filtered_genes10/", pattern=".bam$",full.names=TRUE)
#setwd("/group/jrigrp4/cn.mops/data")
setwd(args[1])
chrs <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")
#for each chromosome
for (i in chrs ) {
  #try just chr 10 for now
  #chrs<-10
  #print(BAMFiles)
  bamDataRanges <- getSegmentReadCountsFromBAM(BAMFiles,GR=GRgenes, refSeqName=i, mode="paired",WL=len,parallel=11)
  seqlevels(bamDataRanges)
  #resHaplo <- haplocn.mops(bamDataRanges)
  #resCN <- calcIntegerCopyNumbers(resHaplo)
  # This function performs the cn.mops algorithm for copy number detection in NGS data
  res <- exomecn.mops(bamDataRanges,returnPosterior=TRUE, minWidth=1, parallel = 11,minReadCount=0)
  resCNV <- calcIntegerCopyNumbers(res)
  
  ### transform GRanges to data.frame
  mycnv <- cnvr(resCNV)
  
  
  cnvdf <- data.frame(chr=as.character(seqnames(mycnv)), start=start(mycnv), end=end(mycnv))
  callcnv <- mcols(mycnv)
  cnvdf <- cbind(cnvdf, callcnv)
  save(file=paste0("detectvion_object_", i, ".RData"), res)
  save(file=paste0("bamDataRanges_", i, ".RData"), list=c("bamDataRanges","cnvdf") ) 
}#for

