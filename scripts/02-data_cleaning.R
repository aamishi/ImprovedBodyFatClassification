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
categorize_bfp <- function(bmi_category) {
    if (bmi_category == "Underweight") {
      return("low")
    } else if (bmi_category == "Normal") {
      return("moderate")
    } else if (bmi_category == "Overweight") {
      return("high")
    } else {
      return("extreme")
    }
}

# categorize_bfp <- function(gender, whr) {
#   if (gender == 1) {  # Male
#     if (whr < 0.90) {
#       return("low")
#     } else if (whr < 0.95) {
#       return("moderate")
#     } else if (whr <= 1.00) {
#       return("high")
#     } else {
#       return("extreme")
#     }
#   } else if (gender == 2) {  # Female
#     if (whr < 0.80) {
#       return("low")
#     } else if (whr < 0.85) {
#       return("moderate")
#     } else if (whr <= 0.90) {
#       return("high")
#     } else {
#       return("extreme")
#     }
#   } else {
#     return(NA)  # Invalid gender
#   }
# }

# 1. MEASUREMENTS DATA (AWS - BodyM)
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
  mutate(fat_percentage_category = mapply(categorize_bfp, bmi_category)) %>%
  mutate(
    height_category = cut(
      height,
      breaks = c(-Inf, min_height, seq(min_height + 10, max_height, by = 10), Inf),  # Add breaks for below 150 and above 180
      labels = c("Shorter than 150", "150-160", "160-170", "170-180", "Taller than 180"),  # Define labels
      include.lowest = TRUE,  # Include the lowest value (150) in the first category
      right = FALSE  # Make intervals left-closed, so 150 goes into the "150-160" range
    )
  )

# Normalize the data to get proportions for each fat_percentage_category and predicted_category within each height_category
heatmap_data <- elongated_data %>%
  count(fat_percentage_category, predicted_category, source, height_category) %>%
  group_by(height_category, fat_percentage_category) %>%
  mutate(proportion = n / sum(n))  # Normalize by height_category and fat_percentage_category

# Create the heatmap with normalized proportions and faceting by height_category
ggplot(heatmap_data, aes(x = fat_percentage_category, y = predicted_category, fill = proportion)) +
  geom_tile() +  # Create heatmap tiles
  scale_fill_gradient(low = "white", high = "blue") +  # Color scale for proportions
  labs(title = "Normalized Heatmap of Fat Percentage Category vs Predicted Category (Source Highlighted)",
       x = "Fat Percentage Category",
       y = "Predicted Category",
       fill = "Proportion") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for readability



#### Save data ####
write_parquet(cleaned_data, "data/analysis_data/measurements_analysis_data.parquet")








