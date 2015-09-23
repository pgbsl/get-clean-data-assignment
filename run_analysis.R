############################################################
# Given a dataset dowloaded from 
#     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# Merges the test and train datasets, incorporating the activity and subject meta data supplied,
# producing a tidy data set containing the averages of each individual observation type, grouped
# by activity and subject
############################################################
run_analysis <- function() {
  library(dplyr)
  
  # The following sections define (inner) functions that are used within the main function.
  # The main body of the function is towards the end (jump to the bottom of the file)
  
  # Reads the activities file & convert each line to a factor
  activitiesAsFactor <- function() {
    activities <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep="", header =  FALSE)
    activityFactor = factor(activities[, 2])
    
  }
  
  # Read the train dataset, appending the activity (factor variable) and subject for each observation
  # as the final two columns of each row
  trainDataSetWithActivityAndSubject <- function(activityFactor) {
    dataSetWithActivityAndSubject("./UCI HAR Dataset/train/X_train.txt",
                                  "./UCI HAR Dataset/train/subject_train.txt",
                                  "./UCI HAR Dataset/train/y_train.txt")
  }
  
  # Read the Test dataset, appending the activity (factor variable) and subject for each observation
  # as the final two columns of each row
  testDataSetWithActivityAndSubject <- function(activityFactor) {
    dataSetWithActivityAndSubject("./UCI HAR Dataset/test/X_test.txt",
                                  "./UCI HAR Dataset/test/subject_test.txt",
                                  "./UCI HAR Dataset/test/y_test.txt")

  }    
  
  # Both test and train data sets are loaded in the same way, so abstracting the the loading
  # mechanism
  dataSetWithActivityAndSubject <- function(observationFile, subjectFile, activityFile) {
    
    dataSet <- read.csv(observationFile, sep="", header =  FALSE)
    subject <- read.csv(subjectFile, sep="", header =  FALSE)
    activity <- read.csv(activityFile, sep="", header =  FALSE)
    
    # Each activity in the activity CSV file is stored as a number, using the activities factor (obtained earlier
    # and in scope), convert this into a more meaningful description of the activity (e.g.  '1' is converted to 'WALKING')
    activityAsFactor <- lapply(activity, function(x) activityFactor[x])
    
    # Add activity factor and subject identifier as final 2 elements of row (and return)
    cbind(dataSet, activityAsFactor, subject)
  }
  
  # Parse the features CSV and extract column indexes for only the mean and std deviation 
  meanAndStdDevFeatures <- function() {
    features <- read.csv("./UCI HAR Dataset/features.txt", sep="", header =  FALSE)
    
    # The above features CSV contains descriptors for all the observations,
    # We are only interested in mean and std deviation results.  Use te grepl
    # function to limit the features selected to those containing
    #  -mean(
    #  -std(
    # Note that by including '-' and '(' in the filter, we ensure that we don't pick up any false columns,
    # such as *-meanFreq()
    meanFeatures <- filter(features, grepl("-mean\\(", V2))
    stdDevFeatures <- filter(features, grepl("-std\\(", V2))
    
    # Return the list of combined mean and std dev features
    rbind(meanFeatures, stdDevFeatures)
    
  }
  
  
  # Both test and train data sets contain the same number of columns, with the same meanings,
  # so merging is simply a case of appending one data set to the other.  
  # Once merged, extract only the mean, std dev, activity and subject columns.
  # Finally Add meaningful names to each column.  
  mergeTrainAndTestSets <- function(train, test, meanAndStdDevFeatures) {
    
    # Add index of Activity and subject on to index of all mean and std dev obeservations
    # Both train and test have same number of columns, so using train here, but could equally 
    # have been test data set
    dataSetIndexesOfInterest <- c(meanAndStdDevFeatures$V1, ncol(train) -1, ncol(train))
    # Now bind all the observations into a single dataset
    merged <- rbind(test, train)  

        # And subset to only use the mean and std dev observations
    merged <- merged[, dataSetIndexesOfInterest]
    
    # Use the column names as provided in the features meta data file.  The descriptors here are meaningful
    # to the users of the sample data, so no point in changing these desriptions to something more meaninful.
    # This would be adding unecessary context - the column names (e.g. "tBodyAcc-mean()-X") are sufficient and concise
    names(merged) <- c(as.character(meanAndStdDevFeatures$V2), 'Activity', 'Subject')
    
    # Return the merged data set
    merged    
  }
  
  # Create a 'tidy' data set containing the average of each column, grouped by ativity and subject
  # Write this dataset to a file named "./assignment-output.txt"
  averageAllColumnsByActivityAndSubject <- function(mergedDataSet) {
    # If running withing r console (outside script) an error is generated due to column widths,
    # running the following will allow you to see the tidyDataSet.....
    #  options(dplyr.width = Inf)
    
    
    # Group the data set and then apply the mean function
    tidyDataSet <- mergedDataSet %>% group_by(Activity, Subject) %>% summarise_each(funs(mean))
    
    # Write the data to a file (for assignment upload)
    write.table(x = tidyDataSet, file = "./assignment-output.txt", row.name = FALSE)
    
    tidyDataSet
  }

  # This is the start of the executable section of run_analysis.  The functions declared above have been added to aid
  # readability and reduce duplication
  
  activityFactor <- activitiesAsFactor()
  train <- trainDataSetWithActivityAndSubject(activityFactor)
  test <- testDataSetWithActivityAndSubject(activityFactor)
  meanAndStdDevFeatures <- meanAndStdDevFeatures()
  mergedDataSet <- mergeTrainAndTestSets(train, test, meanAndStdDevFeatures)
  averageAllColumnsByActivityAndSubject(mergedDataSet)
}


