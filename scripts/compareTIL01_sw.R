# A brief scrip to compare CNV calls from Swanson-Wagner, 
# with CNVs called from the cn.mops algorithm.
# Simon Renny-Byfield, UC Davis, Jan 2015

# load in the R modules 
library(dplyr)
library(GenomicRanges)
library(rtracklayer)

args <- commandArgs(trailingOnly = TRUE)

# set the wd
# setwd("/Users/simonrenny-byfield/CNV_PAV")
setwd(args[1])

####
# Load in the data
####

# firstly load in the gene and repeat data.
# gene.bed<-read.table("/Users/simonrenny-byfield/maize_genome/GeneZeaRefV3.bed")
# rep.bed<-read.table("/Users/simonrenny-byfield/maize_genome/RepeatZeaRefV3.bed")

# save(file="input_RData/beds.RData", list=c("rep.bed","gene.bed"))
# load("input_RData/beds.RData")
load("../input_RData/beds.RData")

# now load in the cnv calls
# load("input_RData/cnv_calls.RData")
load("cnv_calls.RData")

# now load in the SW CNV data
sw<-read.csv("../input_RData/SW_cnv_calls.csv")
swAll<-sw
# extract TIL01 and the gene names
sw<-sw[,c(1,4,34)]
#produce a list of genes with no evidence for CNVs in TIL01
swNeg<-subset(sw,sw$TIL1 == 0 )

####
# Extract the useful data
####

#modify the cn.mops data to look like the sw data
cnvdf<-sapply(cnvdf, function(x) as.numeric(gsub("CN","",x)))
# create a modify a temp df
tempdf<-cnvdf[,-c(1:3)]
tempdf[tempdf<2] <--1
tempdf[tempdf>2] <-1
tempdf[tempdf==2] <-0
# attribute this back to cnvdf
cnvdf[,-c(1:3)]<-tempdf

###
# Set up the some GRanges objects 
###

# create a GRanges object from the data frame
cn.mopsRanges<-makeGRangesFromDataFrame(data.frame(cnvdf), keep.extra.columns = TRUE)
# create a Granges object from the repeat data
GRrep<-GRanges(seqnames=rep.bed$V1, ranges = IRanges(start=rep.bed$V2, end=rep.bed$V3))
# dito for the gene annotationns
GRgenes<-GRanges(seqnames=gene.bed$V1, ranges = IRanges(start=gene.bed$V2, end=gene.bed$V3, names = gene.bed$V4))

###
# now annnotate CNVs with genes they overlap
###

#find the CNV calls from cn.mops that iverlap gene annotations
CNgenes<-subsetByOverlaps(cn.mopsRanges,GRgenes,ignore.strand = TRUE, minoverlap=1, type="any")

# now find the SW gene names in GRgenes and extract those from the object
swAll<- swAll[!duplicated(swAll[,1]),]

#grab the Swanson-Wagner CNV genes from the GRgenes object, by name
SWgenes<-GRgenes[names(GRgenes) %in% swAll[,1] ]

# now grab the appropriate CNV calls from the swAll df
swTrim<-swAll[swAll[,1] %in% names(SWgenes),c(1,34)]

# add a metadata column of the sw CNV calls for TIL01
values(SWgenes)<-swTrim[,2]

######
# Calculate overlaps between CNgenes (i.e. genes with cn.mops calls)
# and SWgenes (i.e. genes that have Swanson-Wagner calls)
######

# now figure out the total overlap between cnv calls in TIL01 and all of the 
# calls in sw, regardless of whether it is in TIL01 or not.
totalOverlap<-subsetByOverlaps(SWgenes,CNgenes,ignore.strand = TRUE, minoverlap=1, type="any")

# grab the sw genes with CNV calls in TIL01
swTIL<-SWgenes[SWgenes$value != 0]
# grab the cn.mops genes with calls in TIL01
cnTIL<-CNgenes[CNgenes$TIL01_sorted.bam !=0]

# now how many overlap with the cn.mops CNV calls?
TILvsTIL<-subsetByOverlaps(swTIL,cnTIL,ignore.strand = TRUE, minoverlap=1, type="any")
# so only 125/830 or ~15.1% recall between the chip and the cn.mops method.

# but do the calls agree???
idx.compare<-as.matrix(findOverlaps(swTIL,cnTIL,ignore.strand = TRUE, minoverlap=1, type="any"))
upDown.df<-cbind("sw"=swTIL$value[idx.compare[,1]],"cn.mops"=cnTIL$TIL01_sorted.bam[idx.compare[,2]])

length(upDown.df[,1][upDown.df[,1] == upDown.df[,2]])
#108/147 of the overlaps 73.5% of them agree in their call.

# now calculate the false positive rate, assuming that the sw is the gold standard
swNegTIL<-SWgenes[SWgenes$value == 0]

# break it down to up and down CNVs

# some important vairable
totalUp<-length(swTIL[swTIL$value == 1])
totalDown<-length(swTIL[swTIL$value == -1])
# access up sw CNVs 
up.idx<-as.matrix(findOverlaps(swTIL[swTIL$value == 1],cnTIL,ignore.strand = TRUE, minoverlap=1, type="any"))
upCNVs.df<-cbind("sw"=swTIL$value[up.idx[,1]],"cn.mops"=cnTIL$TIL01_sorted.bam[up.idx[,2]])
agreeUp<-length(upCNVs.df[,1][upCNVs.df[,1] == upCNVs.df[,2]])

# of the 830 sw CNVs in TIL01 163 are up CNVs
# we correctly call 27 of these thus 27/163 = 16.56%

# access down sw CNVs 
down.idx<-as.matrix(findOverlaps(swTIL[swTIL$value == -1],cnTIL,ignore.strand = TRUE, minoverlap=1, type="any"))
downCNVs.df<-cbind("sw"=swTIL$value[down.idx[,1]],"cn.mops"=cnTIL$TIL01_sorted.bam[down.idx[,2]])
agreeDown<-length(downCNVs.df[,1][downCNVs.df[,1] == downCNVs.df[,2]])

# of the 830 sw CNVs in TIL01 667 are down CNVs
# we correctly call 80 of these thus 80/667 = 12.0%


# calculate the overlap between negative calls in SWgenes
# and positive calls in cn.mops data
falsePositives<-subsetByOverlaps(swNegTIL,cnTIL,ignore.strand = TRUE, minoverlap=1, type="any")
# so a 345/2342 or ~14.7% of negative calls in sw have a call in cn.mops data.

# how many of these are down CNVs
falseDown<-subsetByOverlaps(swNegTIL,cnTIL[cnTIL$TIL01_sorted.bam == -1],ignore.strand = TRUE, minoverlap=1, type="any")
falseUp<-subsetByOverlaps(swNegTIL,cnTIL[cnTIL$TIL01_sorted.bam == 1],ignore.strand = TRUE, minoverlap=1, type="any")
###
# Make some tables to output some quality estimates
###

# a general summary of CNVs
allCalls<-data.frame("CNV Chip"=c(length(TILvsTIL),length(swTIL)-length(TILvsTIL),length(swTIL),(length(TILvsTIL)/length(swTIL))*100),"no CNV Chip"= c(length(falsePositives),length(swNegTIL)-length(falsePositives),length(swNegTIL),(length(falsePositives)/length(swNegTIL))*100))
rownames(allCalls)<-c("CNV cn.mops","no CNV cn.mops","total","%")
write.table(file="summary_allCalls.txt", allCalls)

# now for the overlapping CNV calls
direction.df<-data.frame("up"=c(agreeUp,totalUp-agreeUp,totalUp,(agreeUp/totalUp)*100),"down"=c(agreeDown,totalDown=agreeDown,totalDown,(agreeDown/totalDown)*100))
rownames(direction.df)<-c("CNV cn.mops","no CNV cn.mops","total","%")
write.table(file="summary_direction.txt", direction.df)

# now examine the false positives
falsePos.df<-data.frame("up CNVs" = c(length(falseUp), length(falseUp)+length(falseDown), 
                          (length(falseUp)/(length(falseUp)+length(falseDown)))*100 ), 
                              "down CNVs"=c(length(falseDown), length(falseUp)+length(falseDown), 
                                    (length(falseDown)/(length(falseUp)+length(falseDown)))*100 ))

write.table(file="falsePos_direction.txt", falsePos.df)


