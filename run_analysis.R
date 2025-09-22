# run_analysis.R
# Getting and Cleaning Data Project (UCI HAR)

message("==> Starting run_analysis.R")

# 1) Packages
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr", repos = "https://cloud.r-project.org")
library(dplyr)

# 2) Download & unzip
zip_url  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_path <- "UCI_HAR_Dataset.zip"
data_dir <- "UCI HAR Dataset"

if (!dir.exists(data_dir)) {
  if (!file.exists(zip_path)) download.file(zip_url, destfile = zip_path, mode = "wb", quiet = TRUE)
  unzip(zip_path)
}

# 3) Features & activity labels
features   <- read.table(file.path(data_dir, "features.txt"),
                         col.names = c("index", "feature"), stringsAsFactors = FALSE)
activities <- read.table(file.path(data_dir, "activity_labels.txt"),
                         col.names = c("activity_id", "activity_name"), stringsAsFactors = FALSE)

# Keep only -mean() and -std() features (excludes meanFreq, angle, etc.)
keep_idx <- grep("-(mean|std)\\(\\)", features$feature)

# 4) Load train/test sets and keep only needed columns
X_train <- read.table(file.path(data_dir, "train", "X_train.txt"))
X_test  <- read.table(file.path(data_dir, "test",  "X_test.txt"))
colnames(X_train) <- features$feature
colnames(X_test)  <- features$feature
X_train <- X_train[, keep_idx]
X_test  <- X_test[,  keep_idx]

y_train <- read.table(file.path(data_dir, "train", "y_train.txt"), col.names = "activity_id")
y_test  <- read.table(file.path(data_dir, "test",  "y_test.txt"),  col.names = "activity_id")
subj_train <- read.table(file.path(data_dir, "train", "subject_train.txt"), col.names = "subject")
subj_test  <- read.table(file.path(data_dir, "test",  "subject_test.txt"),  col.names = "subject")

train <- cbind(subject = subj_train$subject, activity_id = y_train$activity_id, X_train)
test  <- cbind(subject = subj_test$subject,  activity_id = y_test$activity_id,  X_test)
dataset <- rbind(train, test)

# 5) Add descriptive activity names
dataset <- merge(dataset, activities, by = "activity_id", all.x = TRUE)

# 6) Clean variable names
clean_names <- function(nms) {
  nms <- gsub("\\(\\)", "", nms)
  nms <- gsub("-", "_", nms)
  nms <- gsub("^t", "Time_", nms)
  nms <- gsub("^f", "Freq_", nms)
  nms <- gsub("Acc", "Acceleration", nms)
  nms <- gsub("Gyro", "Gyroscope", nms)
  nms <- gsub("Mag", "Magnitude", nms)
  nms <- gsub("BodyBody", "Body", nms)
  nms <- gsub("mean", "Mean", nms)
  nms <- gsub("std", "Std", nms)
  nms
}
measure_cols <- setdiff(names(dataset), c("subject", "activity_id", "activity_name"))
names(dataset)[match(measure_cols, names(dataset))] <- clean_names(measure_cols)

# Drop activity_id and order columns as: subject, activity_name, measures
dataset$activity_id <- NULL
dataset <- dataset[, c("subject", "activity_name", setdiff(names(dataset), c("subject","activity_name")))]

# 7) Tidy dataset: averages per subject & activity
tidy <- dataset %>%
  group_by(subject, activity_name) %>%
  summarise(across(where(is.numeric), mean), .groups = "drop")

# 8) Output (per submission requirement)
write.table(tidy, "tidy_UCI_HAR_Averages.txt", row.names = FALSE)

message("==> Finished.")
