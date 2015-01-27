# A brief scrip to compare CNV calls from Swanson-Wagner, 
# with CNVs called from cn.mops.
# Simon Renny-Byfield, UC Davis, Jan 2015

#firstly load in the gene data.
gene.bed<-read.table("/Users/simonrenny-byfield/maize_genome/GeneZeaRefV3.bed")
rep.bed<-read.table("/Users/simonrenny-byfield/maize_genome/RepeatZeaRefV3.bed")

save(file="/Users/simonrenny-byfield/CNV_PAV/input_RData/beds.RData", list=c("rep.bed","gene.bed"))