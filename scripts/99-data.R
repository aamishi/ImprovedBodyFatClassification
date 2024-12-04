#### Preamble ####
# Purpose: EDA
# Author: Aamishi Avarsekar
# Date: 3rd December 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Note: this code may not work and is simply my eda work

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)
#### Read data ####
analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")

#### Commuicate a good sense of the data:
# My idea:
# 1. show the difference in gender and the bmi levels
# 2. the ratios between waist-hip and bmi levels
# 3. how wrist and ankle measurements could reflect ...
# and the exclusively compare this to the MM-FM-FFM data

# 1. general table
kable(analysis_data, caption = "Table: Sample Measurements of Subjects")

# 2. bmi vs gender
# Create BMI bins with intervals of 5
bmi_interval <- 5
analysis_data <- analysis_data %>%
  mutate(bmi_bin = cut(original_bmi, breaks = seq(0, 50, by = bmi_interval), right = FALSE, 
                       labels = paste(seq(0, 45, by = bmi_interval), seq(5, 50, by = bmi_interval), sep = "-")))

ggplot(analysis_data, aes(x = bmi_bin, fill = factor(gender))) +
  geom_bar(position = "dodge", color = "black") +
  labs(title = "BMI Distribution by Gender", x = "BMI Range", y = "Count") +
  theme_minimal() +
  scale_fill_manual(values = c("0" = "blue", "1" = "pink"))

analysis_data %>%
  group_by(bmi_bin, gender) %>%
  summarise(count = n()) %>%
  group_by(bmi_bin) %>%
  mutate(prop = count / sum(count)) %>%
  ggplot(aes(x = bmi_bin, y = prop, fill = factor(gender))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Proportion of Gender within BMI Range", x = "BMI Range", y = "Proportion") +
  scale_fill_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal()


ggplot(analysis_data, aes(x = factor(gender), y = original_bmi)) +
  geom_boxplot(aes(fill = factor(gender)), color = "black") +
  labs(title = "BMI Distribution by Gender", x = "Gender", y = "BMI") +
  scale_x_discrete(labels = c("0" = "Male", "1" = "Female")) +
  scale_fill_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal()

ggplot(analysis_data, aes(x = factor(gender), y = original_bmi)) +
  geom_violin(aes(fill = factor(gender)), color = "black") +
  labs(title = "BMI Distribution by Gender", x = "Gender", y = "BMI") +
  scale_x_discrete(labels = c("0" = "Male", "1" = "Female")) +
  scale_fill_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal()

ggplot(analysis_data, aes(x = original_bmi, fill = factor(gender))) +
  geom_density(alpha = 0.5) +
  labs(title = "BMI Density by Gender", x = "BMI", y = "Density") +
  scale_fill_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal()

mean_bmi <- analysis_data %>%
  group_by(gender) %>%
  summarise(mean_bmi = mean(original_bmi, na.rm = TRUE))

# Create the density plot with mean lines
ggplot(analysis_data, aes(x = original_bmi, fill = factor(gender))) +
  geom_density(alpha = 0.5) +
  geom_vline(data = mean_bmi, aes(xintercept = mean_bmi, color = factor(gender)),
             linetype = "dashed", size = 1) +
  labs(title = "BMI Density by Gender with Mean Lines", x = "BMI", y = "Density") +
  scale_fill_manual(values = c("0" = "blue", "1" = "pink")) +
  scale_color_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(analysis_data, aes(x = original_bmi)) +
  geom_histogram(binwidth = 2, fill = "skyblue", color = "black") +
  labs(title = "BMI Distribution by Gender", x = "BMI", y = "Count") +
  facet_wrap(~ factor(gender), scales = "free", labeller = as_labeller(c("0" = "Male", "1" = "Female"))) +
  theme_minimal()



########################################
# 2. hip-waist vs bmi
########################################
ggplot(analysis_data, aes(x = original_bmi, y = waist_hip_ratio)) +
  geom_point(aes(color = factor(gender)), alpha = 0.7) +
  labs(title = "Waist-Hip Ratio vs. BMI", x = "BMI", y = "Waist-Hip Ratio") +
  scale_color_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal() +
  theme(legend.title = element_blank())


ggplot(analysis_data, aes(x = original_bmi, y = waist_hip_ratio)) +
  geom_point(aes(color = factor(gender)), alpha = 0.7) +
  geom_smooth(method = "lm", aes(color = factor(gender)), se = FALSE, linetype = "dashed") +
  labs(title = "Waist-Hip Ratio vs. BMI with Regression Lines", x = "BMI", y = "Waist-Hip Ratio") +
  scale_color_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal() +
  theme(legend.title = element_blank())


ggplot(analysis_data, aes(x = original_bmi, y = waist_hip_ratio)) +
  geom_point(aes(color = factor(gender)), alpha = 0.7) +
  facet_wrap(~ gender) +
  labs(title = "Waist-Hip Ratio vs. BMI by Gender", x = "BMI", y = "Waist-Hip Ratio") +
  scale_color_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal() +
  theme(legend.title = element_blank())

ggplot(analysis_data, aes(x = original_bmi, y = waist_hip_ratio)) +
  geom_point(aes(color = factor(gender), size = weight_kg), alpha = 0.7) +
  labs(title = "Waist-Hip Ratio vs. BMI with Body Weight", x = "BMI", y = "Waist-Hip Ratio") +
  scale_color_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal() +
  theme(legend.title = element_blank()) +
  scale_size_continuous(name = "Body Weight", range = c(2, 6))  # Adjust the range for size

ggplot(analysis_data, aes(x = original_bmi, y = waist_hip_ratio)) +
  geom_point(aes(color = weight_kg), alpha = 0.7) +
  facet_wrap(~ gender) +  # Facet by gender
  labs(title = "Waist-Hip Ratio vs. BMI by Gender", x = "BMI", y = "Waist-Hip Ratio") +
  scale_color_gradient(low = "blue", high = "red") +
  theme_minimal()

###### Body Weight vs. Waist-Hip Ratio
ggplot(analysis_data, aes(x = weight_kg, y = waist_hip_ratio)) +
  geom_point(aes(color = factor(gender)), alpha = 0.7) +
  labs(title = "Body Weight vs. Waist-Hip Ratio", x = "Body Weight", y = "Waist-Hip Ratio") +
  scale_color_manual(values = c("0" = "blue", "1" = "pink")) +
  theme_minimal() +
  theme(legend.title = element_blank())

ggplot(analysis_data, aes(x = original_bmi, y = waist_hip_ratio)) +
  geom_point(aes(color = weight_kg), alpha = 0.7) +
  geom_smooth(method = "lm", aes(color = weight_kg), se = FALSE, linetype = "dashed") +
  labs(title = "Waist-Hip Ratio vs. BMI (Higher Waist-Hip Ratio, Higher Body Fat)", 
       x = "BMI", 
       y = "Waist-Hip Ratio") +
  scale_color_gradient(low = "blue", high = "red") +
  theme_minimal() +
  theme(legend.title = element_blank())


ggplot(analysis_data, aes(x = waist_hip_ratio, fill = factor(gender))) +
  geom_density(alpha = 0.5) +
  labs(title = "Waist-Hip Ratio as a Better Indicator of Body Fat", 
       x = "Waist-Hip Ratio", 
       y = "Density") +
  theme_minimal()

# Categorize BMI into intervals
analysis_data$bmi_category <- cut(analysis_data$original_bmi, 
                                  breaks = c(0, 18.5, 24.9, 29.9, 40), 
                                  labels = c("Underweight", "Normal", "Overweight", "Obese"))

# Boxplot comparing waist-hip ratio across different BMI intervals
ggplot(analysis_data, aes(x = bmi_category, y = waist_hip_ratio, fill = bmi_category)) +
  geom_boxplot() +
  labs(title = "Waist-Hip Ratio Across Different BMI Intervals", 
       x = "BMI Category", 
       y = "Waist-Hip Ratio") +
  scale_fill_manual(values = c("Underweight" = "blue", 
                               "Normal" = "green", 
                               "Overweight" = "orange", 
                               "Obese" = "red")) +
  theme_minimal()


ggplot(analysis_data, aes(x = original_bmi, y = waist_hip_ratio)) +
  geom_point(aes(color = body_fat_percentage), alpha = 0.7) +
  geom_smooth(method = "lm", aes(color = body_fat_percentage), se = FALSE, linetype = "dashed") +
  labs(title = "BMI vs. Waist-Hip Ratio for High BMI Individuals", 
       x = "BMI", 
       y = "Waist-Hip Ratio") +
  scale_color_gradient(low = "blue", high = "red") +
  theme_minimal()


# Create a new variable to classify as "Lean" or "Fat" based on waist-hip ratio
analysis_data$group <- ifelse(analysis_data$waist_hip_ratio > 0.90, "Fat", "Lean")

# Alternatively, adjust the threshold for women and men separately if needed
# analysis_data$group <- ifelse(analysis_data$gender == 1 & analysis_data$waist_hip_ratio > 0.85, "Fat", "Lean")
# analysis_data$group <- ifelse(analysis_data$gender == 0 & analysis_data$waist_hip_ratio > 0.90, "Fat", "Lean")
ggplot(analysis_data, aes(x = original_bmi, y = waist_hip_ratio, color = group)) +
  geom_point(alpha = 0.7) +
  labs(title = "BMI vs. Waist-Hip Ratio: Lean vs. Fat Individuals", 
       x = "BMI", 
       y = "Waist-Hip Ratio") +
  scale_color_manual(values = c("Lean" = "blue", "Fat" = "red")) +
  theme_minimal()



