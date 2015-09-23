# get-clean-data-assignment

This project consists of a single R script, that tries to meet the requirements of the Coursera "Getting and Cleaning Data" assignment

## Prerequisites

Please download the above script, open in R or RStudio, and ensure that your working directory is the source directory.

Please download the dataset

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

and *unzip* the file into the working directory.  After this step, there should be a sub-directory in the working directory, with the name

UCI HAR Dataset

## Running the script

In order to run the script, you should
  source('run_analysis.R')
and then run the script, for example

tidySet <- run_analysis()

In addition to the assigned variable (tidySet), a file will also be created in your working directory

assignment-output.txt

## Script objectives

* Merge the training and the test sets to create one data set.
* Extract only the measurements on the mean and standard deviation for each measurement. 
* Use descriptive activity names to name the activities in the data set
* Appropriately label the data set with descriptive variable names. 
* From the data set in previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Script Details

The script has been broken into several functions (and sub functions), to improve readability

### activitiesAsFactor

The activity_labels.txt file contains textual desriptions of the activity identifier that are used in the test and train datasets
