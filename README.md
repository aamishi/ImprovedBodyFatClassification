# Classification of Body Fat based on WHR and Body Composition

## Overview

This paper focuses on what BMI values fail to acknowledge the different body composition across both sexes. Using the Waist-Hip-Ratio is more accurate at estimating body fat levels using simple methods at home. This paper compares how this model performs against actual body composition such as isolated fat mass. Using this method makes self-identification of obsesity more accessible and preventive measures can be taken earlier.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from BodyM and downloaded from Isaaz Kuzmar.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Several aspects of this paper were completed using the help of ChatGPT 4.0 and 4.0 Mini. Most notably, it was used to create tests and visualizations and understand statistics concepts. The conversations between ChatGPT are shared in the usage/ folder.
## Some checks

- [ ] Change the rproj file name so that it's not starter_folder.Rproj
- [ ] Remove this checklist