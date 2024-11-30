#### Preamble ####
# Purpose: TODO
# Author: Aamishi Avarsekar
# Date: TODO
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)

#### Read Data ####
# 2. BODY MASS DATA
body_mass_data_raw <- read_parquet("data/raw_data/body_mass_data.parquet")

library(dplyr)

# Define thresholds in a function
assign_female_fat_category <- function(age, fm) {
  if (age >= 18 & age <= 29) {
    if (fm < 14) return("low")
    if (fm <= 16.5) return("excellent")
    if (fm <= 19.4) return("good")
    if (fm <= 22.7) return("fair")
    if (fm <= 27.1) return("poor")
    return("high")
  } else if (age >= 30 & age <= 39) {
    if (fm < 14) return("low")
    if (fm <= 17.4) return("excellent")
    if (fm <= 20.8) return("good")
    if (fm <= 24.6) return("fair")
    if (fm <= 29.1) return("poor")
    return("high")
  } else if (age >= 40 & age <= 49) {
    if (fm < 14) return("low")
    if (fm <= 19.8) return("excellent")
    if (fm <= 23.8) return("good")
    if (fm <= 27.6) return("fair")
    if (fm <= 31.9) return("poor")
    return("high")
  } else if (age >= 50 & age <= 59) {
    if (fm < 14) return("low")
    if (fm <= 22.5) return("excellent")
    if (fm <= 27.0) return("good")
    if (fm <= 30.4) return("fair")
    if (fm <= 34.5) return("poor")
    return("high")
  } else if (age >= 60 & age <= 69) {
    if (fm < 14) return("low")
    if (fm <= 23.2) return("excellent")
    if (fm <= 27.9) return("good")
    if (fm <= 31.3) return("fair")
    if (fm <= 35.4) return("poor")
    return("high")
  } else {
    return(NA)  # Return NA if age is outside the defined range
  }
}

# Define thresholds in a function for men
assign_male_fat_category <- function(age, fm) {
  if (age >= 18 & age <= 29) {
    if (fm < 8) return("low")
    if (fm <= 10.5) return("excellent")
    if (fm <= 14.8) return("good")
    if (fm <= 18.6) return("fair")
    if (fm <= 23.1) return("poor")
    return("high")
  } else if (age >= 30 & age <= 39) {
    if (fm < 8) return("low")
    if (fm <= 11.4) return("excellent")
    if (fm <= 15.5) return("good")
    if (fm <= 19.6) return("fair")
    if (fm <= 24.0) return("poor")
    return("high")
  } else if (age >= 40 & age <= 49) {
    if (fm < 8) return("low")
    if (fm <= 13.7) return("excellent")
    if (fm <= 17.3) return("good")
    if (fm <= 21.1) return("fair")
    if (fm <= 26.0) return("poor")
    return("high")
  } else if (age >= 50 & age <= 59) {
    if (fm < 8) return("low")
    if (fm <= 15.3) return("excellent")
    if (fm <= 20.1) return("good")
    if (fm <= 23.5) return("fair")
    if (fm <= 28.0) return("poor")
    return("high")
  } else if (age >= 60 & age <= 69) {
    if (fm < 8) return("low")
    if (fm <= 16.0) return("excellent")
    if (fm <= 20.9) return("good")
    if (fm <= 24.5) return("fair")
    if (fm <= 29.0) return("poor")
    return("high")
  } else {
    return(NA)  # Return NA if age is outside the defined range
  }
}


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
  mutate(fat_percentage_category = ifelse(
    gender == 2,  # Females
    mapply(assign_female_fat_category, age, fm),
    ifelse(
      gender == 1,  # Males
      mapply(assign_male_fat_category, age, fm),
      NA  # Or other logic for undefined genders
    )
  ))


#### Save data ####
write_parquet(body_mass_clean, "data/analysis_data/body_mass_data.parquet")
