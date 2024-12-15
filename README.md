# Classification of Body Fat based on WHR and Body Composition

## Overview

This paper focuses on what BMI values fail to acknowledge the different body composition across both sexes. Using the Waist-Hip-Ratio is more accurate at estimating body fat levels using simple methods at home. This paper compares how this model performs against actual body composition such as isolated fat mass. Using this method makes self-identification of obsesity more accessible and preventive measures can be taken earlier.

## Data
To access the data used in this paper, follow the following steps:

### BodyM Data (Measurements data) Via AWS:

1. Navigate to this repo on your terminal and run the following command.
`aws s3 cp --no-sign-request s3://amazon-bodym/train/ ./data/raw_data/local-train --recursive`

### Body Composition Data

1. The Research Paper for which this data was collected has made the data available for download here:
`https://figshare.com/articles/dataset/DATASET_FOR_NEW_BODY_FAT_MEASUREMENT/12982223/2`
2. Once you download and extract the contents of the `.zip` file, cut and paste the file `DATASET FOR NEW BODY FAT MEASUREMENT.csv` (including spaces) into the data/raw_data folder

Once you have both data sets downloaded, you can proceed with the scripts! I hope you enjoy this paper!


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from BodyM and downloaded from Isaaz Kuzmar.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Several aspects of this paper were completed using the help of ChatGPT 4.0 and 4.0 Mini. Most notably, it was used to create tests, visualizations, and .bib references and understand statistics concepts. The conversations between ChatGPT are shared in the usage/ folder.