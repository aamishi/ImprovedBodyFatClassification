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
  )

#body_mass_under_25 <-

#### Save data ####
write_parquet(body_mass_clean, "data/analysis_data/body_mass_data.parquet")
