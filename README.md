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

The activity_labels.txt file contains textual desriptions of the activity identifier that are used in the test and train datasets.  This file is parsed and the activity labels are converted to factors (where the index number for each factor corresponds to the activity number used in the dataset).  It is these labels that we will use in the tidy data set

### trainDataSetWithActivityAndSubject & testDataSetWithActivityAndSubject

Both the train and test dataset are contained within subdirectories.  Each dataset consists of a main fail, that contains all the observations.  There are additional files for activities and subjects.  Both these files contain the same number of lines as the main dataset file and the corresponding lines indicate the activity that the observations relate to and the subject of the experiment.  These functions (using the sub-function dataSetWithActivityAndSubject) combines the 3 files for each datset 

### meanAndStdDevFeatures

The features.txt file contains information on each column within the test and train main datasets.  By parsing this file, looking only for those measurements that are means and standard deviation, we build up a list of feature name/column index pairs (that we will use later to limit the columns (and provide labels) that we use in the merged dataset).

(Please note that I interpreted the requirements to include only 'mean' measurements, not similar measurements such as 'meanFreq')

### mergeTrainAndTestSets

The test and train datasets are merged together using the rbind() function (i.e. the train set is simply added on to the end of the test dataset).  This was possible with no further manipulation as both datasets have the same number of columns, each with the same meaning. 

Once merged, the columns of interest are extracted (The columns of interest are the meanAndStdDevFeatures, as described above, as well as the final two columns, containing activity and subject)

The final step (this function is doing slightly too much, but I din''t want to make the functions too fine grained) is to use the names extracted from the features file, to label the columns.

Please note that the requirement was to "Appropriately label the data set with descriptive variable names.".  I feel that the names in the features file are descriptive and meaningful in the domain of this trial, so plain English titles were not needed.  I could not add more context to the column names than provided in the features file.

### averageAllColumnsByActivityAndSubject

The final step was to take the dataset produce in the previous step and 'tidy' it up.  The final dataset should contain an average for each feature variable (grouped by activity and subject).

To do this the 'group_by' function was used against the dataset.  The results of this group by where then processed by the summarise_each function (using 'mean' to carry out the summary).

A file was then output with this tidy set (assignment-output.txt).  This was the assignment submission file.

The function itself also returned this tidy dataset.
