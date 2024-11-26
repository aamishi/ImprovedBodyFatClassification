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
subject_sex_data <- read_parquet("data/raw_data/subject_sex_data.parquet")
measurements_data <- read_parquet("data/raw_data/measurements_data.parquet")

#### Clean data ####
combined_data <- merge(subject_sex_data, measurements_data, by = "subject_id")

cleaned_data <- combined_data %>%
  clean_names() %>%
  mutate(waist_hip_ratio = waist / hip) %>%
  mutate(original_bmi = weight_kg / (height_cm / 100)^2) %>%
  mutate(subject_id = seq(1, nrow(combined_data)))

cleaned_data$gender <- as.numeric(factor(combined_data$gender, levels = c("male", "female"))) - 1

analysis_data <- cleaned_data %>%
  select(subject_id, gender, height_cm, weight_kg, height, ankle, wrist, waist_hip_ratio, original_bmi)
#### Save data ####
write_parquet(analysis_data, "data/analysis_data/analysis_data.parquet")








