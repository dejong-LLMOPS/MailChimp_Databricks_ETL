# MailChimp Databricks ETL

This repository contains a set of Databricks notebooks and supporting scripts for performing a complete ETL pipeline on MailChimp data. The pipeline is built on a multi-layer architecture (Bronze, Silver, and Gold) and leverages Azure Data Lake Storage (ADLS), Delta Lake, and Databricks. In addition to the ETL processing, there are visualization examples using Plotly to explore engagement metrics and monthly signups.

## Overview

- **Bronze Layer:**  
  - Fetches raw data from MailChimp via the Mailchimp Marketing API.  
  - Ingests JSON data from multiple MailChimp lists and stores it in the Bronze container on ADLS.
  - Implements cleanup routines to remove older ingestion folders.

- **Silver Layer:**  
  - Reads and cleans the raw JSON files from the Bronze layer.  
  - Flattens nested data (such as merge fields and location data) and writes cleaned CSV files to the Silver container.

- **Gold Layer:**  
  - Reads cleaned CSV files, converts them into Delta tables, and creates dimension and fact tables (e.g., `dim_contact`, `dim_list`, and `fact_list_membership`).
  - These Delta tables serve as the basis for analytical queries.

- **Visualization:**  
  - Example notebooks provide queries and interactive visualizations using Plotly.  
  - Visualizations include grouped bar charts for engagement metrics and line charts for monthly signups across top MailChimp lists.

## Prerequisites

- **Databricks Environment:**  
  This project is designed to run in Databricks notebooks.

- **Azure Data Lake Storage (ADLS):**  
  - Ensure that you have an ADLS account and appropriate containers created for Bronze, Silver, and Gold data.
  - Update the account names and container names in the code as needed.

- **MailChimp API Access:**  
  - A valid MailChimp API key is required.
  - The API key is accessed securely via `dbutils.secrets.get()`, so configure your Databricks secrets accordingly.

- **Python Libraries:**  
  - `mailchimp_marketing`
  - `azure-identity`
  - `azure-storage-file-datalake`
  - `pandas`
  - `pyspark`
  - `plotly`
  
  Make sure these are installed in your environment (you can list these in a `requirements.txt`).

## Setup & Configuration

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/dejong-LLMOPS/MailChimp_Databricks_ETL.git
Databricks Secrets:

Store your MailChimp API key in the Databricks secrets (e.g., using a scope named MailchimpSpnetwork).

ADLS Configuration:

Update the storage account names (mailchimpspnetwork), container names (bronze, silver, gold), and directory prefixes in the notebooks as needed.

The notebooks use DefaultAzureCredential for authentication, so ensure your environment supports it.

Dependencies:

If using a requirements file, install dependencies:

bash
Copy
pip install -r requirements.txt
Project Structure
ETL Notebooks:

mailchimp_bronze_etl.ipynb: Retrieves MailChimp lists and their members, stores raw JSON data to the Bronze layer.

Silver ETL Notebook: Reads JSON data from Bronze, cleans, and writes CSV files to the Silver layer.

Gold ETL / Delta Processing: Converts CSV files from Silver to Delta tables and creates dimension and fact tables in the Gold layer.

Visualization Examples:

Notebooks/scripts that include PySpark SQL queries and Plotly code to generate:

Average engagement metrics per list.

Monthly signups for the top 5 most subscribed lists.

Usage
Run the ETL Pipeline:

Execute the Bronze ETL notebook to ingest raw data from MailChimp.

Run the Silver ETL notebook to clean and flatten the data.

Execute the Gold ETL/Delta processing notebook to build analytical tables.

Explore the Data:

Use provided visualization examples to run queries and generate interactive dashboards.

The example queries use PySpark SQL to aggregate metrics and then visualize the results with Plotly.
