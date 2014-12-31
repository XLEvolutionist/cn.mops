# Simon Renny-Byfield
# 16/12/2014
# do a CNV call for 20 teosine lines from Palmar Chico
# modified from a script provided by Jinliang

#source("http://bioconductor.org/biocLite.R")
#biocLite("cn.mops")
len<-100
library(cn.mops)
BAMFiles <- list.files(path="/group/jrigrp4/cn.mops/data", pattern="sorted.bam$")
setwd("/group/jrigrp4/cn.mops/data")

chrs <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")
#for each chromosome
for (i in chrs ) {
	setwd("/group/jrigrp4/cn.mops/data")
	#try just chr 10 for now
	#chrs<-10
	#print(BAMFiles)
	bamDataRanges <- getReadCountsFromBAM(BAMFiles, refSeqName=i,  mode="paired",WL=len)

	#resHaplo <- haplocn.mops(bamDataRanges)
	#resCN <- calcIntegerCopyNumbers(resHaplo)
	# This function performs the cn.mops algorithm for copy number detection in NGS data
	res <- cn.mops(bamDataRanges)
	resCNV <- calcIntegerCopyNumbers(res)

	### transform GRanges to data.frame
	mycnv <- cnvr(resCNV)


	cnvdf <- data.frame(chr=as.character(seqnames(mycnv)), start=start(mycnv), end=end(mycnv))
	callcnv <- mcols(mycnv)
	cnvdf <- cbind(cnvdf, callcnv)
	setwd("/group/jrigrp4/cn.mops/output")
	save(file=paste("bamDataRanges_", i, ".RData") list=c("bamDataRanges","cnvdf") ) 
}#for
