#### Preamble ####
# Purpose: Simulates Marriage Licence data
# Author: Aamishi Avarsekar
# Date: 19th September 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT

### Install packages
install.packages("tidyverse")

#### Workspace setup ####
library(tidyverse)


#### Simulate data ####
set.seed(213)

# Define the start and end date
start_date <- as.Date("2023-06-01")
end_date <- as.Date("2023-12-31")

# Set the number of random dates you want to generate
number_of_dates <- 200

#### Simulate data ####
sample_marriage_data <-
  tibble(
    dates = as.Date(
      runif(
        n = number_of_dates,
        min = as.numeric(start_date),
        max = as.numeric(end_date)
      ),
      origin = "1970-01-01"
    ),
    number_of_marriage = rpois(n = number_of_dates, lambda = 15)
  )





