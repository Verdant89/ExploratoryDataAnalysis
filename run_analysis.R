#This script uses the data provided for the Programming Assignment and creates a tidy dataset
#that has the average value of mean + std for each activity (e.g. BodyAcc X) according to
#the type of data (i.e. train vs test)


setwd("C:\\Users\\David\\Documents\\Coursera\\3 - Getting and Cleaning Data\\Course Project")


download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "Samsung Galaxy Data.zip")
data <- read.table(unz("Samsung Galaxy Data", filename = "Samsung Galaxy Data"))

#Loading the data and the feature names
test.data <- read.table("X_test.txt")
train.data <- read.table("X_train.txt")
features <- read.table ("features.txt")

#Setting the right names for each of the columns of the data frames
names(test.data) <- features[,2]
names(train.data) <- features[,2]


#Creating an additional column for the type of data (train vs. test)
train.data$type <- "train"
test.data$type <- "test"

#Merging train and test data frames together
merge.data <- rbind(test.data, train.data)

#Manually subsetting all the columns named either mean() or std()
subset.data <- merge.data[,c(1:6, 41:46, 81:86, 121:126, 161:166, 201, 202, 214,
              215, 227,228,240,241,253,254, 266:271, 345:350, 424:429, 503, 
              504,516,517,529,530,542,543,562)]

#Descriptive names of the varaibles were previously added


#Creating the final tidy dataset 
#First I'll manually add the mean and std columns for each variable (e.g. tBodyAcc X, 
#tBodyAcc Y, tGravityAcc X...). Then I will do the mean for each activity (train and test)


#As for the first 30 activities in the subset.data the mean and std of the same
#activity are 3 columns apart(e.g. subset.data[,2] = tBodyAcc-mean()-Y and
#subset.data[,4] = tBodyAcc-std()-Y), this loop will automatically sum these first 15
#activities together

tidy <- as.data.frame(subset.data[,1]+subset.data[,4])

#Now that I've created the data.frame object I will start the loop previously mentioned

col.order <- c(2,3,7:9,13:15,19:21,25:27)

for(i in col.order) {
      
      col.name <- paste(i)
      
      tidy[,col.name] <- (subset.data[,i] + subset.data[,(i+3)])
}

#From column 31 to 40 the mean and std for the same activity are set one after the other
#i.e.subset.data[,31] = BodyAccMag mean; subset.data[,32] = BodyAccMag std...
col.order2 <- seq(31,40, by = 2)

for(i in col.order2) {
      
      col.name <- paste(i)
      
      tidy[,col.name] <- (subset.data[,i] + subset.data[,(i+1)])
}


#From 41 to 58 the order is the same as it was in step 1 (i.e. every 3 columns)

col.order3 <- c(41:43, 47:49, 53:55)

for(i in col.order3) {
      
      col.name <- paste(i)
      
      tidy[,col.name] <- (subset.data[,i] + subset.data[,(i+3)])
}

#From column 59 to 66 the order is the same as in step 2

col.order4 <- seq(59,66, by = 2)

for(i in col.order4) {
      
      col.name <- paste(i)
      
      tidy[,col.name] <- (subset.data[,i] + subset.data[,(i+1)])
}

#Now we need to add the Test/Train variable

tidy$type <- subset.data$type

#And rename the columns accordingly

names(tidy) <- c("tBodyAcc.x", "tBodyAcc.y", "tBodyAcc.z", 
                 "tGravityAcc.x", "tGravityAcc.y", "tGravityAcc.z", 
                 "tBodyAccJerk.x", "tBodyAccJerk.y", "tBodyAccJerk.z",
                 "tBodyGyro.x", "tBodyGyro.y", "tBodyGyro.z",
                 "tBodyGyroJerk.x", "tBodyGyroJerk.y", "tBodyGyroJerk.z",
                 "tBodyAccMag", "tGravityAccMag", "tBodyAccJerkMag",
                 "tBodyGyroMag", "tBodyGyroJerkMag", 
                 "fBodyAcc.x", "fBodyAcc.y", "fBodyAcc.z",
                 "fBodyAccJerk.x", "fBodyAccJerk.y", "fBodyAccJerk.z",
                 "fBodyGyro.x", "fBodyGyro.y", "fBodyGyro.z",
                 "fBodyAccMag", "fBodyAccJerkMag","fBodyGyroMag", 
                 "fBodyGyroJerkMag", "type")


#Now we just need to split the data by type (test vs train) and do the mean of the columns

split.data <- split(tidy[,1:33], tidy[,34])
final.tidy <- sapply(split.data, colMeans)
