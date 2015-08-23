> setInternet2(TRUE)
> url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> download.file(url,"./data/Project.zip")
> unzip(zipfile="./data/Project.zip",exdir="./data")

> dtActTest <- read.table("./data/UCI HAR Dataset/test/Y_test.txt",header=FALSE)
> dtActTrain <- read.table("./data/UCI HAR Dataset/train/Y_train.txt",header=FALSE)
> dtSubTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt",header=FALSE)
> dtSubTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt",header=FALSE)
> dtFeaTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt",header=FALSE)
> dtFeaTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt",header=FALSE)

> dtAct <- rbind(dtActTrain,dtActTest)
> dtSub <- rbind(dtSubTrain,dtSubTest)
> dtFea <- rbind(dtFeaTrain,dtFeaTest)
> dtFeaNames <- read.table("./data/UCI HAR Dataset/features.txt")
> head(dtFeaNames)
> names(dtAct) <- c("Activity")
> names(dtSub) <- c("Subject")
> names(dtFea) <- dtFeaNames$V2
> dt <- cbind(dtFea, dtSub, dtAct)
> head(dt)

> subdtFeaNames <- dtFeaNames$V2[grep("mean\\(\\)|std\\(\\)", dtFeaNames$V2)]
> Names <- c(as.character(subdtFeaNames),"Subject","Activity")
> dt <- subset(dt,select=Names)

> ActLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
> library(dplyr)
> ActLabels <- rename(ActLabels, Activity=V1)
> ActLabels
> dt <- merge(dt,ActLabels,by="Activity",all=TRUE)
> dt <- select(dt,-Activity)
> dt <- rename(dt,Activity=V2)
>head(dt)
>dt <- arrange(dt,Subject)
>head(dt)

> names(dt) <- gsub("^t", "time", names(dt))
> names(dt) <- gsub("^f", "freq", names(dt))
> names(dt) <- gsub("Acc", "Accelerometer", names(dt))
> names(dt) <- gsub("Gyro", "Gyroscope", names(dt))
> names(dt) <- gsub("Mag", "Magnitude", names(dt))
> names(dt) <- gsub("BodyBody", "Body", names(dt))
> names(dt)
> dt2<-aggregate(. ~Subject + Activity, dt, mean)
> dt2<-dt2[order(dt2$Subject,dt2$Activity),]
> write.table(dt2, file="tidydata.txt",row.name=FALSE)
