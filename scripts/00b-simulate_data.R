#### Preamble ####
# Purpose: Simulates Body Composition data
# Author: Aamishi Avarsekar
# Date: 3rd December 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# This code was written by ChatGPT

set.seed(123)  # For reproducibility

# Number of rows to simulate
n <- 1000

# Simulate the columns
body_mass_testing <- data.frame(
  gender = sample(c("Male", "Female"), n, replace = TRUE),
  age = sample(18:80, n, replace = TRUE),
  height = rnorm(n, mean = 170, sd = 10),  # average height with some variability
  weight = rnorm(n, mean = 70, sd = 15),   # average weight with some variability
  bmi = rnorm(n, mean = 25, sd = 5),       # typical BMI range
  fat_mass_kg = rnorm(n, mean = 15, sd = 5), 
  fm = rnorm(n, mean = 20, sd = 8),        # fat mass in kg
  ffm_kg = rnorm(n, mean = 50, sd = 10),   # fat-free mass in kg
  bone_mass_kg = rnorm(n, mean = 3, sd = 1),
  muscle_mass_kg = rnorm(n, mean = 30, sd = 7),
  bmr_kcal = rnorm(n, mean = 1500, sd = 300),  # basal metabolic rate
  fm_trunk = rnorm(n, mean = 7, sd = 2),   # fat mass in trunk area
  bmi_category = sample(c("Underweight", "Normal", "Overweight", "Obese"), n, replace = TRUE),
  fat_percentage_category = sample(c("Low", "Moderate", "High", "Extreme"), n, replace = TRUE),
  height_category = sample(c("Short", "Average", "Tall"), n, replace = TRUE),
  predicted_category = sample(c("Low", "Moderate", "High", "Extreme"), n, replace = TRUE),
  weight_category = sample(c("Underweight", "Normal", "Overweight", "Obese"), n, replace = TRUE)
)

# View first few rows of the simulated data
head(body_mass_testing)

