## Input raw data into R
Train<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE,sep="")
Test<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE,sep="")
SubjectTrain<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="")
SubjectTest<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE,sep="")
FeaturesLabel<-read.table("./UCI HAR Dataset/features.txt")
ActivityLabel<-read.table("./UCI HAR Dataset/activity_labels.txt")
ActivityTest<-read.table("./UCI HAR Dataset/test/y_test.txt")
ActivityTrain<-read.table("./UCI HAR Dataset/train/y_train.txt")

## Merge data
DataTrain<-cbind(Train,SubjectTrain,ActivityTrain)
DataTest<-cbind(Test,SubjectTest,ActivityTest)
Data<-rbind(DataTrain,DataTest)
#Create header
Header<-as.character(FeaturesLabel[,2])
Header<-c(Header,"subject","activity")
names(Data)<-Header

## Define the label of the activity field
Data$activity<-factor(Data$activity,labels=ActivityLabel[,2])

## Extracts vairables that represent mean and standard deviation of each measurement
ExtractIndex<-grepl("mean()",Header)|grepl("std()",Header)
ExtractIndex[562]<-TRUE
ExtractIndex[563]<-TRUE
EData<-Data[,ExtractIndex]

## The following code clean the varialbe labels
#Remove ()
names(EData)<-gsub(pattern="\\(\\)",replacement="",names(EData))
#Replace - 
names(EData)<-gsub(pattern="-",replacement=".",names(EData))
#Expand Acc
names(EData)<-gsub(pattern="Acc",replacement="Acceleration",names(EData))

## Average the data and create the "tidy data set". 
MeltData<-melt(EData,id=c("subject","activity"))
SecondData<-dcast(MeltData,subject + activity~variable,mean)
write.table(SecondData,file="TidyData.txt")
