#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
### Model data ####
library(nnet)

#### Read data ####
analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")

# Multinomial logistic regression model
# subject_id, gender, height_cm, weight_kg, height, ankle, wrist, waist_hip_ratio, original_bmi
multi_model <- multinom(category ~ weight_kg + height_cm + waist_hip_ratio + wrist + ankle, data = analysis_data)
# Summary of the model
summary(multi_model)


analysis_data$predicted_category <- predict(multi_model, newdata = analysis_data)
table(Predicted = analysis_data$predicted_category, Actual = body_mass_clean$category)


#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)


