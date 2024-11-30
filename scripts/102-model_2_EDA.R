# Work space setup
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)


# Data Section: Part 1: What is the difference between an underweight / athletic person / normal person:
bmi_under_25 <- body_mass_clean %>%
  filter(bmi < 25)

# this is what i chose
ggplot(bmi_under_25, aes(x = , y = fm)) +
  geom_point(aes(color = bmi_category), alpha = 0.7) 
labs(
  title = "BMI vs. Fat Mass by BMI Category",
  x = "BMI",
  y = "Fat Mass (kg)",
  color = "BMI Category"
) +
  theme_minimal()


# Data Section: Part 2: What is the difference between an athletic person / normal person / overweight person:
bmi_normal_over <- body_mass_clean %>%
  filter(18.5 < bmi & bmi < 30)

# this is what i chose
ggplot(bmi_normal_over, aes(x = bmi, y = fm)) +
  geom_point(aes(color = bmi_category), alpha = 0.7) +
  facet_wrap(~ bmi_category) +
  labs(
    title = "BMI vs. Fat Mass by BMI Category",
    x = "BMI",
    y = "Fat Mass (kg)",
    color = "BMI Category"
  ) +
  theme_minimal()


# all categories
bmi_normal_over <- body_mass_clean %>%
  filter(18.5 < bmi & bmi < 30)

# this is what i chose
ggplot(body_mass_clean, aes(x = bmi, y = fm)) +
  geom_point(aes(color = bmi_category), alpha = 0.7) +
  labs(
    title = "BMI vs. Fat Mass by BMI Category",
    x = "BMI",
    y = "Fat Mass (kg)",
    color = "BMI Category"
  ) +
  theme_minimal()


#### FAT MASS VISUALS
# all categories
# i like
# could add - mean vlines for each category
ggplot(body_mass_clean, aes(x = fat_mass_kg, color = bmi_category, fill = bmi_category)) +
  geom_density(alpha = 0.3) + 
  facet_wrap(~ gender) +
  labs(
    title = "Overlapping Density Plot for Fat Mass by BMI Category",
    x = "Fat Mass (kg)",
    y = "Density",
    color = "BMI Category",
    fill = "BMI Category"
  ) +
  theme_minimal()

# i like this
ggplot(body_mass_clean, aes(x = fat_mass_kg, y = weight)) +
  geom_point(aes(color = bmi_category), alpha = 0.7) +
  geom_density2d(aes(color = bmi_category)) +
  labs(
    title = "Scatterplot with 2D Density Contours",
    x = "Fat Mass (kg)",
    y = "Weight (kg)",
    color = "BMI Category"
  ) +
  theme_minimal()