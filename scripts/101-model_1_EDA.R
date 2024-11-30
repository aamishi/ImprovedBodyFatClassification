# Work space setup
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)
# before graphs []
ggplot(cleaned_data, aes(x = waist_hip_ratio, color = bmi_category, fill = bmi_category)) +
  geom_density(alpha = 0.3) + 
  facet_wrap(~ gender) +
  labs(
    title = "Overlapping Density Plot for Fat Mass by BMI OG",
    x = "waist_hip_ratio",
    y = "Density",
    color = "BMI Category",
    fill = "BMI Category"
  ) +
  theme_minimal()

# analysis_data
ggplot(cleaned_data, aes(x = waist_hip_ratio, color = predicted_category, fill = predicted_category)) +
  geom_density(alpha = 0.3) + 
  facet_wrap(~ gender) +
  labs(
    title = "Overlapping Density Plot for Fat Mass by predicted_category Category 4",
    x = "waist_hip_ratio",
    y = "Density",
    color = "BMI Category",
    fill = "BMI Category"
  ) +
  theme_minimal()

library(ggplot2)

ggplot(cleaned_data, aes(x = bmi, fill = interaction(bmi_category, predicted_category))) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Comparison of Original and Improved BMI Distributions", 
       x = "BMI Value", 
       y = "Density") 

df_long <- cleaned_data %>%
  pivot_longer(cols = c(bmi_category, predicted_category), 
               names_to = "category_type", 
               values_to = "category")

# Now you can plot the densities
ggplot(df_long, aes(x = bmi, fill = category_type)) + 
  geom_density(alpha = 0.5) + 
  facet_wrap(~ category, scales = "free") + 
  labs(title = "Distribution of Original vs Improved BMI by Category", 
       x = "BMI Value", 
       y = "Density") +
  scale_fill_manual(values = c("blue", "green")) 

ggplot(df_long, aes(x = weight_kg, y = height_cm)) +
  geom_point(aes(color = category), alpha = 0.7) +
  labs(
    title = "Scatterplot with 2D Density Contours",
    x = "Fat Mass (kg)",
    y = "Weight (kg)",
    color = "BMI Category"
  ) +
  theme_minimal()

ggplot(df_long, aes(x = original_bmi, fill = category_type)) + 
  geom_density(alpha = 0.5, aes(y = ..density..)) +  # Ensuring density normalization
  facet_wrap(~ category, scales = "free") + 
  labs(title = "Distribution of Original vs Improved BMI by Category", 
       x = "BMI Value", 
       y = "Density") +
  scale_fill_manual(values = c("blue", "green"))



library(ggridges)
ggplot(cleaned_data, aes(x = waist_hip_ratio, y = bmi_category, fill = bmi_category)) +
  geom_density_ridges(alpha = 0.6) +
  labs(title = "Ridgeline Plot of Fat Mass by BMI Category")