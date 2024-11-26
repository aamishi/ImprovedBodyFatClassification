#### Preamble ####
# Purpose: Downloads and saves the data from OpenDataToronto
# Author: Aamishi Avarsekar
# Date: 19th September 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
# [...UPDATE THIS...]

#### Download data ####
# get package ; DATASET FOR NEW BODY FAT MEASUREMENT
#### Clean data ####
measurements_data <- read_csv("./data/raw_data/local-train/measurements.csv")
subject_sex_data <- read_csv("./data/raw_data/local-train/hwg_metadata.csv")

#### Save data ####
write_parquet(measurements_data, "data/raw_data/measurements_data.parquet")
write_parquet(subject_sex_data, "data/raw_data/subject_sex_data.parquet")
         
