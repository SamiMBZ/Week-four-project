
#Download zip file into working directory
download.file ("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip")

#Unzip file into working directory
zipfile <- file.choose()
unzip (zipfile, exdir = "getwd()")

#View contents of the file and list all files
list.files ("UCI HAR Dataset/test", recursive = TRUE)

#Extract data from test folder into corresponding variables

Xtest <- read.table ("UCI HAR Dataset./test/X_test.txt", header = FALSE)

Ytest <- read.table ("UCI HAR Dataset./test/Y_test.txt", header = FALSE)

subjectest <- read.table ("UCI HAR Dataset./test/subject_test.txt", header = FALSE)

#Combine test data into one dataframe testdf

testdf <- cbind.data.frame(Ytest, subjectest, Xtest)


#Extract data from train folder into corresponding variables

Xtrain <- read.table ("UCI HAR Dataset/train/X_train.txt", header = FALSE)

Ytrain <- read.table ("UCI HAR Dataset/train/y_train.txt", header = FALSE)

subtrain <- read.table ("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#Combine train data into one dataframe traindf

traindf <- cbind.data.frame (Ytrain,subtrain, Xtrain)

#Inspect both dataframes
str (testdf)
str (traindf)

#Combine both into a larger dataframe
#Inspect resultant dataframe
bigdf <- rbind (testdf,traindf)
str (bigdf)

#Extract data from features into variable features
#View data table
features <- read.table ("UCI HAR Dataset/features.txt", header= FALSE)
str (features)

#Name the columns on the dataframe bigdf
colnames (bigdf) [3:563] <- features$V2
colnames (bigdf) [1:2] <- c("Activity", "Subject")

#Read data from activity_labels.txt into a dataframe
actlabel <- read.table ("UCI HAR Dataset/activity_labels.txt", header = FALSE)

#Reclassify Activity column in bigdf to factor
#Relabel the factor levels with appropriate activity labels as extracted into actlabel
bigdf$Activity <- factor (bigdf$Activity, levels = actlabel$V1, labels = actlabel$V2 )

#Load package dplyr to select the appropriate subset of columns from bigdf
#Inspect the new dataframe
newdf <- bigdf  %>% 
  select ("Activity", "Subject",contains("mean") | contains("std") | contains("Mean")) 

str (newdf)

#Create a new dataframe grouped by Subject and Activity and summarised by the mean of each variable
result <- newdf %>%
  group_by (Subject, Activity ) %>%
  summarise_each (funs = mean)

#Inspect the results! The new tidy dataframe :) 
view (result)
