### S0 : setting working directory
setwd("E:/大学/2025-2026 大四/coursera/R/COURSE 3/Coursera 3 peer-graded assignment")

### S1 : read the txt tables 
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
    
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

actLabs <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")


### S2 : label the variable names and build the test and train datasets
colnames(X_test) <- features$V2
colnames(X_train) <- features$V2

test <- cbind(y_test, sub_test, X_test)
train <- cbind(y_train,sub_train, X_train)


### S3 : change the activity names
dataset <- rbind(test, train)
    # Q1: Merges the training and the test sets to create one data set.
colnames(dataset)[1] <- "activities"
    # Q3: Uses descriptive activity names to name the activities in the data set.
colnames(dataset)[2] <- "subjects"
    # Q4: Appropriately labels the data set with descriptive variable names. 
dataset <- dataset[order(dataset$activities), ]

colnames(actLabs) <- c("code", "names")
dataset$activities <- actLabs$names[match(dataset$activities, actLabs$code)]
dataset <- dataset[order(dataset$subjects), ]


### S4 : extract the means and stds 
m_std_col <- grepl("activities|subjects|mean\\(\\)|std\\(\\)", names(dataset))
DS1 <- dataset[, m_std_col]
    # Q2: Extracts only the measurements on the mean and standard deviation
    #     for each measurement. 


### S5 :grouping data and calculate the average
library(dplyr)
DS2 <- DS1 %>%
    group_by(activities, subjects) %>%
    summarize(across(everything(), mean, na.rm = TRUE), .groups = "drop")
    # Q5 : create a new dataset with the average of each variable
    #      for each activity and subject
write.table(DS2, "tidydata.txt", row.names = FALSE)
