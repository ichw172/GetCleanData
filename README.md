# GetCleanData
Assignment for Getting and Cleaning Data

Objective
To create two tidy datasets from the raw datasets.

Input: Datasets provided
The following datasets were provided:
.	X_train - features of the experiment that is used in the training of the model
.	X_test - features of the experiment that is used in the testing of the model
.	y_train - activity label of the experiment that is used in the training of the model
.	y_test - activity label of the experiment that is used in the testing of the model
.	subject_test - list of subjects who were involved in the experiment
.	features - list of feature names
.	activity_labels - list of activity names

Output: Dataset of mean/standard deviation and summary
.	output_ds.txt - Contains the mean and standard deviation of the features
(please see code book for detailed description)

.	output_ds_sum.txt - Contains the average of the variables in the first dataset

Procedure to tidy dataset
1.	Read the X train and test files into two datasets and the subject file into the dataset.
2.	Combine the subject dataset and the X train and test datasets.
3.	Combine the X train and test dataset.
4.	Repeat steps 1-3 for the Y datasets.
5.	Combine the X and Y datasets into a consolidated dataset.
6.	Read the feature file into a feature dataset.  Loop through the features and filter for the mean and standard deviation features (i.e. features containing the "mean()" and "std()").
7.	Select the columns containing the filtered feature set into a new dataset.
8.	Read the activity label file into a dataset and merge with the dataset to get the activity name.
9.	Label the dataset with the descriptive names from the feature name file.
10.	Transpose the dataset to get a "skinny dataset".
11.	Aggregate the dataset to get the average of the variables. 

