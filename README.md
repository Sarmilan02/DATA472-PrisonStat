Data Engineering Individual Project

Overview

This project was submitted as part of a data engineering course, involving a client-provided dataset from a city council. The goal was to collect, clean, and transform the data into SDMX format, and make it accessible via an API.

AIM

The aim was to:

Collect data from the city council.
Clean the data.
Create metadata.
Convert the data into SDMX format.
Provide the data to the client.
Components and Scripts
1. scrape_prison_statistics.py
Purpose: Scrapes data from a specified website.
Details:
The script runs quarterly to obtain the latest data.
The data is stored as an Excel file.
The filename is saved in a text file for reference.
2. prisonstat.R
Purpose: Cleans the acquired data using RStudio.
Details:
Not Available fields are set to zero.
The cleaned data is saved as CSV files.
3. prisonstatjson.py
Purpose: Creates an API using Flask to provide data and metadata.
Details:
The API serves both data and metadata in JSON format.
4. metaData.json
Purpose: Provides metadata about the data tables.
Details:
Includes information on dimensions and observations.
5. filename.txt
Purpose: Lists the Python and R packages needed.

Details:

Ensures all necessary packages are installed for the scripts to run.
Directory Structure
Download
Contains the downloaded quarterly statistics and the text file with the filename.

Cleaned

Contains all cleaned CSV files obtained after running prisonstat.R.

Process

Data Collection: scrape_prison_statistics.py

Scrapes quarterly statistics and saves the data in the Download folder.

Creates filename.txt with the downloaded file name.

Data Cleaning: prisonstat.R

Cleans and prepares the data, then saves it as CSV files in the Cleaned directory.

API Creation: prisonstatjson.py

Runs the API to provide data and metadata in JSON format.

Deployment

All scripts are deployed on an EC2 instance in AWS.

Necessary packages are installed.

Cron jobs are set up to run the scripts every three months to fetch the latest data.

Cron Jobs

**0 0 1 */3 ***: scrape_prison_statistics.py runs quarterly at midnight on the first day of the month.

**2 0 1 */3 ***: prisonstat.R runs quarterly at 12:02 AM on the first day of the month.

Example Cron Schedule:
12:00 AM: scrape_prison_statistics.py runs.

12:02 AM: prisonstat.R runs.

API Endpoints

Data: (http://3.107.58.175:5000/svi40/prisonstat)
Metadata: (http://3.107.58.175:5000/svi40/prisonstatmeta)

------------------------------------------------------------------------------------------------------------------------------------------------------
This README provides an overview and detailed explanation of the project's components, processes, and deployment setup. For further details, refer to the respective scripts and metadata files.
