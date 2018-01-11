# gatting_and_cleaning_data_project

Course project for Getting and Cleaning Data course. R script run_analysis.R performs the following functions

It downloads dataset into the working directory
Loads information for activities & features
Loads training and test data and extracts only information relevant to mean and standard deviation
Loads activity and subject data
Merges the two datasets
Converts the activity and subject columns into factors
Creates tidy dataset consisting of mean values of each variable for subject and activity pairs
Writes the final result to tidy.txt