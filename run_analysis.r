run_analysis<-function(thisFile) {
+        
+        # The following statements create a subfolder to your working directory with the intention of storing:
+        # - The zip file of the required data
+        #-  The resulting output 'tidy data' in txt file format
+        
+        if(!file.exists('ProgrammingAssignment')){
+                dir.create('ProgrammingAssignment')
+        }
+        
+        print('Downloading data')
+        thisZip <- download.file(thisFile, './ProgrammingAssignment/UCI_HAR_Dataset.zip', method = 'curl')
+        
+        print('Data has downloaded. Now extracting the training and test data.')
+        
+        #The following code section unzips the required data into txt file format, ready for reading into 
+        #data frames. The name, purpose and dimensions of the required data are:
+        # Features data    - These are the variable names.                                          Dimension 561 variables x 1 row
+        # TestData         - These are the results for the variable names above for a test set.     Dimensions 561 rows x 2947 subjects
+        # TrainData        - These are the results for the variable names above for a training set. Dimensions 561 rows x 7352 subjects
+        # SubjectTrainData - These are the people in the TrainData set above.                       Dimensions 1   row  x 7352 subjects
+        # SubjectTestData  - These are the people in the TesData set above.                         Dimensions 1   row  x 2947 subjects
+        
+        unzipFeaturesData <-unzip('./ProgrammingAssignment/UCI_HAR_Dataset.zip', list=T)$Name[2]
+        unzipTestData <-unzip('./ProgrammingAssignment/UCI_HAR_Dataset.zip', list=T)$Name[17]
+        unzipTrainData <-unzip('./ProgrammingAssignment/UCI_HAR_Dataset.zip', list=T)$Name[31]
+        unzipSubjectTrainData <-unzip('./ProgrammingAssignment/UCI_HAR_Dataset.zip', list=T)$Name[16]
+        unzipSubjectTestData <-unzip('./ProgrammingAssignment/UCI_HAR_Dataset.zip', list=T)$Name[30]
+        
+        print('Data has been extracted. Now read into suitable dataframes and process.')
+        
+        # The following code reads the train and test data for the subjects into separate data frame and then rbinds to form a 
+        # complete dataset.The last 3 out of 10299 records are removed to make the set divisible by 6 (activities)
+        subjectTrainData <-read.table(unzipSubjectTrainData, header=F)
+        subjectTestData <- read.table(unzipSubjectTestData, header=F)
+        completeSubjectData <- rbind(subjectTrainData, subjectTestData) 
+        truncateCompleteSubjectData <- completeSubjectData[-c(10297,10298,10299), ]
+        
+        #As above for the train and test data for the activities
+        testData<- read.table(unzipTestData, header=F)
+        trainData<- read.table(unzipTrainData, header=F, row.names=NULL,stringsAsFactors=FALSE)
+        completeData <- rbind(testData, trainData)
+        truncateCompleteData <- completeData[-c(10297,10298,10299), ]
+        
+        #This code section extracts the variable names from the features data to be used as column headings
+        # for subsequent processing.
+        featuresData <-read.table(unzipFeaturesData, header=F)
+        featureFactor<- factor(featuresData$V2)
+        names(truncateCompleteData) <- as.character(featureFactor)
+        namesCompleteData <-names(truncateCompleteData)
+        
+        # Here the overall dataset 'truncateCompleteData' is subsetted to include only those feature (variable) names 
+        # that are mean or standard deviation measurements as required by the assignment.
+        dataSubset<- subset(truncateCompleteData,  select=c('tBodyAcc-mean()-X','tBodyAcc-mean()-Y','tBodyAcc-mean()-Z','tBodyAcc-std()-X','tBodyAcc-std()-Y','tBodyAcc-std()-Z','tGravityAcc-mean()-X','tGravityAcc-mean()-Y','tGravityAcc-mean()-Z','tGravityAcc-std()-X','tGravityAcc-std()-Y','tGravityAcc-std()-Z','tBodyAccJerk-mean()-X','tBodyAccJerk-mean()-Y','tBodyAccJerk-mean()-Z','tBodyAccJerk-std()-X','tBodyAccJerk-std()-Y','tBodyAccJerk-std()-Z','tBodyGyro-mean()-X','tBodyGyro-mean()-Y','tBodyGyro-mean()-Z','tBodyGyro-std()-X','tBodyGyro-std()-Y','tBodyGyro-std()-Z','tBodyGyroJerk-mean()-X','tBodyGyroJerk-mean()-Y','tBodyGyroJerk-mean()-Z','tBodyGyroJerk-std()-X','tBodyGyroJerk-std()-Y','tBodyGyroJerk-std()-Z','tBodyAccMag-mean()','tBodyAccMag-std()','tBodyAccJerkMag-mean()','tBodyAccJerkMag-std()','tBodyGyroMag-mean()','tBodyGyroMag-std()','tBodyGyroJerkMag-mean()','tBodyGyroJerkMag-std()','fBodyAcc-mean()-X','fBodyAcc-mean()-Y','fBodyAcc-mean()-Z','fBodyAcc-std()-X','fBodyAcc-std()-Y','fBodyAcc-std()-Z','fBodyAccJerk-mean()-X','fBodyAccJerk-mean()-Y','fBodyAccJerk-mean()-Z','fBodyAccJerk-std()-X','fBodyAccJerk-std()-Y','fBodyAccJerk-std()-Z','fBodyGyro-mean()-X','fBodyGyro-mean()-Y','fBodyGyro-mean()-Z','fBodyGyro-std()-X','fBodyGyro-std()-Y','fBodyGyro-std()-Z','fBodyAccMag-mean()','fBodyAccMag-std()','fBodyBodyGyroMag-mean()','fBodyBodyGyroMag-std()','fBodyBodyGyroJerkMag-mean()','fBodyBodyGyroJerkMag-std()'))
+        
+        # Here the features dataset is combined with the subject data using cbind.
+        finalDataSubset <- cbind(dataSubset,truncateCompleteSubjectData)
+        colnames(finalDataSubset)[colnames(finalDataSubset)=='truncateCompleteSubjectData'] <-'Subject'
+        
+        #Now add 'activity' and 'feature average' columns to make the complete 'untidy' dataset.
+        activity<-c('Walking', 'WalkingUpstairs','WalkingDownstairs', 'Sitting', 'Standing', 'Laying')
+        repeatActivity<-rep(activity,1716)
+        finalDataSubset['Activity']<- repeatActivity
+        finalDataSubset['FeatureAverage'] <- rowMeans(finalDataSubset[,1:62])
+        
+        #Subset the finalDataSubset to achieve tidy principles.
+        tidyDataSet <- subset(finalDataSubset, select=c('Subject', 'Activity','FeatureAverage'))
+        
+        # Format and write to a txt file for uploading to Coursera.
+        formatTidyDataSet <- format(tidyDataSet, digits=4, scientific=F, justify='right')
+        
+        print('Processing finished.')
+        
+        write.table(formatTidyDataSet, file='./ProgrammingAssignment/tidyDataSet.txt',row.names=F, sep='\t', quote=F)
+        
+        a<-format(object.size(tidyDataSet), units='Mb')
+        b<-'Tidy dataset object size is '
+        c<-cat(b,a)
+        
+        return(tidyDataSet)      
+}
