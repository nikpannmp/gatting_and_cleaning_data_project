library(reshape2)

#Checks if file exists and download the file:
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"
if(!file.exists(zipFile)) {
download.file(fileUrl, zipFile, method="curl")
}

#Unzips file:
if (!file.exists("UCI HAR Dataset")) { 
    unzip(zipFile) 
}

#Load activity labels and features
activ.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activ.labels[,2] <- as.character(activ.labels[,2])
feat <- read.table("UCI HAR Dataset/features.txt")
feat[,2] <- as.character(features[,2])

#Extracts only information relevant to mean and standard deviation
feat.wanted <- grep(".*mean.*|.*std.*", feat[,2])
feat.wanted.names <- features[feat.wanted,2]
feat.wanted.names = gsub('-mean', 'Mean', feat.wanted.names)
feat.wanted.names = gsub('-std', 'Std', feat.wanted.names)
feat.wanted.names <- gsub('[-()]', '', feat.wanted.names)

#Loads activity and subject data
train <- read.table("UCI HAR Dataset/train/X_train.txt")[feat.wanted]
train.activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train.subjects, train.activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[feat.wanted]
test.activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test.subjects, test.activities, test)

#Merges datasets and add labels
merged <- rbind(train, test)
colnames(merged) <- c("subject", "activity", feat.wanted.names)

#Converts the activity and subject columns into factors
merged$activity <- factor(merged$activity, levels = activ.labels[,1], labels = activ.labels[,2])
merged$subject <- as.factor(merged$subject)

##Melt data using reshape2 library
merged.melted <- melt(merged, id = c("subject", "activity"))
merged.mean <- dcast(merged.melted, subject + activity ~ variable, mean)

#Writes the final result to tidy.txt
write.table(merged.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

