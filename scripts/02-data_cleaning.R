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
measurements_subject_data <- read_parquet("data/raw_data/measurements_subject_data.parquet")
measurements_data <- read_parquet("data/raw_data/measurements_data.parquet")

#### Clean data ####

# 1. MEASUREMENTS DATA (AWS - BodyM)
combined_data <- merge(measurements_subject_data, measurements_data, by = "subject_id")

cleaned_data <- combined_data %>%
  clean_names() %>%
  mutate(waist_hip_ratio = waist / hip) %>%
  mutate(height_hip_ratio = height_cm / hip) %>%
  mutate(original_bmi = weight_kg / (height_cm / 100)^2) %>%
  mutate(subject_id = seq(1, nrow(combined_data))) %>%
  select(-height) %>%
  rename(
    height = height_cm,  
    weight = weight_kg,           
    bmi = original_bmi                
  )

cleaned_data$gender <- as.numeric(factor(combined_data$gender, levels = c("male", "female"))) 

# Written with the help of ChatGPT with modifications
# Create a placeholder column with 2018 rows
cleaned_data$bmi_category <- factor(NA, levels = c("Underweight", "Normal", "Overweight", "Obese"))

# Assign category based on original_bmi values
cleaned_data$bmi_category <- ifelse(cleaned_data$bmi < 18.5, "Underweight",
                                 ifelse(cleaned_data$bmi < 25, "Normal",
                                        ifelse(cleaned_data$bmi < 30, "Overweight", "Obese")))

# Ensure 'category' is a factor with the correct levels
cleaned_data$bmi_category <- factor(cleaned_data$bmi_category, levels = c("Underweight", "Normal", "Overweight", "Obese"))


#### Save data ####
write_parquet(cleaned_data, "data/analysis_data/measurements_analysis_data.parquet")








