#### Preamble ####
# Purpose: Model for Measurements Data and Body Composition Data
# Author: Aamishi Avarsekar
# Date: 3rd Decemeber 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Note: Aspects of this code was written with the aid of ChatGPT 4.0

# Works pace setup - packages needed
library(tidyverse)
library(arrow)
library(nnet)
library(tidyr)
library(brms)



#### Read data ####
cleaned_data_model <- read_parquet("data/analysis_data/measurements_analysis_data.parquet")
body_mass_model <- read_parquet("data/analysis_data/body_mass_data.parquet")

# Multinomial logistic regression model
measurements_model <- multinom(fat_percentage_category ~ height + gender + waist_hip_ratio + height_hip_ratio, data = cleaned_data_model)
cleaned_data_model$predicted_category <- predict(measurements_model, newdata = cleaned_data_model)

body_mass_model_bmi <- multinom(fat_percentage_category ~ age + height + gender + fm, data = body_mass_model)
body_mass_model$predicted_category <- predict(body_mass_model_bmi, newdata = body_mass_model)

summary(body_mass_model_bmi)

#### Save model ####
write_parquet(cleaned_data_model, "data/analysis_data/measurements_analysis_data.parquet")
saveRDS(
  measurements_model,
  file = "models/measurements_model.rds"
)
write_parquet(body_mass_model, "data/analysis_data/body_mass_data.parquet")

saveRDS(
  body_mass_model_bmi,
  file = "models/body_mass_model_bmi.rds"
)


