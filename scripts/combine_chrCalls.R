# Simon Renny-Byfield, University of California, Davis
# 26th Jan `15
# UC Davis

# Used to combine seperate chr runs of cn.mops into single data file

#set up an empty variable to hold all the data
all.data<-NULL
all.res<-NULL
for ( i in 1:10 )  {
  #set the wd
  setwd("/group/jrigrp4/cn.mops/output/run1")
  load(paste("bamDataRanges_",i,".RData",sep=""))
  print(dim(cnvdf))
  #merge the data
  all.data<-rbind(all.data,cnvdf)
  save(file=paste0("cnv_object",i,".RData"), res)
}#for
print(dim(all.data))

#save the file
cnvdf<-all.data
save(file="cnv_calls.RData", cnvdf)
