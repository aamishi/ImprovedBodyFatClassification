#### Preamble ####
# Purpose: Downloads and saves the data from OpenDataToronto
# Author: Aamishi Avarsekar
# Date: 19th September 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(arrow)
# [...UPDATE THIS...]

#### Download data ####
# get package ; DATASET FOR NEW BODY FAT MEASUREMENT
#### Clean data ####
measurements_data <- read_csv("./data/raw_data/local-train/measurements.csv")
measurements_subject_data <- read_csv("./data/raw_data/local-train/hwg_metadata.csv")

measurements_data_A <- read_csv("./data/raw_data/local-testA/measurements.csv")
measurements_subject_data_A <- read_csv("./data/raw_data/local-testA/hwg_metadata.csv")
body_mass_data <- read_csv2("./data/raw_data/DATASET FOR NEW BODY FAT MEASUREMENT.csv")

#### Save data ####
write_parquet(measurements_data, "data/raw_data/measurements_data.parquet")
write_parquet(measurements_subject_data, "data/raw_data/measurements_subject_data.parquet")

write_parquet(measurements_data_A, "data/raw_data/measurements_data_A.parquet")
write_parquet(measurements_subject_data_A, "data/raw_data/measurements_subject_data_A.parquet")
write_parquet(body_mass_data, "data/raw_data/body_mass_data.parquet")
         
