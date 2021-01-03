---
title: "Getting and Cleaning Data Course Project"
author: "Angus Mackenzie"
date: "03/01/2021"
---

## Code Book

This details the steps that run_analysis.R performs


## Steps

1. Set up
    + Loads packages
    + Sets directories 
    + Downloads and unzips data
2. Data frames creation
3. Requirement 1 - Merge Data
    + Uses cbind and rbind to create the merged data frame "dfmerge"
4. Requirement 2 - Extracts mean and standard deviation
    + Creates tidier data frame "dfsub"
5. Requirement 3 - Name activities
    + Adds activity description to "dfsub"
6. Requirement 4 - Descriptive Variable Names
    + Renames variables so that they are easier to understand
7. Requirement 5 - Mean data frame  
    + Creates the data frame "dfmean" which summarises the averages for each subject
    + Exports "Subject_Averages.csv"


