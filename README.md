# Governance Report on California Urban Water Data
#### This repository was created for the Data for Drought Resilience capstone project 

**Authors include:** Tom Gibbens-Matsuyama, Emma Bea Mitchell, Karol Paya, Takeen Shamloo

**Advisor:** Dr. Naomi Tague

**Client:** California Water Data Consortium

## Description:
This governance report houses gap analyses on urban water data found on the [CNRA website](https://data.cnra.ca.gov/dataset/urban-water-data-drought), a user manual for database managers and staff managing the dashboard to refer to, and a report on training skills necessary for the upkeep of this data and dashboard.

This gap analysis was created to analyze the gaps in usability of the urban drought water data currently located on the [CNRA website](https://data.cnra.ca.gov/dataset/urban-water-data-drought). Water managers and other stakeholders may want access to reported data from water agencies around California. The open source portal on the CNRA website gives them an opportunity to access previously unaccessible data. In order to make the portal and the data even more usable for stakeholders, and to be upfront and honest about limitations in the data, this gap analysis provides a detailed walkthrough of issues in and outside of the data, providing coding solutions and checks when necessary. This is intended for internal use by the California Water Data Consortium and others in charge of portal maintenance, as well as stakeholders who are interested in a more detailed look at data limitations. 

The user manual was created to make the transfer of work from the capstone team to the California Water Data Consortium as smooth as possible. It describes in detail the code used to create the dashboard, and any other information relevant to understanding the code and documents throughout both the governance_report and dashboard repositories. 

The training skills document was created to ensure that staff working on this project in the future have the skills necessary to continue its maintanance/ build on this work in the future. It details R libraries and other skills used throughout this work, in order to ensure that staff have the ability to understand and use the project. 

## Files in this Repository:

The data folder contains the data used consistently throughout the organization. This includes the five year water shortage outlook, monthly water shortage outlook, historical production and delivery, and actual water shortage levels csv files. All of this data is untouched from the original which is housed on the [CNRA website](https://data.cnra.ca.gov/dataset/urban-water-data-drought). 

The Gap Analysis Quarto document contains code and markdown about issues with the existing data (refering to the data found in the data folder). The document is split into different sections, with each dataset having a section as well as a section for overlapping problems across datasets. This quarto document is meant to be read to get a better idea of limitations in the data and possible future improvements.

The data check R script contains code that will allow staff maintaining the data to check if future additions to the data have the same problems that is seen in the current data (as of May 2025). This script will be able to be run against a csv file, and will flag the user to any issues within the data.

The Desired Gap Analysis Quarto document contains markdown describing questions that water managers may have about water use or drought (that cannot be answered by the current data) and will suggest additional data that could be added to the portal to answer these questions and better meet user demand. This document is intended for staff maintaining and adding to the portal and data to get a clear idea of what data is necessary to add in addition to what is already there. 

The User Manual Quarto document contains markdown describing the code located in the dashboard in detail, and is broken down by section. Details might include functions created and used, organization and structure, and interactive elements. 

The Training Skills Quarto document contains an outline of skills necessary for this project, as well as governance and training recommendations for the future. 

### Final Repository File Structure
```r
├── data/
│   ├── five_year_water_shortage_outlook.csv
│   ├── monthly_water_shortage_outlook.csv
│   ├── historical_production_and_delivery.csv
│   ├── actual_water_shortage_levels.csv
|
├── test/testthat/
│   ├── five_year_data_check_script.R
│   ├── historical_data_check.R
│   ├── monthly_data_check.R
│   ├── actual_shortage_data_check.R
│   
├── gap_analysis.qmd
├── desired_data_gap_analysis.qmd
├── training_skills.qmd
├── user_manual.qmd
├── session_info.txt
└── README.md
```


