#### Preamble ####
# Purpose: Cleans the Marriage License data
# Author: Aamishi Avarsekar
# Date: 19th September 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)
#### Read data ####
# 1. MEASUREMENTS DATA (AWS - BodyM)
measurements_subject_data <- read_parquet("data/raw_data/measurements_subject_data.parquet")
measurements_data <- read_parquet("data/raw_data/measurements_data.parquet")

measurements_subject_data_A <- read_parquet("data/raw_data/measurements_subject_data_A.parquet")
measurements_data_A <- read_parquet("data/raw_data/measurements_data_A.parquet")

# 2. BODY MASS DATA
body_mass_data <- read_parquet("data/raw_data/body_mass_data.parquet")

#### Clean data ####

# 1. MEASUREMENTS DATA (AWS - BodyM)
combined_data <- merge(measurements_subject_data, measurements_data, by = "subject_id")

cleaned_data <- combined_data %>%
  clean_names() %>%
  mutate(waist_hip_ratio = waist / hip) %>%
  mutate(original_bmi = weight_kg / (height_cm / 100)^2) %>%
  mutate(subject_id = seq(1, nrow(combined_data)))

cleaned_data$gender <- as.numeric(factor(combined_data$gender, levels = c("male", "female"))) - 1

analysis_data <- cleaned_data %>%
  select(subject_id, gender, height_cm, weight_kg, height, ankle, wrist, waist_hip_ratio, original_bmi)

analysis_data$category <- rep(NA, nrow(analysis_data))  # Create a placeholder column with 2018 rows
analysis_data$category <- factor(analysis_data$category, levels = c(
  "Extremely Underweight", "Underweight", "Normal", "Overweight", "Extremely Overweight"
))
analysis_data$category <- ifelse(analysis_data$original_bmi < 18.5, "Underweight",
                          ifelse(analysis_data$original_bmi < 25, "Normal",
                          ifelse(analysis_data$original_bmi < 30, "Overweight", 
                          ifelse(analysis_data$original_bmi < 30, "Obese I",
                          ifelse(analysis_data$original_bmi < 30, "Obese II", "Obese III")))))

# TEST A
combined_data_A <- merge(measurements_subject_data_A, measurements_data_A, by = "subject_id")

cleaned_data_A <- combined_data_A %>%
  clean_names() %>%
  mutate(waist_hip_ratio = waist / hip) %>%
  mutate(original_bmi = weight_kg / (height_cm / 100)^2) %>%
  mutate(subject_id = seq(1, nrow(combined_data_A)))

cleaned_data_A$gender <- as.numeric(factor(combined_data_A$gender, levels = c("male", "female"))) - 1

analysis_data_A <- cleaned_data_A %>%
  select(subject_id, gender, height_cm, weight_kg, height, ankle, wrist, waist_hip_ratio, original_bmi)

analysis_data_A$category <- rep(NA, nrow(analysis_data_A))  # Create a placeholder column with 2018 rows
analysis_data_A$category <- factor(analysis_data_A$category, levels = c(
  "Extremely Underweight", "Underweight", "Normal", "Overweight", "Extremely Overweight"
))
analysis_data_A$category <- ifelse(analysis_data_A$original_bmi < 18.5, "Underweight",
                                 ifelse(analysis_data_A$original_bmi < 25, "Normal",
                                        ifelse(analysis_data_A$original_bmi < 30, "Overweight", 
                                               ifelse(analysis_data_A$original_bmi < 30, "Obese I",
                                                      ifelse(analysis_data_A$original_bmi < 30, "Obese II", "Obese III")))))


# 2. BODY MASS DATA
body_mass_clean <- body_mass_data %>%
  clean_names()





#### Save data ####
write_parquet(analysis_data, "data/analysis_data/measurements_analysis_data.parquet")








