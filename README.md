Data Engineering Individual Project
This is the individual project I submitted for the client that was brought to us for our data engineering course.

AIM
The aim was to collect data from the city council presented to us, clean the data, create the metadata, convert the data into SDMX format, and provide the data to the client.

Explanation
scrape\ prison\ statistics.py
The purpose of this Python script is to scrape data from the specified website. The scraping process is automated or scheduled to run quarterly as required to obtain the latest data. Once collected, the data is stored as an Excel file, and the filename is saved in a text file.

prisonstat.R
The purpose of this R script is to clean the acquired data. RStudio was chosen for its excellent data visualization and handling capabilities. All Not Available fields are set to zero during cleaning. The cleaned data is then converted to CSV files and saved.

prisonstatjson.py
This Python script creates an API for the data and metadata using Flask.

metaData.json
This file provides metadata about the tables, including their dimensions and respective observations.

filename.txt
This file lists the Python and R packages that need to be installed.

Download
This directory contains the downloaded quarterly statistics and the text file with the filename.

Cleaned
This directory contains all the cleaned CSV files obtained after running prisonstat.R.

Process
scrape\ prison\ statistics.py: This script scrapes the quarterly statistics from the website and saves the data in the Download folder. It also creates a text file named filename.txt containing the name of the downloaded file. This ensures smooth uploading of the quarterly statistics file during the cleaning phase in R.

prisonstat.R: This script cleans the data, making it presentable, and saves it as CSV files in the Cleaned directory.

dataFlask.py: This script runs the API, providing the required data and metadata in JSON format.

All files are deployed on an EC2 instance in AWS. The necessary packages are installed, and cron jobs are set to run the scripts every three months to fetch the latest quarterly statistics.

Cron Jobs
The following cron jobs are set up to run the scripts automatically:

0 0 1 */3 * /DATA472-PrisonStat/scrape\ prison\ statistics.py
2 0 1 */3 * /DATA472-PrisonStat/prisonstat.R
12:00 AM: scrape\ prison\ statistics.py runs to scrape the data.
12:02 AM: prisonstat.R runs to clean the data.
