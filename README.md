This is the README for Course 3 "getting and cleaning data" week 4 peer graded assignment.

My work involves the following steps to create a tidy dataset.

### S0 : setting working directory
#setwd("E:/大学/2025-2026 大四/coursera/R/COURSE 3/Coursera 3 peer-graded assignment")



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
colnames(dataset)[1] <- "activities"
colnames(dataset)[2] <- "subjects"
dataset <- dataset[order(dataset$activities), ]

colnames(actLabs) <- c("code", "names")
dataset$activities <- actLabs$names[match(dataset$activities, actLabs$code)]
dataset <- dataset[order(dataset$subjects), ]



### S4 : extract the means and stds 
m_std_col <- grepl("activities|subjects|mean\\(\\)|std\\(\\)", names(dataset))
DS1 <- dataset[, m_std_col]



### S5 :grouping data and calculate the average
library(dplyr)
DS2 <- DS1 %>%
    group_by(activities, subjects) %>%
    summarize(across(everything(), mean, na.rm = TRUE), .groups = "drop")
