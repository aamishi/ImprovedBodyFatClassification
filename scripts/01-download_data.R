#### Preamble ####
# Purpose: Downloads and saves the data from OpenDataToronto
# Author: Aamishi Avarsekar
# Date: 19th September 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT


# Workspace setup
library(tidyverse)
library(arrow)

# Instructions for obtaining the data is included in the READ.ME
# Model 1 Data: AWS BodyM Training Data
measurements_data <- read_csv("./data/raw_data/local-train/measurements.csv")
measurements_subject_data <- read_csv("./data/raw_data/local-train/hwg_metadata.csv")

# Model 2 Data: Isaac Kuzmar Et Al Data - Body Composition Data
# Data uses ; as delimiter
body_mass_data <- read_csv2("./data/raw_data/DATASET FOR NEW BODY FAT MEASUREMENT.csv")


#### Save data ####
# Model 1
write_parquet(measurements_data, "data/raw_data/measurements_data.parquet")
write_parquet(measurements_subject_data, "data/raw_data/measurements_subject_data.parquet")

# Model 2
write_parquet(body_mass_data, "data/raw_data/body_mass_data.parquet")