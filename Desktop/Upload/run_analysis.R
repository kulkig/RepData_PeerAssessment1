## Purpose of program is to collect, manipulate and clean data set
## Input : files from data files sources
## OUtput : 1. merged_data.txt (for the merged data set with the Mean and Std data)
##          2. tidy_data.txt (calculates the mean of every activity and subject in 1.)    
##Version : 1.0
## Date : 10 June 2015
## Data files source : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## TODO : download the *.zip, unzip , copy and paste them to the data subfolder 
##under your working directory. Eg. (working directory/data)



## Step 1. Merge the training and test sets to create one data set 
#read and merge the training and test training labels into a single data set
temp1 <- read.table("./data/train/x_train.txt")
temp2 <- read.table("./data/test/x_test.txt")
trainingData <- rbind (temp1, temp2)    #dim 10299*561

#read and merge the training and test subject_sets into a single data set
temp1 <- read.table("./data/train/subject_train.txt")
temp2 <- read.table("./data/test/subject_test.txt")
subjectData <- rbind (temp1, temp2)     #dim 10299*1

#read and merge the training and test training labels into a single data set
temp1 <- read.table("./data/train/y_train.txt")
temp2 <- read.table("./data/test/y_test.txt")
labelData <- rbind (temp1, temp2)       #dim 10299*1

## Step2. Extracts only the measurements on the mean and standard deviation for 
# each measurement.
features <- read.table("./data/features.txt")       #dim 561*2
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])   #contains 66 nos.

#subset to contain only those columns with mean or std deviation
meanstdData <- trainingData[,meanStdIndices]        #dim 10299*66 

#provide the appropriate column names to the data set
names(meanstdData) <- make.names(features[meanStdIndices,2], unique = TRUE)
names(meanstdData) <- gsub("mean", "Mean", names(meanstdData))      #capitalize M
names(meanstdData) <- gsub("std", "Std", names(meanstdData))    #capitalize S
names(meanstdData) <- gsub("\\.", "", names(meanstdData))       #remove the dots


## Step 3.Uses descriptive activity names to name the activities in the data set
activities <- read.table("./data/activity_labels.txt")

#format the data set, remove the _ and lower cases all the activities
activities [,2] <- gsub("_","", tolower(as.character(activities[,2])))
activities [,2] <- gsub("upstairs","Upstairs", activities[,2])
activities [,2] <- gsub("downstairs","Downstairs", activities[,2])

#create a vector to hold the activities labels
tempActivityLabel <-  activities[labelData[, 1], 2] 
#replace the labels with the correct labels
labelData[,1] <- tempActivityLabel 
names(labelData) <- "activity"


## Step 4. Appropriately labels the data set with descriptive variable names 
names(subjectData) <- "subject"
cleanedData <- cbind(subjectData, labelData, meanstdData)   #dim 10299 *68
write.table(cleanedData, "merged_data.txt", row.names = FALSE) # write out the 1st dataset


## Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
cleanedData$activity <- factor(cleanedData$activity)
cleanedData$subject <- factor(cleanedData$subject)

tidyData <- suppressWarnings(aggregate(cleanedData, 
                      list(activity = cleanedData$activity, subject = cleanedData$subject), mean))

tidyData <- tidyData[-c(3:4)]       #drop the NA columns
write.table(tidyData, "tidy_data.txt", row.names = FALSE) # write out the 2nd dataset




