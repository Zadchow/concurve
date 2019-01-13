context("Dataframe Structure")
test_that("meaninterval", {

  library(concurve)

  #Produce random sample data
  GroupA<-runif(100, min=0, max=100)
  GroupB<-runif(100, min=0, max=100)

  RandomData<-data.frame(GroupA, GroupB)

  bob<-meanintervals(GroupA, GroupB, RandomData)

  #Set sample dataframe.
  variable1<-rnorm(100)
  variable2<-rnorm(100)
  variable3<-rnorm(100)
  variable4<-rnorm(100)
  variable5<-rnorm(100)

  sampledf<-data.frame(variable1, variable2, variable3, variable4, variable5)

  columnnames<-c("lower.limit","upper.limit","intrvl.level","pvalue","svalue")

  colnames(sampledf)<-columnnames

  expect_equivalent(str(bob), str(sampledf))

})

test_that("geninterval", {

library(concurve)

#Produce random sample data
GroupA<-rnorm(50)
GroupB<-rnorm(50)

RandomData<-data.frame(GroupA, GroupB)

rob<-glm(GroupA ~ GroupB, data=RandomData)
bob<-genintervals(rob, "GroupB", method="lm")

#Set sample dataframe.
variable1<-rnorm(100)
variable2<-rnorm(100)
variable3<-rnorm(100)
variable4<-rnorm(100)
variable5<-rnorm(100)

sampledf<-data.frame(variable1, variable2, variable3, variable4, variable5)

columnnames<-c("lower.limit","upper.limit","intrvl.level","pvalue","svalue")

colnames(sampledf)<-columnnames

expect_equivalent(str(bob), str(sampledf))

})

test_that("metainterval", {

  library(concurve)
  library(metafor)

  #Produce random sample data
  GroupAData<-runif(20, min=0, max=100)
  GroupAMean<-round(mean(GroupAData), digits=2)
  GroupASD<-round(sd(GroupAData), digits=2)

  GroupBData<-runif(20, min=0, max=100)
  GroupBMean<-round(mean(GroupBData), digits=2)
  GroupBSD<-round(sd(GroupBData), digits=2)

  GroupCData<-runif(20, min=0, max=100)
  GroupCMean<-round(mean(GroupCData), digits=2)
  GroupCSD<-round(sd(GroupCData), digits=2)

  GroupDData<-runif(20, min=0, max=100)
  GroupDMean<-round(mean(GroupDData), digits=2)
  GroupDSD<-round(sd(GroupDData), digits=2)

  #Combine the data

  StudyName<-c("Study1", "Study2")
  MeanTreatment<-c(GroupAMean, GroupCMean)
  MeanControl<-c(GroupBMean, GroupDMean)
  SDTreatment<-c(GroupASD, GroupCSD)
  SDControl<-c(GroupBSD, GroupDSD)
  NTreatment<-c(20,20)
  NControl<-c(20,20)

  metadf<-data.frame(StudyName, MeanTreatment, MeanControl, SDTreatment, SDControl, NTreatment, NControl)

  #Use metafor to calculate the standardized mean difference

  library(metafor)

  dat<-escalc(measure="SMD", m1i=MeanTreatment, sd1i=SDTreatment, n1i=NTreatment,
              m2i=MeanControl, sd2i=SDControl, n2i=NControl, data=metadf)

  #Pool the data using a particular method. Here "FE" is the fixed-effects model

  res<-rma(yi, vi, data=dat, slab=paste(StudyName, sep=", "), method="FE", digits=2)

  #Calculate the intervals using the metainterval function

  metaf<-metaintervals(res)

  #Set sample dataframe.
  variable1<-rnorm(100)
  variable2<-rnorm(100)
  variable3<-rnorm(100)
  variable4<-rnorm(100)
  variable5<-rnorm(100)

  sampledf<-data.frame(variable1, variable2, variable3, variable4, variable5)

  columnnames<-c("lower.limit","upper.limit","intrvl.level","pvalue","svalue")

  colnames(sampledf)<-columnnames

  expect_equivalent(str(metaf), str(sampledf))

})