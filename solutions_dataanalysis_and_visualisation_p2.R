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

data_cut_region <- droplevels(data_cut_region)


# Summary 
summary(data_cut_region)

## This process, will reduce the number of core variables down to:
# One numerical variable (Number of activities) 
# Six Categorical variables we can use in our analysis or visualisations 

# Section 1: Applying Design Elements to ggplot2 

# Exercise 1: Creating Complex Visualisations 

# Exercise 2: Applying Advanced Design Elements 

# Exercise 3: Utilising the Welsh Government Visualisation Package 

# Section 2: Applying Machine Learning Models 

# Exercise 4: Data Preparation 

## Exercise 4a: Ensure the work you are doing within this section, through setting a seed 

set.seed(08062026) 

## Exercise 4b: Using the function `initial_split()` split the data_cut_region dataset 
  ## Into training and test data, with a 80:20 ratio. 

data_cut_region_split <- initial_split(data_cut_region, prop = 0.8)

## Exercise 4c: Divide this Large Initial Split object into a training and testing data frames 

data_cut_region_train <- training(data_cut_region_split) 
data_cut_region_test <- testing(data_cut_region_split)

### This should result in a training set where n = 136708, and testing set where n = 34178

# Exercise 5: Building a Tidy Model
# For today, we will be looking at building a CART Model (Regression Tree Model)
## Exercise 5a: First build a simple Decision Tree Model
  ## Remember to set the engine to "rpart", and the mode to "regression".

dt_model <- 
  decision_tree() |>
  set_engine("rpart") |>
  set_mode("regression")

## Exercise 5b: Next create a model fit, to: 
  ## Predict the number of activities based on the the age group, activity level and mode of programme

dt_model_fit_1 <- 
  dt_model |> 
  fit(data = data_cut_region_train,
      Number.of.activities ~ Age.group + Activity.level + Mode.of.programme)

## Exercise 5c: Check the outcomes of the model 

dt_model_res_1 <- 
  dt_model_fit_1 |>
  extract_fit_engine() |> 
  summary()

## Exercise 5d: Visualise these model outcomes
  ## Please note, this graphic is incredibly challenging to read, and hard to interpret. 
rpart.plot(dt_model_res_1)

# Exercise 6: Predicting with and Evaluating Tidy models 

## Exercise 6a: Using the testing data, test the prediction of the model 
dt_model_pred_1 <- 
  predict(dt_model_fit_1,
          new_data = data_cut_region_test)

## Exercise 6b: Join (using rbind), the true variables with the predicted 
dt_model_pred_res <- 
  bind_cols(dt_model_pred_1, 
            data_cut_region_test |> select(Number.of.activities))

## Exercise 6c: Using your knowledge of ggplot2, plot the predicted value (.pred) against the truth (Number.of.activities)
  # In this case, plot the "truth" on the x-axis, and the predicted on the y-axis 

ggplot(data = dt_model_pred_res) + 
  geom_point(mapping = aes(x = Number.of.activities, y = .pred)) + 


## Exercise 6d: Add an additional diagonal line (x = y), using `geom_abline()` 
  # to understand the line of best fit
  # Hint, leave geom_abline() blank to get a x = y line. 
  
ggplot(data = dt_model_pred_res) + 
  geom_point(mapping = aes(x = Number.of.activities, y = .pred)) + 
  geom_abline()

## Exercise 6e: Evaluate the created model with the evaluation metrics of RMSE, MAE and R-squared
model_metrics <- metric_set(rmse, mae, rsq)

dt_model_metric <- model_metrics(dt_model_pred_res, 
                                  truth = Number.of.activities, 
                                  estimate = .pred)

print(dt_model_metric)

### Conclusion - when we review these figures, we can see this model is pretty awful! 
### The R-Squared value helps to demonstrates that we are only marginally better off using this model than the mean.
### This result is likely due to the data, and potentially not being best suited to a regression driven decision tree. 




 