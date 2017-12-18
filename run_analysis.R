## Download the resouces and unzip it into a folder

filename <- "uci_har_dataset.zip"

url <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = filename)

if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

setwd("UCI HAR Dataset/")

# 1. Merges the training and the test sets to create one data set.

## a. read file
features <- read.table("features.txt")

subject_train <- read.table("train/subject_train.txt")
y_train <- read.table("train/y_train.txt")
x_train <- read.table("train/X_train.txt")


subject_test <- read.table("test/subject_test.txt")
y_test <- read.table("test/y_test.txt")
x_test <- read.table("test/X_test.txt")

names(subject_train) <- c("subjectId")
names(y_train) <- c("activityId")
names(x_train) <- features[,2]

names(subject_test) <- c("subjectId")
names(y_test) <- c("activityId")
names(x_test) <- features[,2]

## b. combine the sets
train_set <- cbind(subject_train, y_train, x_train)
test_set <- cbind(subject_test, y_test, x_test)

dataset <- rbind(train_set, test_set)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

column_names <- names(dataset)
ext_column_number <- grep("subjectId|activityId|mean[(]|std[(]", column_names)
ext_dataset <- dataset[ext_column_number]

# 3. Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("activity_labels.txt")
names(activity_labels) <- c("activityId", "activity")
ext_dataset <- merge(x=ext_dataset, y=activity_labels, by="activityId")
ext_dataset <- ext_dataset[c(2,69,3:68)]

#4. Appropriately labels the data set with descriptive variable names.

names(ext_dataset) <- gsub("tBody", "timeBody", names(ext_dataset))
names(ext_dataset) <- gsub("tGravity", "timeGravity", names(ext_dataset))
names(ext_dataset) <- gsub("fBody", "freqBody", names(ext_dataset))
names(ext_dataset) <- gsub("BodyBody", "Body", names(ext_dataset))
names(ext_dataset) <- gsub("mean", "Mean", names(ext_dataset))
names(ext_dataset) <- gsub("std", "Std", names(ext_dataset))
names(ext_dataset) <- gsub("[-]", "", names(ext_dataset))
names(ext_dataset) <- gsub("\\(|\\)", "", names(ext_dataset))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_set <- aggregate(. ~subjectId + activity, ext_dataset, mean)
tidy_set <- tidy_set[order(tidy_set$subjectId, tidy_set$activity),]
write.table(tidy_set, "tidy_set.txt", row.names=FALSE)


