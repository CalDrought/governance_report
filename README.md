# Gap Analysis of Datasets and Usability of Urban Drought Water Data
#### This repository was created for the Data for Drought Resilience capstone project 

**Authors include:** Tom Gibbens-Matsuyama, Emma Bea Mitchell, Karol Paya, Takeen Shamloo

**Advisor:** Dr. Naomi Tague

**Client:** California Water Data Consortium

## Description:

This gap analysis was created to analyze the gaps in usability of the urban drought water data currently located on the [CNRA website](https://data.cnra.ca.gov/dataset/urban-water-data-drought). Water managers and other stakeholders may want access to reported data from water agencies around California. The open source portal on the CNRA website gives them an opportunity to access previously unaccessible data. In order to make the portal and the data even more usable for stakeholders, and to be upfront and honest about limitations in the data, this gap analysis provides a detailed walkthrough of issues in and outside of the data, providing coding solutions and checks when necessary. This is intended for internal use by the California Water Data Consortium and others in charge of portal maintenance, as well as stakeholders who are interested in a more detailed look at data limitations. 

## Files in this Repository:

The data folder contains the data used consistently throughout the organization. This includes the five year water shortage outlook, monthly water shortage outlook, historical production and delivery, and actual water shortage levels csv files. All of this data is untouched from the original which is housed on the [CNRA website](https://data.cnra.ca.gov/dataset/urban-water-data-drought). 

The Gap Analysis Quarto document contains code and markdown about issues with the existing data (refering to the data found in the data folder). The document is split into different sections, with each dataset having a section as well as a section for overlapping problems across datasets. This quarto document is meant to be read to get a better idea of limitations in the data and possible future improvements.

The data check R script contains code that will allow staff maintaining the data to check if future additions to the data have the same problems that is seen in the current data (as of May 2025). This script will be able to be run against a csv file, and will flag the user to any issues within the data.

The Desired Gap Analysis Quarto document contains markdown describing questions that water managers may have about water use or drought (that cannot be answered by the current data) and will suggest additional data that could be added to the portal to answer these questions and better meet user demand. This document is intended for staff maintaining and adding to the portal and data to get a clear idea of what data is necessary to add in addition to what is already there. 

### Final Repository File Structure
```r
├── data/
│   ├── five_year_water_shortage_outlook.csv
│   ├── monthly_water_shortage_outlook.csv
│   ├── historical_production_and_delivery.csv
│   ├── actual_water_shortage_levels.csv
├── gap_analysis.qmd
├── data_check.R
├── desired_data_gap_analysis.qmd
└── README.md
```


