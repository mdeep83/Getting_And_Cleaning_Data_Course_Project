# Function written to complete "Getting and Cleaning Data Course Project" on Coursera.

# The function performs below mentioned steps -
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.

# PLease ensure that the working directory is same as that of the directory where UCI HAR Dataset was extracted.

run_analysis <- function(){
  
  #loading test data  
  subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
  X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
  Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
  
  #loading training data
  subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
  X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
  Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
  
  #loading features and activities information
  features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel"))
  activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel"))
  
  #remove underscores from activity names
  activities$activityLabel <- gsub("_", "", as.character(activities$activityLabel))
  
  
  
  
  #merging test and training data
  subject <- rbind(subject_test, subject_train)
  X <- rbind(X_test, X_train)
  Y <- rbind(Y_test, Y_train)
  
  #To extract only measurements on the mean and standard deviation for each measurement.
  includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)
  X <- X[, includedFeatures]
  
  #head(X,10)
  
  #naming data
  names(subject) <- "subjectId"
  names(X) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures])
  names(Y) = "activityId"
  
  #merge data frames
  activity <- merge(Y, activities, by="activityId")$activityLabel
  data <- cbind(subject, X, activity)
  
  #write tidy data to text file.
  write.table(data, "merged_tidy_data.txt")
  
  #create a dataset grouped by subject and activity after applying SD and Mean calculations
  library(data.table)
  
  dataDT <- data.table(data)
  calculatedData<- dataDT[, lapply(.SD, mean), by=c("subjectId", "activity")]
  
  write.table(calculatedData, "calculated_tidy_data.txt")
  
}