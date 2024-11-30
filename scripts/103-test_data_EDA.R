# Work space setup
library(tidyverse)
library(janitor)
library(arrow)
library(dplyr)
install.packages("caret")

library(caret)







# Import data:
# Model 1 Data
measurements_data_predictions <- read_parquet("data/analysis_data/measurements_analysis_data.parquet")
# Model 2 Data
body_mass_data_predictions <- read_parquet("data/analysis_data/body_mass_data.parquet")

# Test Data: 
cleaned_test_data_predictions <- read_parquet("data/analysis_data/test_analysis.parquet")

# Model 1 predictions:
measurements_data_predictions$predicted_category <- predict(measurements_model, newdata = measurements_data_predictions)
#table(Predicted = TODO$predicted_category, Actual = cleaned_data$bmi_category)




# Model 2 predictions:
#table(Predicted = measurements_data_predictions$model_1_predicted_categories, Actual = measurements_data_predictions$bmi_category)
#table(Predicted = body_mass_data_predictions$model_2_predicted_categories, Actual = body_mass_data_predictions$bmi_category)
body_mass_data_predictions$predicted_category <- predict(body_mass_model, newdata = body_mass_data_predictions)

# Extract Categories:
measurements_data_extracted <- measurements_data_predictions %>%
  select(height, weight, bmi, bmi_category, predicted_category)

body_mass_data_extracted <- body_mass_data_predictions %>%
  select(height, weight, bmi, bmi_category, predicted_category)

# visual to see results of the models
# model 1:
model_1_long <- measurements_data_extracted %>%
  pivot_longer(cols = c(bmi_category, model_1_predicted_categories), 
               names_to = "category_type", 
               values_to = "category")

# Now you can plot the densities
ggplot(model_1_long, aes(x = bmi, fill = category_type)) + 
  geom_density(alpha = 0.5) + 
  facet_wrap(~ category, scales = "free") + 
  labs(title = "Distribution of Original vs Improved BMI by Category", 
       x = "BMI Value", 
       y = "Density") +
  scale_fill_manual(values = c("blue", "green")) 

# model 2
model_2_long <- body_mass_data_extracted %>%
  pivot_longer(cols = c(bmi_category, model_2_predicted_categories), 
               names_to = "category_type", 
               values_to = "category")

# Now you can plot the densities
ggplot(model_2_long, aes(x = bmi, fill = category_type)) + 
  geom_density(alpha = 0.5) + 
  facet_wrap(~ category, scales = "free") + 
  labs(title = "Distribution of Original vs Improved BMI by Category", 
       x = "BMI Value", 
       y = "Density") +
  scale_fill_manual(values = c("blue", "green")) 



##### TRYING SOMETHING NEW !!!
measurements_data_extracted$source = "1"
body_mass_data_extracted$source = "2"

df_combined <- rbind(measurements_data_extracted, body_mass_data_extracted)



# Convert BMI columns to factors to ensure they are treated as categorical
df_combined$bmi <- factor(df_combined$bmi_category, levels = c("Underweight", "Normal", "Overweight"))
df_combined$predicted_category <- factor(df_combined$predicted_category, levels = c("Underweight", "Normal", "Overweight"))

# Create the plot
ggplot(df_combined, aes(x = weight, y = height, shape = bmi_category, color = predicted_category)) +
  geom_point(size = 4) +  # Points for each (height, weight) pair
  scale_shape_manual(values = c("Underweight" = 16, "Normal" = 17, "Overweight" = 18)) +  # Different shapes for original BMI categories
  scale_color_manual(values = c("Underweight" = "blue", "Normal" = "green", "Overweight" = "red")) +  # Colors for predicted BMI categories
  labs(title = "Height vs Weight with Original and Predicted BMI Categories",
       x = "Weight (kg)", y = "Height (cm)", shape = "Original BMI", color = "Predicted BMI") +
  theme_minimal()

ggplot(df_combined, aes(x = weight, y = height, shape = bmi_category, color = predicted_category)) +
  geom_jitter(aes(size = 4), alpha = 0.6, width = 0.2, height = 0.2) +  # Jitter to avoid overlap and transparency
  scale_shape_manual(values = c("Underweight" = 16, "Normal" = 17, "Overweight" = 18)) +  # Different shapes for original BMI categories
  scale_color_manual(values = c("Underweight" = "blue", "Normal" = "green", "Overweight" = "red")) +  # Colors for predicted BMI categories
  facet_wrap(~source) +  # Facet by source dataframe to separate the data
  labs(title = "Height vs Weight with Original and Predicted BMI Categories",
       x = "Weight (kg)", y = "Height (cm)", shape = "Original BMI", color = "Predicted BMI") +
  theme_minimal()

ggplot(df_combined, aes(x = weight, y = height, shape = bmi_category, color = predicted_category)) +
  geom_jitter(aes(size = 4), alpha = 0.6, width = 0.2, height = 0.2) +  # Jitter to avoid overlap and transparency
  scale_shape_manual(values = c("Underweight" = 16, "Normal" = 17, "Overweight" = 18)) +  # Different shapes for original BMI categories
  scale_color_manual(values = c("Underweight" = "blue", "Normal" = "green", "Overweight" = "red")) +  # Colors for predicted BMI categories
  facet_wrap(~source) +  # Facet by original BMI category
  labs(title = "Height vs Weight with Original and Predicted BMI Categories",
       x = "Weight (kg)", y = "Height (cm)", shape = "Original BMI", color = "Predicted BMI") +
  theme_minimal()

ggplot(df_combined, aes(x = weight, y = height, shape = bmi_category, color = predicted_category)) +
  geom_jitter(aes(size = 4), alpha = 0.6, width = 0.2, height = 0.2) +  # Jitter to avoid overlap and transparency
  scale_shape_manual(values = c("Underweight" = 16, "Normal" = 17, "Overweight" = 18)) +  # Different shapes for original BMI categories
  scale_color_manual(values = c("Underweight" = "blue", "Normal" = "green", "Overweight" = "red")) +  # Colors for predicted BMI categories
  facet_wrap(~source) +  # Facet by source dataframe to separate the data
  labs(title = "Height vs Weight with Original and Predicted BMI Categories",
       x = "Weight (kg)", y = "Height (cm)", shape = "Original BMI", color = "Predicted BMI") +
  theme_minimal()



ggplot() + 
  geom_density(data = measurements_data_extracted, aes(x = predicted_category), fill = "blue", alpha = 0.5) + 
  geom_density(data = body_mass_data_extracted, aes(x = predicted_category), fill = "green", alpha = 0.5) +
  labs(title = "Density Comparison of Predicted Categories", x = "Predicted Category", y = "Density")



ggplot() + 
  geom_boxplot(data = measurements_data_extracted, aes(x = "Dataset 1", y = predicted_category), fill = "blue") +
  geom_boxplot(data = body_mass_data_extracted, aes(x = "Dataset 2", y = predicted_category), fill = "green") +
  labs(title = "Boxplot of Predicted Categories", x = "Dataset", y = "Predicted Category")



ggplot(df_long, aes(x = predicted_category, fill = category_type)) + 
  geom_density(alpha = 0.5) + 
  facet_wrap(~ original_category, scales = "free") +  # Facet wrap by original category
  labs(title = "Density Plot of Predicted Categories by Original Category", 
       x = "Predicted Category", 
       y = "Density") +
  scale_fill_manual(values = c("blue", "green"))


ggplot(df_combined, aes(x = predicted_category, fill = bmi_category)) + 
  geom_density(alpha = 0.5) + 
  facet_wrap(~ bmi_category, scales = "free") +  # Facet wrap by original_category
  labs(title = "Density Plot of Predicted Categories by Original Category", 
       x = "Predicted Category", 
       y = "Density") +
  scale_fill_manual(values = c("blue", "green", "yellow", "pink"))

ggplot(measurements_data_predictions, aes(x = bmi_category, fill = predicted_category)) + 
  geom_bar(position = "dodge") + 
  labs(title = "Proportional Distribution of Original BMI Categories", 
       x = "Original BMI Category", 
       y = "Proportion") +
  scale_fill_manual(values = c("blue", "green", "yellow", "pink"))


ggplot(body_mass_data_extracted, aes(x = bmi_category, fill = predicted_category)) + 
  geom_bar(position = "dodge") + 
  labs(title = "Proportional Distribution of Original BMI Categories", 
       x = "Original BMI Category", 
       y = "Proportion") +
  scale_fill_manual(values = c("blue", "green", "yellow", "pink"))

ggplot(df_combined, aes(x = bmi_category, fill = predicted_category)) + 
  geom_bar(position = "dodge") + 
  labs(title = "Proportional Distribution of Original BMI Categories", 
       x = "Original BMI Category", 
       y = "Proportion") +
  scale_fill_manual(values = c("blue", "green", "yellow", "pink"))


# HEAT MAP
library(dplyr)

# Create the contingency table
contingency_table <- body_mass_data_extracted %>%
  count(bmi_category, predicted_category)

# Convert to a data frame (if it's not already)
contingency_table <- as.data.frame(contingency_table)

library(ggplot2)

ggplot(contingency_table, aes(x = bmi_category, y = predicted_category, fill = n)) + 
  geom_tile() +
  labs(title = "Heatmap of BMI Category vs Predicted Category", 
       x = "BMI Category", 
       y = "Predicted Category", 
       fill = "Count") +
  scale_fill_gradient(low = "red", high = "blue") +  # Custom color scale
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

conf_matrix <- confusionMatrix(factor(measurements_data_extracted$predicted_category), 
                               factor(measurements_data_extracted$bmi_category))

# View the confusion matrix
print(conf_matrix)


########################################################


conf_matrix <- table(body_mass_read$bmi_category, body_mass_read$predicted_category)
print(conf_matrix)

library(ggplot2)

# Convert to data frame for plotting
conf_df <- as.data.frame(as.table(conf_matrix))

# Heatmap of Confusion Matrix
ggplot(conf_df, aes(x = Var1, y = Var2, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), color = "black", size = 5) +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(x = "Predicted Category", y = "Actual Category", title = "Confusion Matrix") +
  theme_minimal()

