run_analysis <- function(){
      setwd("C://Users//User//Desktop//datasciencecoursera")
      if (!file.exists("data/UCI HAR Dataset")) {
            fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
            zipfile="data/UCI_HAR_data.zip"
            message("Downloading data")
            download.file(fileURL, destfile=zipfile)
            unzip(zipfile, exdir="data")
      }
      if("plyr" %in% rownames(installed.packages()) == FALSE) {install.packages("plyr")}
      library(plyr)
      if("reshape2" %in% rownames(installed.packages()) == FALSE) {install.packages("reshape2")}
      library(reshape2)
      Xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")
      Ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")
      subtest<-read.table("./UCI HAR Dataset/test/subject_test.txt")
      Xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
      Ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
      subtrain<-read.table("./UCI HAR Dataset/train/subject_train.txt")
      Xfull<-rbind(Xtest, Xtrain)
      Yfull<-rbind(Ytest, Ytrain)
      subfull<-rbind(subtest, subtrain)
      features <- read.table("./UCI HAR Dataset/features.txt")
      colnames(Xfull)<-features[,2]
      rcols<- grepl("mean()",colnames(Xfull)) | grepl("std()",colnames(Xfull))
      Xmeanstd <- Xfull[,rcols]
      activities<-read.table("./UCI HAR Dataset/activity_labels.txt")
      Yfactor <- as.factor(Yfull[,1])
      Yfactor <- mapvalues(Yfactor,from = as.character(activities[,1]), to = as.character(activities[,2]))
      Xmeanstd <- cbind(Yfactor, Xmeanstd)
      colnames(Xmeanstd)[1] <- "activity"
      Xmeanstd <- cbind(subfull, Xmeanstd)
      colnames(Xmeanstd)[1] <- "subject"
      Xmelt<- melt(Xmeanstd,id.vars=c("subject","activity"))
      Xtidy <- dcast(Xmelt, subject + activity ~ ..., mean)
      dataframe <- as.data.frame(Xtidy)
      write.table(dataframe, "C://Users//User//Desktop//datasciencecoursera//xtidy.txt", row.names=FALSE)
      return(Xtidy)
}
