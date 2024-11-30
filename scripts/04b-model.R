#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
### Model data ####
library(nnet)

#### Read data ####
body_mass_read <- read_parquet("data/analysis_data/body_mass_data.parquet")
body_mass_model <- multinom(fm ~ bmi_category , data = body_mass_read)

library(randomForest)
body_mass_model <- randomForest(fm ~ weight  + bmi_category, data = body_mass_read)

body_mass_model_bmi <- multinom(bmi_category ~ weight + fm , data = body_mass_read)



#### Save model ####
saveRDS(
  body_mass_model,
  file = "models/body_mass_model.rds"
)

saveRDS(
  body_mass_model_bmi,
  file = "models/body_mass_model_bmi.rds"
)


