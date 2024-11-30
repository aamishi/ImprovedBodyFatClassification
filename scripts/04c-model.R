plot(body_mass_read$fm, body_mass_read$predicted_fm,
     xlab = "Actual Fat Percentage",
     ylab = "Estimated Fat Percentage",
     main = "Estimated vs Actual Fat Percentage",
     pch = 16, col = "blue")
abline(a = 0, b = 1, col = "red", lty = 2) +
  facet_wrap(~ bmi_category + gender)



# fat mass predictor model
# ggplot(body_mass_read) +
#   geom_density(aes(x = fm, fill = "Actual"), alpha = 0.5) +
#   geom_density(aes(x = predicted_fm, fill = "Estimated"), alpha = 0.5) +
#   labs(x = "Fat Percentage", y = "Density",
#        title = "Distribution of Actual vs Estimated Fat Percentage") +
#   scale_fill_manual(values = c("Actual" = "blue", "Estimated" = "orange")) +
#   theme_minimal() +
#   facet_wrap(~ bmi_category)

# ggplot(body_mass_read) +
#   geom_histogram(aes(x = fm, fill = "Actual"), alpha = 0.5, position = "identity", bins = 30) +
#   geom_histogram(aes(x = predicted_fm, fill = "Estimated"), alpha = 0.5, position = "identity", bins = 30) +
#   labs(x = "Fat Percentage", y = "Count",
#        title = "Distribution of Actual vs Estimated Fat Percentage") +
#   scale_fill_manual(values = c("Actual" = "blue", "Estimated" = "orange")) +
#   theme_minimal() +
#   facet_wrap(~ bmi_category)

# ggplot(body_mass_read) +
#   geom_violin(aes(x = bmi_category, y = fm, fill = "Actual"), alpha = 0.5) +
#   geom_violin(aes(x = bmi_category, y = predicted_fm, fill = "Estimated"), alpha = 0.5) +
#   labs(x = "BMI Category", y = "Fat Percentage",
#        title = "Violin Plot of Actual vs Estimated Fat Percentage") +
#   scale_fill_manual(values = c("Actual" = "blue", "Estimated" = "orange")) +
#   theme_minimal()

