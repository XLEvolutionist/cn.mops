# Simon Renny-Byfield
# 16/12/2014
# do a CNV call for 20 teosine lines (plus TIL01) from Palmar Chico
# modified from a script provided by Jinliang

args <- commandArgs(trailingOnly = TRUE)

#source("http://bioconductor.org/biocLite.R")
#biocLite("cn.mops")
len<-100
library(cn.mops)
BAMFiles <- list.files(path="/group/jrigrp4/cn.mops/data", pattern="sorted.bam$",full.names=TRUE)
setwd("/group/jrigrp4/cn.mops/data")

chrs <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")
#for each chromosome
for (i in chrs ) {
	setwd(args[1])
	#try just chr 10 for now
	#chrs<-10
	#print(BAMFiles)
	bamDataRanges <- getReadCountsFromBAM(BAMFiles, refSeqName=i,  mode="paired",WL=len,parallel=11)

	#resHaplo <- haplocn.mops(bamDataRanges)
	#resCN <- calcIntegerCopyNumbers(resHaplo)
	# This function performs the cn.mops algorithm for copy number detection in NGS data
	res <- cn.mops(bamDataRanges,returnPosterior=TRUE,minWidth=1,segAlgorithm="DNAcopy", parallel = 11)
	resCNV <- calcIntegerCopyNumbers(res)

	### transform GRanges to data.frame
	mycnv <- cnvr(resCNV)


	cnvdf <- data.frame(chr=as.character(seqnames(mycnv)), start=start(mycnv), end=end(mycnv))
	callcnv <- mcols(mycnv)
	cnvdf <- cbind(cnvdf, callcnv)
	setwd("/group/jrigrp4/cn.mops/output")
	save(file=paste0("detectvion_object_", i, ".RData"), res)
	save(file=paste0("bamDataRanges_", i, ".RData"), list=c("bamDataRanges","cnvdf") ) 
}#for
