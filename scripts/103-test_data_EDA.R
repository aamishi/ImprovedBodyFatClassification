#### Preamble ####
# Purpose: EDA
# Author: Aamishi Avarsekar
# Date: 3rd December 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Note: this code may not work and is simply my eda work


# Work space setup
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)
install.packages("caret")

library(caret)
combined_data <- bind_rows(measurements_results, body_composition_results)
normalized_data <- combined_data %>%
  group_by(source, fat_percentage_category, predicted_category) %>%
  tally() %>%
  mutate(norm_count = n / sum(n)) # Normalizing counts by category total

ggplot(normalized_data, aes(x = fat_percentage_category, y = norm_count, fill = predicted_category)) +
  geom_bar(stat = "identity", position = "dodge") +
  # facet_wrap(~source) +
  theme_minimal() +
  labs(title = "Normalized Comparison of Model Predictions", x = "Fat Percentage Category", y = "Normalized Count") +
  scale_y_continuous(labels = scales::percent)

accuracy_data <- combined_data %>%
  group_by(source, fat_percentage_category) %>%
  summarize(correct_preds = sum(predicted_category == fat_percentage_category) / n())

# Plot normalized accuracy for each category
ggplot(accuracy_data, aes(x = fat_percentage_category, y = correct_preds, fill = source)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Normalized Accuracy by Category", x = "Fat Percentage Category", y = "Accuracy") +
  scale_y_continuous(labels = scales::percent)

##
stacked_data <- combined_data %>%
  group_by(source, fat_percentage_category, predicted_category) %>%
  tally() %>%
  mutate(norm_count = n / sum(n))  # Normalize by total count in each actual category

# Create stacked bar plot
ggplot(stacked_data, aes(x = fat_percentage_category, y = norm_count, fill = predicted_category)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~source) +
  theme_minimal() +
  labs(title = "Normalized Stacked Bar Plot by Model", x = "Fat Percentage Category", y = "Normalized Proportion") +
  scale_y_continuous(labels = scales::percent)

