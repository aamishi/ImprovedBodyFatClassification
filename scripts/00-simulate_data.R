#### Preamble ####
# Purpose: Simulates Measurements (BodyM) data
# Author: Aamishi Avarsekar
# Date: 3rd December 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)

#### Simulate data #### This code was written by ChatGPT
set.seed(213)

# Define the number of rows to simulate
num_rows <- 1000

# Simulate the data
subject_id <- paste0("ID_", 1:num_rows)
gender <- sample(c("Male", "Female"), num_rows, replace = TRUE)
height <- runif(num_rows, 150, 200)  # Height in cm
weight <- runif(num_rows, 40, 100)  # Weight in kg
ankle <- runif(num_rows, 20, 30)  # Ankle circumference in cm
wrist <- runif(num_rows, 12, 20)  # Wrist circumference in cm
waist_hip_ratio <- runif(num_rows, 0.6, 1.0)  # Waist-to-hip ratio
height_hip_ratio <- height / (waist_hip_ratio * 2)  # Example height-to-hip ratio formula

# Simulate BMI
bmi <- weight / (height / 100)^2

# Create BMI categories based on common ranges
bmi_category <- cut(bmi, breaks = c(-Inf, 18.5, 24.9, 29.9, Inf),
                    labels = c("Underweight", "Normal", "Overweight", "Obese"))

# Simulate fat percentage categories
fat_percentage_category <- sample(c("Low", "Moderate", "High", "Extreme"), num_rows, replace = TRUE)

# Height categories (e.g., Low, Medium, High)
height_category <- cut(height, breaks = c(-Inf, 160, 180, Inf), 
                       labels = c("Short", "Average", "Tall"))

# Combine all variables into a data frame
measurements_simulated_data <- data.frame(
  subject_id, gender, height, weight, ankle, wrist, waist_hip_ratio, 
  height_hip_ratio, bmi, bmi_category, fat_percentage_category, height_category
)

# View the first few rows of the simulated data
head(measurements_simulated_data)





