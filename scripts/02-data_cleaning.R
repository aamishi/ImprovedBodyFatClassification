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

# Written with the help of ChatGPT with modifications
# fat_categories with waist_hip_ratio as a proxy
categorize_whr <- function(whr, sex) {
  if (sex == 2) {
    if (whr < 0.80) {
      return("low")
    } else if (whr >= 0.80 & whr < 0.85) {
      return("moderate")
    } else if (whr >= 0.85 & whr < 0.90) {
      return("high")
    } else {
      return("extreme")
    }
  } else if (sex == 1) {
    if (whr < 0.90) {
      return("low")
    } else if (whr >= 0.90 & whr < 0.95) {
      return("moderate")
    } else if (whr >= 0.95 & whr < 1.00) {
      return("risk")
    } else {
      return("extreme")
    }
  } else {
    return("Invalid sex")
  }
}

# 1. MEASUREMENTS DATA (AWS - BodyM)
combined_data <- merge(measurements_subject_data, measurements_data, by = "subject_id")

cleaned_data <- combined_data %>%
  clean_names() %>%
  mutate(gender = as.numeric(factor(combined_data$gender, levels = c("male", "female")))) %>%
  mutate(waist_hip_ratio = waist / hip) %>%
  mutate(height_hip_ratio = height_cm / hip) %>%
  mutate(original_bmi = weight_kg / (height_cm / 100)^2) %>%
  mutate(subject_id = seq(1, nrow(combined_data))) %>%
  select(-height) %>%
  rename(
    height = height_cm,  
    weight = weight_kg,           
    bmi = original_bmi                
  ) %>%
  select(subject_id, gender, height, weight, ankle, wrist, waist_hip_ratio, height_hip_ratio, bmi) %>%
  mutate(fat_percentage_category = mapply(categorize_whr, waist_hip_ratio, gender))
  

cleaned_data$gender <- as.numeric(factor(combined_data$gender, levels = c("male", "female"))) 


#### Save data ####
write_parquet(cleaned_data, "data/analysis_data/measurements_analysis_data.parquet")








