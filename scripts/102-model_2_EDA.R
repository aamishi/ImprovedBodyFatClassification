# Work space setup
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)


body_mass_data_eda <- read_parquet("data/analysis_data/body_mass_data.parquet")
body_mass_data_eda <- body_mass_data_eda %>%
  select(-bone_mass_kg) %>%
  filter(gender==2)
head(body_mass_data_eda)

ggplot(body_mass_data_eda, aes(x = weight, y = height, color = fat_percentage_category)) +
  geom_point(size = 3) +
  labs(
    title = "Fat Percentage Category vs Height and Weight",
    x = "Height (cm)",
    y = "Weight (kg)",
    color = "Fat Percentage Category"
  ) +
  theme_minimal()

body_mass_data_eda$height_category <- cut(body_mass_data_eda$height, breaks = c(0, 160, 170, 190, 250), 
                          labels = c("Short", "Medium", "Tall", "Very Tall"))

# Create a bar plot of fat_percentage_category against height_category
ggplot(body_mass_data_eda, aes(x = height_category, fill = fat_percentage_category)) +
  geom_bar(position = "fill") +
  labs(
    title = "Fat Percentage Category vs Height Category",
    x = "Height Category",
    y = "Proportion",
    fill = "Fat Percentage Category"
  ) +
  theme_minimal() +
  facet_wrap(~gender)

# Create weight categories (for example: Low, Medium, High)
body_mass_data_eda$weight_category <- cut(body_mass_data_eda$weight, breaks = c(0, 50, 70, 90, 150), 
                          labels = c("Light", "Medium", "Heavy", "Very Heavy"))

# Create a bar plot of fat_percentage_category against weight_category
ggplot(body_mass_data_eda, aes(x = weight_category, fill = bmi_category)) +
  geom_bar(position = "fill") +
  labs(
    title = "Fat Percentage Category vs Weight Category",
    x = "Weight Category",
    y = "Proportion",
    fill = "Fat Percentage Category"
  ) +
  theme_minimal() +
  facet_wrap(~gender)

body_mass_data_eda$age_group <- cut(body_mass_data_eda$age, 
                    breaks = c(0, 25, 35, 45, 60, Inf), 
                    labels = c("18-25", "26-35", "36-45", "46-60", "60+"))

# Categorize BMI (e.g., underweight, normal, overweight, obese)
body_mass_data_eda$bmi_category <- cut(body_mass_data_eda$bmi, breaks = c(0, 18.5, 24.9, 29.9, Inf), 
                       labels = c("Underweight", "Normal", "Overweight", "Obese"))

# Categorize fat percentage (example thresholds: under 15% is lean, 15%-25% is average, 25%-35% is overweight, and above 35% is obese)
body_mass_data_eda$fat_percentage_category <- cut(body_mass_data_eda$fm, breaks = c(0, 15, 25, 35, Inf), 
                                  labels = c("Lean", "Average", "Overweight", "Obese"))

ggplot(body_mass_data_eda, aes(x = height_category)) +
  geom_bar(aes(fill = bmi_category), position = "fill") +
  facet_wrap(~ fat_percentage_category, scales = "free_y") +
  labs(
    title = "BMI and Fat Percentage Categories by Height Category",
    x = "Height Category",
    y = "Count",
    fill = "BMI Category"
  ) +
  theme_minimal() 

ggplot(body_mass_data_eda, aes(x = height_category)) +
  geom_bar(aes(fill = fat_percentage_category), position = "fill") +
  facet_wrap(~ bmi_category, scales = "free_y") +
  labs(
    title = "BMI and Fat Percentage Categories by Height Category",
    x = "Height Category",
    y = "Count",
    fill = "BMI Category"
  ) +
  theme_minimal() 
