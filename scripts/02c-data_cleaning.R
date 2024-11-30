#### Preamble ####
# Purpose: Cleans the Marriage License data
# Author: Aamishi Avarsekar
# Date: 19th September 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Note: Aspects of this code was written with the aid of ChatGPT 4.0

# Work space setup
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)

#Read data
# 1. MEASUREMENTS DATA (AWS - BodyM)
measurements_subject_data <- read_parquet("data/raw_data/test_subject_data.parquet")
measurements_data <- read_parquet("data/raw_data/test_data.parquet")

#### Clean data ####

# 1. MEASUREMENTS DATA (AWS - BodyM)
combined_test_data <- merge(measurements_subject_data, measurements_data, by = "subject_id")

cleaned_test_data <- combined_test_data %>%
  clean_names() %>%
  mutate(waist_hip_ratio = waist / hip) %>%
  mutate(original_bmi = weight_kg / (height_cm / 100)^2) %>%
  mutate(subject_id = seq(1, nrow(combined_test_data))) %>%
  select(-height) %>%
  rename(
    height = height_cm,  
    weight = weight_kg,           
    bmi = original_bmi                
  )

cleaned_test_data$gender <- as.numeric(factor(combined_test_data$gender, levels = c("male", "female"))) - 1

# Written with the help of ChatGPT with modifications
# Create a placeholder column with 2018 rows
cleaned_test_data$bmi_category <- factor(NA, levels = c("Underweight", "Normal", "Overweight", "Obese"))

# Assign category based on original_bmi values
cleaned_test_data$bmi_category <- ifelse(cleaned_test_data$bmi < 18.5, "Underweight",
                                    ifelse(cleaned_test_data$bmi < 25, "Normal",
                                           ifelse(cleaned_test_data$bmi < 30, "Overweight", "Obese")))

# Ensure 'category' is a factor with the correct levels
cleaned_test_data$bmi_category <- factor(cleaned_test_data$bmi_category, levels = c("Underweight", "Normal", "Overweight", "Obese"))

# Changing gender: 1 = male, 2 = female
# Selecting only: subject_id, gender, height, weight, bmi, bmi_category
cleaned_test_data <- cleaned_test_data %>%
  select(subject_id, gender, height, weight, bmi, bmi_category) %>%
  mutate(gender = case_when(
    gender == 0 ~ "male",
    gender == 1 ~ "female"), 
    model_1_predicted_categories = NA, # prepping model application
    model_2_predicted_categories = NA
    ) # closing mutate fn
  

#### Save data ####
write_parquet(cleaned_test_data, "data/analysis_data/test_analysis.parquet")






