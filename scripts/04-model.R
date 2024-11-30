#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


# Works pace setup - packages needed
library(tidyverse)
library(rstanarm)
library(nnet)
library(randomForest)

#### Read data ####
cleaned_data <- read_parquet("data/analysis_data/measurements_analysis_data.parquet")
body_mass_read <- read_parquet("data/analysis_data/body_mass_data.parquet")

# Multinomial logistic regression model
# subject_id, gender, height_cm, weight_kg, height, ankle, wrist, waist_hip_ratio, original_bmi
# Variables selected:
measurements_model <- multinom(bmi_category ~ height + gender + waist_hip_ratio + height_hip_ratio, data = cleaned_data)
# Summary of the model
summary(measurements_model)


#### Read data ####
# body_mass_model <- multinom(fm ~ bmi_category , data = body_mass_read)
body_mass_model_bmi <- multinom(bmi_category ~ gender + fm + bmr_kcal + muscle_mass_kg + fm_trunk, data = body_mass_read)
body_mass_read$predicted_category <- predict(body_mass_model_bmi, newdata = body_mass_read)


body_mass_model <- randomForest(fm ~ height + weight + gender * predicted_category + muscle_mass_kg, data = body_mass_read)


# model 2 - final work being done here
body_mass_read$predicted_fm <- predict(body_mass_model, newdata = body_mass_read)
plot(body_mass_read$fm, body_mass_read$predicted_fm,
     xlab = "Actual Fat Percentage",
     ylab = "Estimated Fat Percentage",
     main = "Estimated vs Actual Fat Percentage",
     pch = 16, col = "blue")
abline(a = 0, b = 1, col = "red", lty = 2) # Add a 1:1 reference line



#### Save model ####
saveRDS(
  measurements_model,
  file = "models/measurements_model.rds"
)
# BODY MASS
#### Save model ####
saveRDS(
  body_mass_model,
  file = "models/body_mass_model.rds"
)

saveRDS(
  body_mass_model_bmi,
  file = "models/body_mass_model_bmi.rds"
)


