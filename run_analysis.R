setwd("~/study/getting_and_cleaning_data/project")

# Download the data if we don't already have it
if (!file.exists("./data")) {
    dir.create("./data")
    if (!file.exists("./data/UCI HAR Dataset.zip")) {
        dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(dataUrl, destfile="./data/UCI HAR Dataset.zip", method="libcurl")
        library(utils)
        unzip("./data/UCI HAR Dataset.zip", exdir="./data")
    }
}

# Read the test and training data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./data/UCI HAR Dataset//features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset//activity_labels.txt")

# Combine test and training data
all_x <- rbind(x_train, x_test)
all_y <- rbind(y_train, y_test)
all_subjects <- rbind(subject_train, subject_test)

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

# Compute means by subject and activity
library(plyr)
tidy_means <- ddply(tidy_activity_data, .(Subject, Activity), colwise(mean))

# Write the new means data to a file
write.table(tidy_means, "tidy-means.txt", row.names = FALSE)
