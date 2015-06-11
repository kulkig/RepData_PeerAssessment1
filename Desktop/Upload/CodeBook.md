##Getting and Cleaning Data Course Project 
###Data sources

Data files source :                                                    
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "Data collected from accelerometers on Samsung Galaxy S smartphone")

Data description on the data files available on: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones ](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "Description on the data files")

###Description of the program
**Step 1: Merges the training and test sets to create one data set**

- Reads the training and test data from the files:
	1. ./data/train/x_train.txt
	2. ./data/train/y_train.txt
	3. ./data/train/subject_train.txt
	4. ./data/test/x_test.txt
	5. ./data/test/y_test.txt
	6. ./data/test/subject_train.txt

- Combines the training and test data from above into 3 data sets using rbind:

	1. ./data/train/x_train.txt with ./data/test/x_test.txt resulting in a data frame with the dimension of 10299x561. **Data frame name: trainingData
	2. ./data/train/subject_train.txt with ./data/train/subject_test.txt resulting in a data frame with the dimension of 10299x1.  **Data frame name: subjectData
	3. ./data/train/y_train.txt with ./data/train/y_test.txt resulting in a data from with the dimension of 10299x1.  **Data frame name: labelData
	

**Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.**

   1. Reads the features data from the files ./data/train/features.txt and store them in the data frame. 
	Data frame size : 561x2, **Data frame name : features 
   2. Extracts all the names with mean() or std() using grep on the features data frame resulting in an integer vector of length 66 named meanStdIndices. 
    *meanStdIndices will be use to filter out the column names in trainingData dataset.*
   3. Filter and select only the data from the columns in meanStdFilter resulting in the data frame of size 10299x66. **Data frame name  : meanstdData 
   4. Format the column names in meanstdData by removing the underscore characters, capitalize on the first alphabet in the word. 


**Step 3: Uses descriptive activity names to name the activities in the data set.**

   1. Reads the features data from the files ./data/train/activity_labels.txt and store them in the data frame. 
	Data frame size : 6x2, **Data frame name : activities 
   2. Extracts all rows in the second column.  
   3. Format the column names in activities by removing the underscore characters, capitalize on the first alphabet in the word. 	
   4. Create a temporary character vector to hold the labelData dataset rows data with the activities labels. Vector name : tempActivityLabel  with the length of 10299
   5. Replace the labelData only column with the data in tempActivityLabel. *At this point, the rows in the column of the labelData has been replaced with the descriptive activity names.
   6. Name the column in labelData with the the correct name i.e. activity
 
**Step 4: Appropriately labels the data set with descriptive variable names.**

   1. Name the column  appropriate i.e subjectData as subject
   2. Bind the 3 data set using cbind resulting resulting in a data frame with the dimension of 10299x68.  **Data frame name: cleanedData 
   3. Write out the resulting data frame to a text file omitting the row numbers in the file. **Filename: merged_data.txt

**Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**

   1. Class the cleanedData columns of activity and subject as a factor. 
   2. Suppress warnings and do a mean of the cleanedData on columns activity and subject resulting resulting in a data frame with the dimension of 180x70.  **Data frame name: tidyData. 
   3. Drop the additional columns that has NAs in tidyData. These are under the third and fourth column. 
   3. Write out the resulting data frame to a text file omitting the row numbers in the file.** Filename : tidy_data.txt