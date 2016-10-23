# 2016_Programming-Assignment
Refer also to the code book in this repo. The script starts by creating a subfolder to the users working d
irectory to store the following:

-The zip file of the required data

-The resulting output 'tidy data' in txt file format

The zip file is downloaded and txt files extracted to be operated on as follows:

Data 			Description 								Dimensions
		
SubjectTrainData 	These are the people in the TrainData set . 				1 row x 7352 measurements
SubjectTestData 	These are the people in the TestData set . 				1 row x 2947 measurements
TestData 		These are the results for the variable names for a test set. 		561 rows x 2947 measurements
TrainData 		These are the results for the variable names for a training set.  	561 rows x 7352 measurements
Features data 		These are the variable names. 						1 row x 561 variables

Both the subject test and subject train data are read into separate dataframes (df) and combined using 'rbind' giving a total number of 10299 rows by 1 column. The df is called completeSubjectData. Unfortunately, 10299 records are not divisible by 6 (activities), where the activities are walking, walkingDownstairs, sitting, standing and laying.

To match the number of activities across the subject dataset, the last three (3) rows are deleted thus 102096/6 == T. The df is now called:

#truncateCompleteSubjectData
In a similar manner, the test and train data itself are read into separate dfs, 'rbinded' and truncated. The resulting df is called:

#truncateCompleteData
At this stage, the neither of the above dfs have any column headings. To achieve this, the variable names from the features data are extracted using the 'factor' function and added as 'names' in a df called:

#namesCompleteData
Only the feature names that are measuring mean and standard deviation are required. This is achieved by subsetting the truncateCompleteData df, by selecting those with 'mean' or 'std' in the name string. The subject (person), activities and feature average values need to be added to dataSubset. The resulting df is now called:

#finalDataSubset
To achieve the tidy dataset required, finalDataSubset is again subsetted to obtain only Subject, Activity and FeatureAverage. Together with some output formatting the resulting df is written to a txt file where the df is called:

#formatTidyDataSet.

This completes the analysis.

Reference A Public Domain Dataset for Human Activity Recognition Using Smartphones. Anguita1,Ghio1,Oneto1, Parra2 Reyes-Ortiz1.2013 https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2013-84.pdf
