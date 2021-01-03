#### Getting and cleaning data - Final Project
#### Author - Angus Mackenzie

#### Set Up ####
## Clear workspace
rm(list=ls())


#### Packages
library(tidyverse)
library(data.table)
library(lubridate)
library(xlsx)
library(XML)

## Directory
myWd <- getwd()
    myDat <- paste0(myWd, "/UCI HAR Dataset/")

#### Download data
ifn <- paste0(myWd, "/", "activity.zip")

download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = ifn)     

unzip(ifn)

#### Create Data Frames

feature <- read.table(paste0(myDat, "features.txt"), col.names = c("row","functions"))
activity <- read.table(paste0(myDat, "activity_labels.txt"), col.names = c("number", "activity"))
test <- read.table(paste0(myDat, "test/subject_test.txt"), col.names = "subject")
train <- read.table(paste0(myDat, "train/subject_train.txt"), col.names = "subject")


test_x <- read.table(paste0(myDat, "test/X_test.txt"))
    names(test_x) <- feature$functions
test_y <- read.table(paste0(myDat, "test/y_test.txt"))

train_x <- read.table(paste0(myDat, "train/X_train.txt"))
    names(train_x) <- feature$functions
train_y <- read.table(paste0(myDat, "train/y_train.txt"))


#### Requirement 1 - Merge Data ####

x <- rbind(test_x, train_x)
y <- rbind(test_y, train_y)

subject <- rbind(test, train)
dfmerge <- cbind(subject, x, y)


#### Requirement 2 - Extracts mean and standard deviation ####

vcol <- grep("mean|std", names(dfmerge), ignore.case = TRUE, value = TRUE)

dfsub <- dfmerge %>%
  select(subject, V1, all_of(vcol))


#### Requirement 3 - Name activities ####

dfsub <- dfsub %>%
  rename(number = V1) %>%
  left_join(activity) %>%
  select(subject, activity, everything())


#### Requirement 4 - Descriptive Variable Names ####

dflabels <- tibble(old = names(dfsub))

dflabels <- dflabels %>%
  mutate(prefix = case_when(grepl("^t", old) ~ "time",
                            grepl("^f", old) ~ "freq",
                            grepl("^angle", old) ~ "angle",
                            TRUE ~ ""),
         description = gsub("^t|^f|angle|\\(|\\)", "", old),
         description = gsub(",", "-", description),
         description = gsub("tBody|BodyBody", "Body", description),
         description = gsub("mean", "Mean", description),
         description = gsub("std", "StDev", description),
         description = gsub("Mag", "Magnitude", description),
         description = gsub("Acc", "Accelerometer", description),
         description = gsub("Gyro", "Gyroscope", description),
         label = paste(prefix, description, sep = "-"),
         label = ifelse(grepl("^-", label), old, label))

names(dfsub) <- dflabels$label


#### Requirement 5 - Mean data frame ####

dfmean <- dfsub %>%
  select(-number) %>%
  group_by(subject, activity) %>%
  summarise_all(mean, na.rm = TRUE)


write.csv(dfmean, paste0(myWd, "/Subject_Averages.csv"), row.names = FALSE)


 