# Data Analysis & Visualisation Part 2 - Solutions

# Setup Execution 
## This will use the function "source()" to run the separate R File "setup.R"
## The "setup.R" file includes information such as: which packages to install, 
## and to check the working directory is correctly set. 
source("setup.R", local = FALSE)

# Package Loading 
library(tidymodels)
library(tidyverse)
library(stats)
library(rpart, rpart.plot)
library(devtools)

## KASStylesr Package Install
## This install will be dependant on the location of you have saved the file, I chose to clone it directly into my WD
WD <- getwd() 
install.packages(paste(WD, "/KASStylesR/kasstylesr_0.0.1.0000.tar.gz", sep = ""), 
                 repos = NULL, type = "source")
library(kasstylesr)

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

data_cut_region <- subset(data_cut_region, 
                          Mode.of.programme != "Total")

data_cut_region <- droplevels(data_cut_region)


# Summary 
summary(data_cut_region)

## This process, will reduce the number of core variables down to:
# One numerical variable (Number of activities) 
# Six Categorical variables we can use in our analysis or visualisations 

# Section 1: Applying Design Elements to ggplot2 

# Exercise 1: Creating Complex Visualisations 
# One method to increase the complexity of plots is by displaying more information....
## Exercise 1a: Create a jitter plot which plots Number of Activities (y), against Academic Year (x), 
  ## Demonstrating the distribution of points by using colouring points depending on the age group 

ggplot(data = data_cut_region) + 
  geom_jitter(??)

## This of course is not the only way to add complexity, as you can define shape also to show more information
## Exercise 1b: Expand on the jitter plot from 1a, this time adding a shape variable linked to the Mode of Programme 



# Exercise 2: Applying Advanced Design Elements 
## There are multiple design elements which you can add to improve the readability of your visualisations: 

## Exercise 2a: Building on the plot created in 1a, use `theme(axis.text.x = element_text())` to rotate the axis labels by 90 degrees
## Note - you can add vjust = 0.5 and hjust = 1 to make things more readable! 



## At times however, you may want to spit up your graphics to understand the topic more. 
## Exercise 2b: Using facet_grid, where you specific cols as the variable Mode of Programme, 
  ## Further improve th readability of the visualisation from 2a 

ggplot(data = data_cut_region) + 
  geom_jitter(??) + 
  theme(??) + 
  facet_grid(??)

## This visualisation however still presents incredibly dense information, 
## Exercise 2c: Recreate the visualisation in 2b, using only data from the year 2019-2020

ggplot(data = 
         data_cut_region |> subset(Academic.year == "2019-20")) + 
  geom_jitter(??) + 
  theme(??) + 
  facet_grid(??)
  

# Exercise 3: Utilising the Welsh Government Visualisation Package 

## You can use the Welsh Government Visualisation style as a theme! Using `kas_style()`
## Exercise 3a: Reproduce one of the visualisations we have already created today, but include the `kas_style()` layer


# Section 2: Applying Machine Learning Models 

# Exercise 4: Data Preparation 

## Exercise 4a: Ensure the work you are doing within this section, through setting a seed 

set.seed(08062026) 

## Exercise 4b: Using the function `initial_split()` split the data_cut_region dataset 
  ## Into training and test data, with a 80:20 ratio. 

data_cut_region_split <- initial_split(??)

## Exercise 4c: Divide this Large Initial Split object into a training and testing data frames 

data_cut_region_train <- training(??) 
data_cut_region_test <- testing(??)

### This should result in a training set where n = 136708, and testing set where n = 34178

# Exercise 5: Building a Tidy Model
# For today, we will be looking at building a CART Model (Regression Tree Model)
## Exercise 5a: First build a simple Decision Tree Model
  ## Remember to set the engine to "rpart", and the mode to "regression".

dt_model <- 
  decision_tree() |>
  set_engine(??) |>
  set_mode(??)

## Exercise 5b: Next create a model fit, to: 
  ## Predict the number of activities based on the the age group, activity level and mode of programme

dt_model_fit_1 <- 
  dt_model |> 
  fit(data = ??,
      ?? ~ ?? + ?? + ??)

## Exercise 5c: Check the outcomes of the model 

dt_model_res_1 <- 
  dt_model_fit_1 |>
  extract_fit_engine() |> 
  summary()

## Exercise 5d: Visualise these model outcomes
  ## Please note, this graphic is incredibly challenging to read, and hard to interpret. 
rpart.plot(??)

# Exercise 6: Predicting with and Evaluating Tidy models 

## Exercise 6a: Using the testing data, test the prediction of the model 
dt_model_pred_1 <- 
  predict(??,
          new_data = ??)

## Exercise 6b: Join (using rbind), the true variables with the predicted 
dt_model_pred_res <- 
  bind_cols(dt_model_pred_1, 
            ??)

## Exercise 6c: Using your knowledge of ggplot2, plot the predicted value (.pred) against the truth (Number.of.activities)
  # In this case, plot the "truth" on the x-axis, and the predicted on the y-axis 


## Exercise 6d: Add an additional diagonal line (x = y), using `geom_abline()` 
  # to understand the line of best fit
  # Hint, leave geom_abline() blank to get a x = y line. 
  

## Exercise 6e: Evaluate the created model with the evaluation metrics of RMSE, MAE and R-squared
model_metrics <- metric_set(??)

dt_model_metric <- model_metrics(??, 
                                  truth = ??, 
                                  estimate = ??)

print(dt_model_metric)

### Conclusion - when we review these figures, we can see this model is pretty awful! 
### The R-Squared value helps to demonstrates that we are only marginally better off using this model than the mean.
### This result is likely due to the data, and potentially not being best suited to a regression driven decision tree. 




 