# Work space setup
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)

eda_measurements <- read_parquet("data/analysis_data/measurements_analysis_data.parquet")
eda_measurements$height_category <- cut(eda_measurements$height, breaks = c(0, 160, 170, 190, 250), 
                                          labels = c("Short", "Medium", "Tall", "Very Tall"))

ggplot(eda_measurements, aes(x = height, y = waist_hip_ratio)) +
  geom_point(color = 'blue', size = 2) +
  labs(
    title = "Waist-to-Hip Ratio vs Height",
    x = "Height (cm)",
    y = "Waist-to-Hip Ratio"
  ) +
  theme_minimal()

ggplot(eda_measurements, aes(x = bmi, y = waist_hip_ratio)) +
  geom_point(color = 'red', size = 2) +
  labs(
    title = "Waist-to-Hip Ratio vs Weight",
    x = "Weight (kg)",
    y = "Waist-to-Hip Ratio"
  ) +
  theme_minimal()

mean_value <- mean(eda_measurements$waist_hip_ratio, na.rm = TRUE)
median_value <- median(eda_measurements$waist_hip_ratio, na.rm = TRUE)

ggplot(eda_measurements, aes(x = weight, y = waist_hip_ratio)) +
  geom_point(size = 2) +
  facet_wrap(~ height_category) +  # Facet by age group
  labs(
    title = "Waist-to-Hip Ratio vs Height by Age Group",
    x = "Height (cm)",
    y = "Waist-to-Hip Ratio",
    color = "Age Group"
  ) +
  theme_minimal()

ggplot(eda_measurements, aes(x = waist_hip_ratio)) +
  geom_histogram(binwidth = 0.05, fill = "lightblue", color = "black", alpha = 0.7) +
  geom_vline(aes(xintercept = mean_value), color = "red", linetype = "dashed", size = 1) +
  geom_vline(aes(xintercept = median_value), color = "green", linetype = "dashed", size = 1) +
  labs(
    title = "Waist-to-Hip Ratio Distribution with Mean and Median",
    x = "Waist-to-Hip Ratio",
    y = "Frequency"
  ) +
  theme_minimal() + 
  facet_wrap(~ height_category)