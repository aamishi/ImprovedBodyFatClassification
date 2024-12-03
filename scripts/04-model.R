#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


# Works pace setup - packages needed
library(tidyverse)
library(rstanarm)
library(nnet)
library(randomForest)
library(tidyr)

#### Read data ####
cleaned_data_model <- read_parquet("data/analysis_data/measurements_analysis_data.parquet")
body_mass_model <- read_parquet("data/analysis_data/body_mass_data.parquet")

# Multinomial logistic regression model
# subject_id, gender, height_cm, weight_kg, height, ankle, wrist, waist_hip_ratio, original_bmi
# Variables selected:
measurements_model <- multinom(fat_percentage_category ~ height + gender + waist_hip_ratio + height_hip_ratio, data = cleaned_data_model)
# Summary of the model
summary(measurements_model)

cleaned_data_model$predicted_category <- predict(measurements_model, newdata = cleaned_data_model)



#### Read data ####
# body_mass_model <- multinom(fm ~ bmi_category , data = body_mass_read)
body_mass_model_bmi <- multinom(fat_percentage_category ~ height + gender + fm, data = body_mass_model)
summary(body_mass_model_bmi)
body_mass_model$predicted_category <- predict(body_mass_model_bmi, newdata = body_mass_model)


# body_mass_model <- randomForest(fm ~ height + weight + gender * predicted_category + muscle_mass_kg, data = body_mass_read)

##### FOR THE MODEL's RESULTS SECTION:
measurements_results <- cleaned_data_model %>%
  select(gender, height, weight, height_category, fat_percentage_category, predicted_category) %>%
  mutate(source = "measurements")

body_composition_results <- body_mass_model %>%
  select(gender, height, weight, height_category, fat_percentage_category, predicted_category) %>%
  mutate(source = "body_composition")

elongated_data <- bind_rows(measurements_results, body_composition_results)

# View the resulting data
head(elongated_data)

ggplot(elongated_data, aes(x = fat_percentage_category, fill = source)) +
  geom_bar(position = "fill") +  # Normalize counts to proportions
  labs(title = "Normalized Bar Plot of Fat Percentage Category vs Predicted Category (Source Highlighted)",
       x = "Fat Percentage Category",
       y = "Proportion",  # Update y-axis label to reflect proportions
       fill = "Source") +
  facet_wrap(~ height_category) +  # Facet by gender
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for readability

ggplot(elongated_data, aes(x = predicted_category, fill = source)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~ predicted_category) +
  labs(title = "Density Plot of Predicted Categories by Source",
       x = "Predicted Category",
       y = "Density",
       fill = "Source") +
  theme_minimal()

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




#### Save model ####
saveRDS(
  measurements_model,
  file = "models/measurements_model.rds"
)

saveRDS(
  body_mass_model_bmi,
  file = "models/body_mass_model_bmi.rds"
)


