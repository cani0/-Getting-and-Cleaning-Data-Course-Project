# CodeBook

This document describes the dataset, variables, and transformations used to produce tidy_UCI_HAR_Averages.txt.

## 1) Source Data
- Dataset: Human Activity Recognition Using Smartphones (UCI HAR Dataset v1.0)
- Original description: UCI Machine Learning Repository
- Collected from: Samsung Galaxy S accelerometer and gyroscope
- Files used
  - features.txt — list of all feature names (indices + names)
  - activity_labels.txt — map from activity ID to activity name
  - train/ and test/ folders with:
    - X_train.txt, X_test.txt — feature values
    - y_train.txt, y_test.txt — activity IDs
    - subject_train.txt, subject_test.txt — subject IDs

## 2) Study Design & Target
Create a tidy dataset containing the average of each selected measurement for each subject and each activity. Selection is strictly limited to features with -mean() or -std() (thus excluding meanFreq() and angle-derived features).

## 3) Transformations (in Order)
1. Download & unzip the dataset if missing.
2. Load metadata:
   - features.txt → feature names,
   - activity_labels.txt → readable activity names.
3. Identify features to keep:
   - Regular expression: -(mean|std)\(\) → selects only -mean() and -std() features.
4. Load train/test sets, assign feature names, and column-select only the identified features.
5. Merge:
   - Column-bind subject, activity_id, selected features per split (train/test),
   - Row-bind train and test into a single dataset.
6. Add descriptive activity names by merging with activity_labels.txt.
7. Clean variable names (R-friendly and informative):
   - Remove () and replace - with _,
   - Prefix t → Time_, f → Freq_,
   - Replace abbreviations: Acc → Acceleration, Gyro → Gyroscope, Mag → Magnitude,
   - Fix duplication: BodyBody → Body,
   - Capitalize: mean → Mean, std → Std.
8. Drop activity_id to avoid redundancy (keep only activity_name).
9. Create the tidy dataset:
   - Group by subject and activity_name,
   - Compute the mean of each numeric measurement,
   - Ungroup to produce a flat tidy table.
10. Write output (submission requirement):
    - write.table(tidy, "tidy_UCI_HAR_Averages.txt", row.names = FALSE).

## 4) Variables in the Final Tidy Dataset
- Identifiers
  - subject — integer ID of the participant (1–30)
  - activity_name — one of: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
- Measurements (66 columns)  
  Each is the average (over all original observations for that subject+activity) of a selected sensor signal originally marked with -mean() or -std().

### Naming Convention (after cleaning)
<Domain>_<Signal>[Jerk][Magnitude]_<Axis?>_<Statistic>

- <Domain>: Time or Freq
- <Signal>: BodyAcceleration, BodyGyroscope, GravityAcceleration
- Optional: Jerk, Magnitude
- <Axis?>: X, Y, Z (omitted for magnitude signals)
- <Statistic>: Mean or Std

Examples:
- Time_BodyAcceleration_X_Mean
- Time_BodyAcceleration_Y_Std
- Freq_BodyGyroscope_Magnitude_Mean
- Time_GravityAcceleration_Z_Std

## 5) Dataset Dimensions & Units
- Rows: 180 (30 subjects × 6 activities)
- Columns: 68 (subject, activity_name, 66 averaged features)
- Units: Original signals are normalized; averaged values are unitless.

## 6) Reproducibility
- Script: run_analysis.R (dplyr-only, base R I/O)
- R ≥ 3.6.0
- Output generated with:
  write.table(tidy, "tidy_UCI_HAR_Averages.txt", row.names = FALSE)
