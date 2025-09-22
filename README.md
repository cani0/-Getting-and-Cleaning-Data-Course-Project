# Getting and Cleaning Data — UCI HAR (Coursera Project)

This repo contains the solution for the "Getting and Cleaning Data" project.

## Repository Contents
- run_analysis.R — R script that downloads, cleans, and summarizes the UCI HAR dataset.
- CodeBook.md — Describes data sources, variables, and all transformations.
- tidy_UCI_HAR_Averages.txt — Final tidy dataset required for submission (created by the script via write.table(..., row.names = FALSE)).

## How to Run
1. Open R (≥ 3.6.0) in this folder.
2. Run:
   source("run_analysis.R")
3. The script will:
   - download and unzip the UCI HAR dataset (if not present),
   - merge training and test data,
   - keep only features with -mean() or -std(),
   - add descriptive activity names,
   - clean variable names,
   - compute the average of each variable for each subject and activity,
   - write the tidy dataset to tidy_UCI_HAR_Averages.txt using write.table(..., row.names = FALSE) (as required).

## How the Script Works & How Files Connect
- run_analysis.R reads the raw UCI HAR files (features.txt, activity_labels.txt, X_*.txt, y_*.txt, subject_*.txt), performs all cleaning steps, and produces the final output:
  - tidy_UCI_HAR_Averages.txt — the dataset required by the assignment.
- CodeBook.md documents the dataset (source, variables, transformations) so reviewers can trace each step from raw to tidy data.

## Dependencies
- Base R + dplyr. The script installs dplyr automatically if missing.

## Expected Shape of the Tidy Output
- Rows: 180 (30 subjects × 6 activities)
- Columns: 68 → subject, activity_name, and 66 averaged measurement variables.

## Quick Preview in R
tidy <- read.table("tidy_UCI_HAR_Averages.txt", header = TRUE)
str(tidy)
head(tidy)
