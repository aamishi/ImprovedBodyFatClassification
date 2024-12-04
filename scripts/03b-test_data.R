#### Preamble ####
# Purpose: Tests Body Composition data
# Author: Aamishi Avarsekar
# Date: 3rd December 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# This was written by ChatGPT

# Load necessary libraries for testing
library(testthat)

body_mass_for_testing<- read_parquet("data/analysis_data/body_mass_data.parquet")

# 3. Test if age column is within the expected range (18 to 80 years)
test_that("Age column is within the expected range", {
  expect_true(all(body_mass_for_testing$age >= 18 & body_mass_for_testing$age <= 80))
})

# 4. Test if height column has values greater than zero
test_that("Height column has positive values", {
  expect_true(all(body_mass_for_testing$height > 0))
})

# 5. Test if weight column has values greater than zero
test_that("Weight column has positive values", {
  expect_true(all(body_mass_for_testing$weight > 0))
})

# 6. Test if fat_mass_kg column has non-negative values
test_that("Fat mass column has non-negative values", {
  expect_true(all(body_mass_for_testing$fat_mass_kg >= 0))
})

# 8. Test if fat percentage categories are valid
test_that("Fat percentage category column contains valid categories", {
  expect_true(all(body_mass_for_testing$fat_percentage_category %in% c("Low", "Moderate", "High", "Extreme")))
})

# 9. Test if bmi_category column contains valid categories
test_that("BMI category column contains valid categories", {
  expect_true(all(body_mass_for_testing$bmi_category %in% c("Underweight", "Moderate", "Overweight", "Obese")))
})

# 11. Test if predicted_category column contains valid categories
test_that("Predicted category column contains valid categories", {
  expect_true(all(body_mass_for_testing$predicted_category %in% c("Low", "Moderate", "High", "Extreme")))
})

# 12. Test if weight_category column contains valid categories
test_that("Weight category column contains valid categories", {
  expect_true(all(body_mass_for_testing$weight_category %in% c("Underweight", "Normal", "Overweight", "Obese")))
})

# 13. Test if there are no missing values in the data frame
test_that("No missing values in the data", {
  expect_true(all(!is.na(body_mass_for_testing)))
})

# 14. Test if body mass values are logically consistent (fat_mass_kg + ffm_kg should be close to weight)
test_that("Fat mass + Fat-free mass is close to weight", {
  expect_true(all(abs((body_mass_for_testing$fat_mass_kg + body_mass_for_testing$ffm_kg) - body_mass_for_testing$weight) < 10))
})

# 15. Test if fat mass percentage is within a reasonable range (0 to 100)
test_that("Fat mass percentage is within a reasonable range", {
  fat_percentage <- (body_mass_for_testing$fat_mass_kg / body_mass_for_testing$weight) * 100
  expect_true(all(fat_percentage >= 0 & fat_percentage <= 100))
})
