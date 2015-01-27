# Simon Renny-Byfield, University of California, Davis
# 17th Dec `14

# Takes cn.mops output and filters removing CNVs estimated over repeat regions.

library(dplyr)
library(GenomicRanges)

# define a function to filter CNVs
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
  # return(overlapsAny(GRanges(seqnames = name, ranges = IRanges(start = s, end = e)), GRrep ))
}# lineByline  

#set the wd
setwd("/Users/simonrenny-byfield/CNV_PAV")
# load in the cn.mops data
load("input_RData/cnv_calls.RData")
# load in the Zea repeats bed file
rep.bed<-read.table("bed_files/RepeatZeaRefV3.bed")
gene.bed<-read.table("bed_files/GeneZeaRefV3.bed")
save(file="input_RData/beds.RData", list=c(rep.bed,gene.bed))
dim(cnvdf)

# now filter the CNV calls for those that are deleted in at least one individual
# I don't think this is neccesary, what if all the lines have upCNVs.
# cnvdf<-cnvdf[rowSums(sapply(cnvdf, '%in%', "CN0") )>0,]

# clean up the data a bit
cnvcp<-sapply(cnvdf, function(x) gsub("CN","",x))
# make the data numeric
cnvcp<-matrix(as.numeric(cnvcp), ncol =dim(cnvdf)[2], byrow=FALSE)

# this will need to be changed, some individuals have more than two alleles, which makes
# assessing frequency a little troubling. Maybe wou should only consider those regions
# with max CN per individuals is 2

## remove cnvs that have high more than a diploid compliment.
#cnvcp<-cnvcp[apply(cnvcp[,-c(1:3)],1,function(x) max(x) < 3),]
# find the frequency of each cnv
frequency<-rowSums(cnvcp[,-c(1:3)])

# make a genomic ranges object of the cnvs
GRcnvs<-GRanges(seqnames = cnvcp[,1], ranges = IRanges(start = cnvcp[,2], end = cnvcp[,3]))
GRrep<-GRanges(seqnames=rep.bed$V1, ranges = IRanges(start=rep.bed$V2, end=rep.bed$V3))

hits <- overlapsAny(GRcnvs,GRrep,ignore.strand = TRUE)

# We may need a really funcky apply or for loop to get the minimum overlap correct.
# what about making a GRanges object line by line over cnvdf and then seeing if the
# overlap is greater than 50%. This is really slow, but seems to do the job. We cannot 
# do it the regular way because minoverlap has to a single number, but the required
# overlap changes with each cnv.

screened<-cnvcp[!apply(cnvcp,1,function(x) lineByline(x)) ,]
colnames(screened)<-colnames(cnvdf)
frequency<-rowSums(screened[,-c(1:3)])
save(file="output/screened_cnvs.RData", list=c(screened,frequency))
# now for each unique frequency, grab the appropriate CNVs
for ( i in unique(frequency) ) {
  print(i)
  # eventually output these CNVs as a region file, one for each level of frequency
  # find the index of cnvs with frequency i
  index<-which(frequency == i)
  # trim the table
  out<-screened[index,1:3]
  #colnames(out)<-c("chrom","start","end")
  # format so it doesn't ouput scientific notation
  #out<-format(out,scientific=FALSE)
  #out[,1]<-gsub("\\s+","",out[,1])
  #out<-apply(out,1,function(x) paste(x[1],":",x[2],"-",x[3]))
  #out<-apply(out,2,function(x)gsub('\\s+', '',x))
  #print(head(out))
  # write out the table
  write.table(out,file=paste("freq_",i,".bed", sep = ""), quote=FALSE, row.names = FALSE)
}#for


  