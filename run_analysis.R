##########################################################################
# 
#  Project : Getting and cleaning data
#
##########################################################################

#-------------------------------------------------------------------------
# Set the working directory
#-------------------------------------------------------------------------
setwd("C:\\Users\\ideapad 500\\Documents\\Ass\\UCI HAR Dataset")

#-------------------------------------------------------------------------
# Load the library
#-------------------------------------------------------------------------
library(dplyr)
library(reshape)
library(reshape2)

#*******************************************************************************************
# Step 1 - Merges the training and the test sets to create one data set                    #
#*******************************************************************************************

#----------------------------------------------------------------------------
# Read the subject file (train and test) and load the list of experiment subjects 
# 
#----------------------------------------------------------------------------
## Read the test subject file and load the data to a dataframe
subtestfile <- "./test/subject_test.txt"
df_subtest <- read.table(subtestfile, header = FALSE, sep = "",col.names = "subject_id")

## Read the train subject file and load it to a dataframe 
subtrainfile <- "./train/subject_train.txt"
df_subtrain <- read.table(subtrainfile, header = FALSE, sep = "",col.names = "subject_id")

#----------------------------------------------------------------------------
# - Read the X train and test and load into two datasets
# - Combine the subject and train,test dataset each
# - Combine the train and test dataset
# 
#----------------------------------------------------------------------------

## Read the X train file and load it to a dataframe and name the columns after the features
xtrainfile <- "./train/X_train.txt"
df_xtrain <- read.table(xtrainfile, sep="")

## Combine the subject and X train datasets
df_xtrain_com <- cbind(df_xtrain,df_subtrain)

## Read the X test file and load it to a dataframe 
xtestfile = "./test/X_test.txt"
df_xtest = read.table(xtestfile, sep="")

## Combine the subject and X test datasets
df_xtest_com <- cbind(df_xtest,df_subtest)

##Finally combine the X train and test dataset
df_x_com <- rbind(df_xtrain_com, df_xtest_com)


#----------------------------------------------------------------------------
# - Read the Y train and test and load into two datasets
# - Combine the activity id and train,test dataset each
# - Combine the train and test dataset into consolidated Y dataset
# 
#----------------------------------------------------------------------------


## Read the Y train and load the data to a dataframe
ytrainfile <- "./train/y_train.txt"
df_ytrain <- read.table(ytrainfile, header = FALSE, sep = "", col.names="activity_id")

## Read the Y test and load the data to a dataframe
ytestfile <- "./test/y_test.txt"
df_ytest <- read.table(ytestfile, header = FALSE, sep = "", col.names="activity_id")

## Combine the the Y train and test 
df_y_com <- rbind(df_ytrain,df_ytest)
## Set a id running number to keep it in sequence
df_y_com$experiment_id <- seq.int(nrow(df_y_com))


#----------------------------------------------------------------------------
# Combine the X and Y datasets to get a consolidated dataset
#
#----------------------------------------------------------------------------
df_xy_com <- cbind(df_x_com,df_y_com)


#**********************************************************************************************
# Step 2 - Extracts only the measurements on the mean and standard deviation for each         #
# measurement                                                                                 #
#**********************************************************************************************

## Read the features file 
featuresfile = "features.txt"
conn=file(featuresfile,open="r")
filecont=readLines(conn)

v_fposition <- c() #create an empty feature position vector
v_fname <- c()     #create an empty feature name vector

# Loop and extract the feature ignoring the first part which is a running number
# Check if the feature has a "mean()" or "std()", if so add the position to position vector
# and also add the feature name to a feature name vector
cnt = 1
for (lfeature in filecont) 
{ 
  extract = strsplit(lfeature, " ")[[1]]
 
  # if there is a mean() or std() in the feature, store its position and name in the vectors 
  if ( grepl(x=extract[2], pattern=".+mean()[^F].+") | 
       grepl(x=extract[2], pattern="std()") )
  {   
      v_fposition <- c(v_fposition, cnt)
      v_fname <- c(v_fname, extract[2])
  }
  cnt = cnt + 1
}
close(conn)

## Additional step - make proper names of the columns by removing special characters
v_fname <- gsub(x=v_fname,pattern="\\(", replacement="")
v_fname <- gsub(x=v_fname,pattern="\\)", replacement="")
v_fname <- gsub(x=v_fname,pattern="-", replacement="_")


## select only the mean and standard deviation columns using the position vector 
df_xy_meanstd <- df_xy_com %>% select(v_fposition,experiment_id,subject_id,activity_id)


#**********************************************************************************************
# Step 3 - Uses descriptive activity names to name the activities in the data set             #
#**********************************************************************************************


## Create a dataset containing the activity names
df_activity_name <- data.frame("activity_id" = 1:6, 
  "activity_name" = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING") )

## Merge the activity activity code and combined dataframe to get the activity name as a new
## column
df_xy_meanstd <- merge(df_xy_meanstd,df_activity_name,by.x="activity_id",by.y="activity_id",sort=FALSE)

## Drop the activity_id column since there is already an activity_name column
df_xy_meanstd <- df_xy_meanstd %>% select(-activity_id)


#************************************************************************************************
# Step 4 - Appropriately labels the data set with descriptive variable names                    #
#************************************************************************************************

## Rename the dataset columns using the feature name vector
names(df_xy_meanstd) = c(v_fname,'experiment_id','subject_id','activity_name')


#************************************************************************************************
# Step 5 - From the data set in step 4, creates a second, independent tidy data set with the    #
#            average of each variable for each activity and each subject.                       #
#************************************************************************************************

## Transpose the dataset
df_xy_meanstd_m <- melt(df_xy_meanstd, id=c("experiment_id","subject_id","activity_name"),
                        measure.vars = c(v_fname))

## Average the value for each activity_name and subject_id
#df_xy_meanstd_T_sum <- df_xy_meanstd_T %>% group_by(activity_name,subject_id,variable) %>% 
#  summarise(average=mean(value))

## Transpost back the data
df_xy_meanstd_sum <- dcast(df_xy_meanstd_m, subject_id+activity_name ~ variable, mean)


#**********************************************************************************************
# Write the two datasets to file                                                              #
#**********************************************************************************************

out_fileDS = 'output_ds.txt'          #Name of the file to write to for first dataset
out_fileDS_sum = 'output_ds_sum.txt'  #Name of the file to write to for second i.e. summary dataset

write.table(x=df_xy_meanstd,file=out_fileDS)
write.table(x=df_xy_meanstd_sum ,file=out_fileDS_sum)


#**********************************************************************************************
# Please copy the following codes to read and display the two datasets                        #
#**********************************************************************************************

out_fileDS = 'output_ds.txt'          
out_fileDS_sum = 'output_ds_sum.txt'  

dataset1 <- read.table(file=out_fileDS,header=TRUE)
View(dataset1)

dataset2 <- read.table(file=out_fileDS_sum,header=TRUE)
View(dataset2)





