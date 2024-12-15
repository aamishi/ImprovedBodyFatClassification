#### Preamble ####
# Purpose: Cleans the Body Mass Data (Isaaz Kuzmar Et Al)
# Author: Aamishi Avarsekar
# Date: 3rd Decemeber 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Note: Aspects of this code was written with the aid of ChatGPT 4.0

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)

#### Read BODY MASS DATA
body_mass_data_raw <- read_parquet("data/raw_data/body_mass_data.parquet")

# Define thresholds in a function ( written with ChapGPT)
assign_fat_category <- function(gender, age, fm) {
  if (gender == 1) {  # Male
    if (age < 40) {
      if (fm < 8) return("Low")
      else if (fm <= 20) return("Moderate")
      else if (fm <= 25) return("High")
      else return("Extreme")
    } else if (age < 60) {
      if (fm < 11) return("Low")
      else if (fm <= 22) return("Moderate")
      else if (fm <= 28) return("High")
      else return("Extreme")
    } else {
      if (fm < 13) return("Low")
      else if (fm <= 25) return("Moderate")
      else if (fm <= 30) return("High")
      else return("Extreme")
    }
  } else if (gender == 2) {  # Female
    if (age < 40) {
      if (fm < 21) return("Low")
      else if (fm <= 33) return("Moderate")
      else if (fm <= 39) return("High")
      else return("Extreme")
    } else if (age < 60) {
      if (fm < 23) return("Low")
      else if (fm <= 34) return("Moderate")
      else if (fm <= 40) return("High")
      else return("Extreme")
    } else {
      if (fm < 24) return("Low")
      else if (fm <= 36) return("Moderate")
      else if (fm <= 42) return("High")
      else return("Extreme")
    }
  } else {
    return(NA)  # Invalid gender
  }
}

min_height <- 150
max_height <- 180

#### Clean Data ####
body_mass_clean <- body_mass_data_raw %>%
  clean_names() %>%
  select(gender_m1f2, age, height_cm, w_kg, bmi, fat_mass_kg, fm, ffm_kg, bone_mass_kg, muscle_mass_kg, bmr_kcal, fm_trunk) %>%
  mutate(
    bmi_category = case_when(
      bmi < 18.5 ~ "Underweight",
      bmi >= 18.5 & bmi <= 24.9 ~ "Normal",
      bmi >= 25.0 & bmi <= 29.9 ~ "Overweight",
      bmi >= 30.0 ~ "Obese"
    )) %>%
  rename(
    height = height_cm,  
    weight = w_kg,           
    gender = gender_m1f2                
  ) %>%
  mutate(age = ceiling(age)) %>%
  # mutate(fat_percentage_category = mapply(assign_fat_category, gender, age, fm)) %>%
  mutate(fat_percentage_category = factor(
    mapply(assign_fat_category, gender, age, fm),
    levels = c("Moderate", "Low", "High", "Extreme") 
  )) %>%
  mutate(
    height_category = cut(
      height,
      breaks = c(-Inf, min_height, seq(min_height + 10, max_height, by = 10), Inf),  # Add breaks for beLow 150 and above 180
      labels = c("Shorter than 150", "150-160", "160-170", "170-180", "Taller than 180"),  # Define labels
      include.lowest = TRUE,  # Include the lowest value (150) in the first category
      right = FALSE  # Make intervals left-closed, so 150 goes into the "150-160" range
    )
  )

#### Save data ####
write_parquet(body_mass_clean, "data/analysis_data/body_mass_data.parquet")