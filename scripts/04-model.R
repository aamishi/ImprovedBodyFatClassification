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
library(tidyr)

#### Read data ####
cleaned_data_model <- read_parquet("data/analysis_data/measurements_analysis_data.parquet")
body_mass_model <- read_parquet("data/analysis_data/body_mass_data.parquet")

# Multinomial logistic regression model
# subject_id, gender, height_cm, weight_kg, height, ankle, wrist, waist_hip_ratio, original_bmi
# Variables selected:
measurements_model <- multinom(fat_percentage_category ~ height + gender + waist_hip_ratio + height_hip_ratio, data = cleaned_data_model)
# Summary of the model
summary(measurements_model)


#### Read data ####
# body_mass_model <- multinom(fm ~ bmi_category , data = body_mass_read)
body_mass_model_bmi <- multinom(fat_percentage_category ~ gender + fm + bmr_kcal + muscle_mass_kg + fm_trunk, data = body_mass_model)
body_mass_model$predicted_category <- predict(body_mass_model_bmi, newdata = body_mass_model)


# body_mass_model <- randomForest(fm ~ height + weight + gender * predicted_category + muscle_mass_kg, data = body_mass_read)

data_long <- body_mass_model %>%
  pivot_longer(cols = c(fat_percentage_category, predicted_category),
               names_to = "BMI_Category_Type", values_to = "BMI_Category")

# Boxplot - i like 
ggplot(data_long, aes(x = BMI_Category, y = fm, fill = BMI_Category_Type)) +
  geom_boxplot(position = position_dodge(0.8), alpha = 0.7) +
  labs(title = "Fat Mass Percentage by BMI Category", 
       x = "BMI Category", y = "Fat Mass Percentage (%)") +
  theme_minimal()

ggplot(data_long, aes(x = fm, fill = BMI_Category_Type)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~BMI_Category, scales = "free") +
  labs(title = "Fat Mass Distribution by BMI Category", 
       x = "Fat Mass Percentage (%)", y = "Density") +
  theme_minimal()

#### Save model ####
saveRDS(
  measurements_model,
  file = "models/measurements_model.rds"
)
# BODY MASS
#### Save model ####
# saveRDS(
#   body_mass_model,
#   file = "models/body_mass_model.rds"
# )

saveRDS(
  body_mass_model_bmi,
  file = "models/body_mass_model_bmi.rds"
)


