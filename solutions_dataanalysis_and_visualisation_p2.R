# Data Analysis & Visualisation Part 2 - Solutions

# Setup Execution 
## This will use the function "source()" to run the separate R File "setup.R"
## The "setup.R" file includes information such as: which packages to install, 
## and to check the working directory is correctly set. 
source("setup.R", local = FALSE)

# Package Loading 
library(tidyverse)
library(stats)
library(tidymodels)
tidymodels_prefer()

# Option Definition 
options(scipen = 999)

# Section 0: Data Loading and Preparation 
# To save time, I have pre-written some code to subset out main dataset. 

# Data Read-in
data <- read.csv(file = "data/data_wales_education.csv")

# Number of Activities name change 
data <- rename(data, Number.of.activities = Data.values_sort)

# Extraction of character-based columns 
chr_cols <- sapply(data, is.character)

# Conversion to factors 
data[chr_cols] <- lapply(data[chr_cols], as.factor)

# Selection of columns 
data_cut <- select(data, 
                   Number.of.activities, 
                   Academic.year,
                   Mode.of.programme,
                   Home.region,
                   Age.group,
                   Activity.level,
                   Medium.of.delivery)

# Subset to a specific region 
data_cut_region <- subset(data_cut, 
                          Home.region == "All areas")


# Summary 
summary(data_cut_region)

## This process, will reduce the number of core variables down to:
# One numerical variable (Number of activities) 
# Six Categorical variables we can use in our analysis or visualisations 