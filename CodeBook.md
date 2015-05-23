# Code Book for Getting and Cleaning Data Course Project

This project uses human activity data from smartphone sensor readings collected while volunteer subjects performed six different activities (walking, walking upstairs, walking downstairs, sitting, standing, laying).

The official citation for the study is Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

More information is available at [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The original data from the study is spread across multiple files and is not tidy.

I performed the following steps to assemble and tidy the data:

First I read all of the relevant data into R data frames as follows:

```R
# Read the test and training data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./data/UCI HAR Dataset//features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset//activity_labels.txt")
```

The original data is separated into training and test data sets. Each of these contains 3 files:

* `x_train.txt` (or `x_test.txt`) which contains the sensor data for 561 separate "features."

* `y_train.txt` (or `y_test.txt`) which contains a single column of activity codes (1-6).

* `subject_train.txt` (or `subject_test.txt`) which contains a single column of subject ID's (1-30) corresponding to the 30 volunteers.

The original data also included:

* `features.txt` which contains the descriptive names of the 551 "features" of the sensor data.

* `activity_labels.txt` which contains descriptive labels for the 6 activities (1 WALKING, 2 WALKING_UPSTAIRS, 3 WALKING_DOWNSTAIRS, 4 SITTING, 5 STANDING, 6 LAYING).

The next order of business was to combine the test and training data into a single data set.

```R
# Combine test and training data
all_x <- rbind(x_train, x_test)
all_y <- rbind(y_train, y_test)
all_subjects <- rbind(subject_train, subject_test)
```

Then I used the following R code to add descriptive variable and activity names, add subject codes, and combine all of the x and y data:

```R
# Use descriptive variable names for x data
colnames(all_x) <- features[,2]

# Use descriptive activity names for activities
all_y$Activity <- factor(all_y$V1, activity_labels[[1]], activity_labels[[2]])

# Remove extraneous column
all_y$V1 <- NULL

# Add subject codes to all_subjects
all_y$Subject <- all_subjects$V1

# Combine x and y data
all_data <- cbind(all_y, all_x)

# Extract only the measurements on the mean and standard deviation for each measurement.
tidy_activity_data <- all_data[, grepl("Subject|Activity|mean\\(\\)|std\\(\\)", names(all_data))]
```

The `tidy_activity_data` data frame contains one observation per row, and each column corresponds to a variable. The data set contains 10299 observations of 68 variables. The variables are as follows:

* Activity: Factor with 6 levels: WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING.

* Subject: integer ID's of the 30 volunteer subjects.

* 66 additional variables representing the "features" in the sensor data that contain the string "mean()" or "std()" in their names. The features are described in more detail in the `features_info.txt` file included with the original data set as follows:

>     Feature Selection
>     =================
>
>     The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.
>
>     Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).
>
>     Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).
>
>     These signals were used to estimate variables of the feature vector for each pattern:
>     '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
>
>     tBodyAcc-XYZ
>     tGravityAcc-XYZ
>     tBodyAccJerk-XYZ
>     tBodyGyro-XYZ
>     tBodyGyroJerk-XYZ
>     tBodyAccMag
>     tGravityAccMag
>     tBodyAccJerkMag
>     tBodyGyroMag
>     tBodyGyroJerkMag
>     fBodyAcc-XYZ
>     fBodyAccJerk-XYZ
>     fBodyGyro-XYZ
>     fBodyAccMag
>     fBodyAccJerkMag
>     fBodyGyroMag
>     fBodyGyroJerkMag
>
>     The set of variables that were estimated from these signals are:
>
>     mean(): Mean value
>     std(): Standard deviation
>     mad(): Median absolute deviation
>     max(): Largest value in array
>     min(): Smallest value in array
>     sma(): Signal magnitude area
>     energy(): Energy measure. Sum of the squares divided by the number of values.
>     iqr(): Interquartile range
>     entropy(): Signal entropy
>     arCoeff(): Autorregresion coefficients with Burg order equal to 4
>     correlation(): correlation coefficient between two signals
>     maxInds(): index of the frequency component with largest magnitude
>     meanFreq(): Weighted average of the frequency components to obtain a mean frequency
>     skewness(): skewness of the frequency domain signal
>     kurtosis(): kurtosis of the frequency domain signal
>     bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
>     angle(): Angle between to vectors.
>
>     Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:
>
>     gravityMean
>     tBodyAccMean
>     tBodyAccJerkMean
>     tBodyGyroMean
>     tBodyGyroJerkMean
>
>     The complete list of variables of each feature vector is available in 'features.txt'
>

Features are normalized and bounded within [-1,1], so the original units are no longer meaningful.

Finally, I created a second independent tidy data set and wrote it to a file named `tidy-means.txt` as follows:

```R
# Compute means by subject and activity
library(plyr)
tidy_means <- ddply(tidy_activity_data, .(Subject, Activity), colwise(mean))

# Write the new means data to a file
write.table(tidy_means, "tidy-means.txt", row.names = FALSE)
```

This data set contains 180 observations of 68 variables. The variable are as follows:

* Subject: integer ID's of the 30 volunteer subjects.

* Activity: Factor with 6 levels: WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING.

* 66 additional variables containing the average of each variable in `tidy_activity_data` for each activity and subject. Again, these variables represent "features" in the sensor data that contain the string "mean()" or "std()" in their names, as averages for each activity and subject.
