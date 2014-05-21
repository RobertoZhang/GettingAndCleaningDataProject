Human Acitivity Recognition Using Smartphoine Processed Dataset Code Book
=========================================================================
By Robert Zhang

This document explains the varialbe and data, and data processing transformation done to obtain the data set "tidydata.txt". 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

The orginal data from UCI was then processed to obtain the average value of all means of the measurements for each subject and activity.

### Variables
The data set contains 81 variables, with Two identification variables and 79 feature variables.

1. "subject". The identifier of the subject who carried out the experiment. it is positive integer from 1 to 30. Each reporesents one subject. 
2. "activity". The activity subject invovles when the record is collected. The activities are WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

The feature means selected for this database are the means of mean and standard deviation of the accelerometer and gyroscope 3-axial raw signals, and they are denoted tAcceleration.XYZ and tGyro.XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc.XYZ and tGravityAcc.XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk.XYZ and tBodyGyroJerk.XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). Then the means for the subject and activity are calculated. 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc.XYZ, fBodyAccJerk.XYZ, fBodyGyro.XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'.XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc.XYZ
* tGravityAcc.XYZ
* tBodyAccJerk.XYZ
* tBodyGyro.XYZ
* tBodyGyroJerk.XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc.XYZ
* fBodyAccJerk.XYZ
* fBodyGyro.XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: mean, mean value; std, Standard deviation;meanFreq, Weighted average of the frequency components to obtain a mean frequency.

### Data Processing
1. Import data in to R. 
```
Train<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE,sep="")
Test<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE,sep="")
SubjectTrain<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="")
SubjectTest<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE,sep="")
FeaturesLabel<-read.table("./UCI HAR Dataset/features.txt")
ActivityLabel<-read.table("./UCI HAR Dataset/activity_labels.txt")
ActivityTest<-read.table("./UCI HAR Dataset/test/y_test.txt")
ActivityTrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
```

2. Traning date are combined horizonally with their correspeonding subject identifier and activity name. The same is done for testing data. The two data are then combined together vertically to form a large data set name Data. 
```
DataTrain<-cbind(Train,SubjectTrain,ActivityTrain)
DataTest<-cbind(Test,SubjectTest,ActivityTest)
Data<-rbind(DataTrain,DataTest)
```

3. Import the header lables and create a header for the file.
```
Header<-as.character(FeaturesLabel[,2])
Header<-c(Header,"subject","activity")
names(Data)<-Header
```

4. Define the label of the activity field
```
Data$activity<-factor(Data$activity,labels=ActivityLabel[,2])
```

5. Extracts vairables that represent mean and standard deviation of each measurement
```
ExtractIndex<-grepl("mean()",Header)|grepl("std()",Header)
ExtractIndex[562]<-TRUE
ExtractIndex[563]<-TRUE
EData<-Data[,ExtractIndex]
```

6. Clean the variable labels (header). In the lable, remove "()",replace "-" with ".", and expand "Acc"" with "Acceleration".
```
names(EData)<-gsub(pattern="\\(\\)",replacement="",names(EData))
names(EData)<-gsub(pattern="-",replacement=".",names(EData))
names(EData)<-gsub(pattern="Acc",replacement="Acceleration",names(EData))
```

7. Average the mean of all measurements across the data dataset, and output the "tidydata.txt"
```
MeltData<-melt(EData,id=c("subject","activity"))
SecondData<-dcast(MeltData,subject + activity~variable,mean)
write.table(SecondData,file="TidyData.txt")
```

See the run_analysis.R for the original R script.


