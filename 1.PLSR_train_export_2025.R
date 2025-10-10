#function to remove outliers more than 5 sd from the mean
std_outliers=function(var){
  score <- mean(var,na.rm=T)+5*sd(var,na.rm=T)
  print(which(var<score))
  return(ifelse(var<score,var,NA))
}


rmse=function(m,x)
{
  sqrt(mean((x-m)^2,na.rm=T))
}

mae=function(m,x)
{
  mean(abs(((x-m))),na.rm=T)
}

#NOTE THAT FOR GLMS YOU CAN USE PREDICT INSTEAD OF X
lz<-function(x) {log(x+1)}

RSS1<-function(m,x) {sum((lz((m))-lz(x))^2)}
TSS1<-function(x) {sum((lz(x)-lz(mean(x)))^2)}


RSS<-function(m,x) {sum((((m))-(x))^2)}
TSS<-function(x) {sum(((x)-(mean(x)))^2)}


R2<-function(m,x,logo=F) {
  mors<-na.omit(data.frame(m,x))
  m<-mors$m
  x<-mors$x
  
  if(logo==F) {return(1-RSS(m,x)/TSS(x))} else {return(1-RSS1(m,x)/TSS1(x))}
}

library("caret")
library("pls")
library("e1071")

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
chems=read.csv("20200720_MASTER_AllSites_AllChem_NIRS_RefPred_BR.csv",na.strings=c(".",""))

#R2(chems$CP_Pred[which(chems$Site=="KGMagic")],chems$Monoterpenes_Ref[which(chems$Site=="KGMagic")])
#plot(chems$CP_Pred[which(chems$Site=="KGMagic")],chems$Monoterpenes_Ref[which(chems$Site=="KGMagic")])


chemistry=c("CP_Ref","Phenolics_Ref", "Monoterpenes_Ref","Coumarins_Ref")

sites<-unique(chems$Site)

chemsites=expand.grid(chemistry,sites)

rowy=rep(NA,times=nrow(chemsites))

for(i in 1:nrow(chemsites)){
  
  chs=subset(chems,chems$Site==chemsites[i,2])
  
rowy[i]=sum(na.omit(chs[,which(colnames(chs)==chemsites[i,1])]))

}

goodchem=chemsites[which(rowy!=0),]
chemuse<-unique(goodchem[,1])

spec_cols<-c(which(colnames(chems)=="X350"),which(colnames(chems)=="X2500"))

library(parallel) # Needed for the makeCluster call
pls.options(parallel = makeCluster(4, type = "PSOCK")) # PSOCK cluster, 4 CPUs

minnows=rep(NA,times=length(chemuse))
selected_ncomps=rep(NA,times=length(chemuse))

 for(j in 1:length(chemuse)){
#   
#   #give_em=data.frame(chems$Site,chems[,spec_cols[1]:spec_cols[2]])
# 
   give_em=data.frame(chems[,spec_cols[1]:spec_cols[2]])
#   
   goodies=which(is.na(colSums(chems[,spec_cols[1]:spec_cols[2]]))==F)
#   
   given=give_em[,goodies]
#   
#   #this is the bad bands as indicated by Asner
#   #gotten<-given[,which(colnames(given) %in% paste("X",c(c(379:439),c(1340:1480),c(1760:2022),c(2372:2512)),sep="") ==F)]
#   #gift=data.frame(Monoterpenes_Ref=kgmagic$Monoterpenes_Ref,gotten)[which(is.na(kgmagic$Monoterpenes_Ref)==F),]
#   
#   
   gift=na.omit(data.frame(Ref=std_outliers(chems[,which(colnames(chems)==chemuse[j])]),NIR=I(as.matrix(prospectr::gapDer(given,m = 2, w = 1, s = 1, delta.wav = 2)))))
#   #gift=na.omit(data.frame(Ref=std_outliers(chems[,which(colnames(chems)==chemuse[j])]),NIR=I(as.matrix(given))))
#   
#   
   yess=plsr(Ref~NIR,data=gift,ncomp=50,scale=TRUE,validation="CV")
#   
   rmseps <- c(RMSEP(yess, "CV")$val)
   maxIdx <- 50 + 1
   absBest <- which.min(rmseps[seq_len(maxIdx)])
#   
   minnows[j]<-absBest
#   
   selected_ncomps[j]<-selectNcomp(yess,"onesigma")
#   
 }


predictions=vector("list",length=length(chemuse))

chems$rowid<-c(1:nrow(chems))

for(j in 1:length(chemuse)){ 
gift=na.omit(data.frame(rowid=chems$rowid,Ref=std_outliers(chems[,which(colnames(chems)==chemuse[j])]),NIR=I(as.matrix(prospectr::gapDer(given,m = 2, w = 1, s = 1, delta.wav = 2)))))

loosers=rep(NA,times=nrow(gift))

for(k in 1:nrow(gift)){
  train=gift[-k,]
  test=gift[k,]

got_em=plsr(Ref~NIR,data=train,ncomp=minnows[j],scale=TRUE,validation="none")

loosers[k]<-predict(got_em,newdata=test)[,,minnows[j]]
print(k)
}
predictions[[j]]<-data.frame(loosers,gift$rowid)
print(chemuse[j])
}

save(predictions,file="loo_predicted_final.Rdata")
#


splt=function(x,split,num) {
  
  x<-as.character(x)
  p1=strsplit(x,split=split,fixed=T)
  p2=unlist(lapply(p1,"[",num))
  return(p2)
}

lapply(predictions,nrow)

for(jj in 1:length(chemuse)){
  
  colnames(predictions[[jj]])[1]<-paste(splt(as.character(chemuse[jj]),"_",1),"newpred",sep="_")
  
}

head(predictions[[1]])


head(predictions[[1]])
chemuse[[1]]


Crude_protein<-merge(chems,predictions[[1]],by.x="rowid",by.y="gift.rowid")


Phenolics<-merge(chems,predictions[[2]],by.x="rowid",by.y="gift.rowid")

Monoterpenes<-merge(chems,predictions[[3]],by.x="rowid",by.y="gift.rowid")

Coumarins<-merge(chems,predictions[[4]],by.x="rowid",by.y="gift.rowid")


write.csv(Crude_protein,file="Crude_protein.csv",row.names=F)
write.csv(Phenolics,file="Phenolics.csv",row.names=F)
write.csv(Coumarins,file="Coumarins.csv",row.names=F)
write.csv(Monoterpenes,file="Monoterpenes.csv",row.names=F)





 R2(Crude_protein$CP_newpred,Crude_protein$CP_Pred)
 0.7526576
 R2(Crude_protein$CP_newpred,Crude_protein$CP_Pred)
 0.7526576
 R2(Phenolics$Phenolics_newpred,Phenolics$Phenolics_Pred)
 0.6646513
 R2(Monoterpenes$Monoterpenes_newpred,Monoterpenes$Monoterpenes_Pred)
 0.8497624
 R2(Coumarins$Coumarins_newpred,Coumarins$Coumarins_Ref)

