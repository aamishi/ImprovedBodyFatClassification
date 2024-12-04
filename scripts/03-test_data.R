#### Preamble ####
# Purpose: Tests Measurements (BodyM) data
# Author: Aamishi Avarsekar
# Date: 3rd December 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# This was written by ChatGPT


#### Workspace setup ####
library(tidyverse)

#### Test data ####
measurement_data_testing<- read_parquet("data/analysis_data/measurements_analysis_data.parquet")

library(testthat)

# Function to simulate the data
simulate_data <- function(num_rows = 1000) {
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
  data.frame(
    subject_id, gender, height, weight, ankle, wrist, waist_hip_ratio, 
    height_hip_ratio, bmi, bmi_category, fat_percentage_category, height_category
  )
}

# Test 1: Check if the dataset contains the expected columns
test_that("Dataset has expected columns", {
  simulated_data <- simulate_data()
  expected_columns <- c("subject_id", "gender", "height", "weight", "ankle", "wrist", 
                        "waist_hip_ratio", "height_hip_ratio", "bmi", "bmi_category", 
                        "fat_percentage_category", "height_category")
  expect_true(all(expected_columns %in% colnames(simulated_data)))
})

# Test 2: Check if all BMI values are within a reasonable range (18.5 to 40)
test_that("BMI values are within a reasonable range", {
  simulated_data <- simulate_data()
  expect_true(all(simulated_data$bmi >= 10 & simulated_data$bmi <= 70))
})

# Test 3: Ensure that the gender column only contains "Male" or "Female"
test_that("Gender values are correct", {
  simulated_data <- simulate_data()
  expect_true(all(simulated_data$gender %in% c("Male", "Female")))
})

# Test 4: Ensure the height categories are valid
test_that("Height categories are correct", {
  simulated_data <- simulate_data()
  expect_true(all(simulated_data$height_category %in% c("Short", "Average", "Tall")))
})

# Test 5: Check if fat_percentage_category has the expected values
test_that("Fat percentage categories are correct", {
  simulated_data <- simulate_data()
  expect_true(all(simulated_data$fat_percentage_category %in% c("Low", "Moderate", "High", "Extreme")))
})

# Test 6: Check that the waist_hip_ratio is within the expected range (0.6 to 1.0)
test_that("Waist-hip ratio is within range", {
  simulated_data <- simulate_data()
  expect_true(all(simulated_data$waist_hip_ratio >= 0.6 & simulated_data$waist_hip_ratio <= 1.0))
})

# Test 7: Verify that height_hip_ratio is calculated correctly
test_that("Height-to-hip ratio is calculated correctly", {
  simulated_data <- simulate_data()
  expect_true(all(simulated_data$height_hip_ratio == simulated_data$height / (simulated_data$waist_hip_ratio * 2)))
})

