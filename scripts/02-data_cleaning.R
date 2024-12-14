#### Preamble ####
# Purpose: Cleans the Measurements Data (BodyM)
# Author: Aamishi Avarsekar
# Date: 3rd Decemeber 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Note: Aspects of this code was written with the aid of ChatGPT 4.0

# Work space setup
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)

# Read MEASUREMENTS DATA (AWS - BodyM)
measurements_subject_data <- read_parquet("data/raw_data/measurements_subject_data.parquet")
measurements_data <- read_parquet("data/raw_data/measurements_data.parquet")

#### Clean data ####

# Written with the help of ChatGPT with modifications
# fat categories with BMI as a proxy
categorize_bfp <- function(bmi_category) {
    if (bmi_category == "Underweight") {
      return("Low")
    } else if (bmi_category == "Normal") {
      return("Moderate")
    } else if (bmi_category == "Overweight") {
      return("High")
    } else {
      return("Extreme")
    }
}
combined_data <- merge(measurements_subject_data, measurements_data, by = "subject_id")

min_height <- 150
max_height <- 180

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
  mutate(
    bmi_category = case_when(
      bmi < 18.5 ~ "Underweight",
      bmi >= 18.5 & bmi < 25 ~ "Normal",
      bmi >= 25 & bmi < 30 ~ "Overweight",
      bmi >= 30 ~ "Obese",
      TRUE ~ "Unknown"
    )) %>%
  # mutate(fat_percentage_category = mapply(categorize_bfp, bmi_category)) %>%
  mutate(fat_percentage_category = factor(
    mapply(categorize_bfp, bmi_category),
    levels = c("Moderate", "Low", "High", "Extreme") 
  )) %>%
  mutate( # This part was written with the help of ChatGPT
    height_category = cut(
      height,
      breaks = c(-Inf, min_height, seq(min_height + 10, max_height, by = 10), Inf),  # Add breaks for below 150 and above 180
      labels = c("Shorter than 150", "150-160", "160-170", "170-180", "Taller than 180"),  # Define labels
      include.lowest = TRUE,  # Include the lowest value (150) in the first category
      right = FALSE  # Make intervals left-closed, so 150 goes into the "150-160" range
    )
  )


#### Save data ####
write_parquet(cleaned_data, "data/analysis_data/measurements_analysis_data.parquet")