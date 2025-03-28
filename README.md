# MailChimp Databricks ETL

This repository contains a set of Databricks notebooks and supporting scripts for performing a complete ETL pipeline on MailChimp data. The pipeline is built on a multi-layer architecture (Bronze, Silver, and Gold) and leverages Azure Data Lake Storage (ADLS), Delta Lake, and Databricks. In addition to the ETL processing, there are visualization examples using Plotly to explore engagement metrics and monthly signups.

## Overview

### Bronze Layer
- **Data Ingestion:**  
  Fetches raw data from MailChimp via the Mailchimp Marketing API.
- **Storage:**  
  Ingests JSON data from multiple MailChimp lists and stores it in the Bronze container on ADLS.
- **Cleanup:**  
  Implements routines to remove older ingestion folders to maintain data hygiene.

### Silver Layer
- **Data Cleaning:**  
  Reads and cleans the raw JSON files from the Bronze layer.
- **Transformation:**  
  Flattens nested data (such as merge fields and location data) and writes cleaned CSV files to the Silver container.

### Gold Layer
- **Delta Processing:**  
  Reads cleaned CSV files, converts them into Delta tables, and creates dimension and fact tables (e.g., `dim_contact`, `dim_list`, and `fact_list_membership`).
- **Analytics:**  
  These Delta tables serve as the basis for analytical queries.

### Visualization
- **Interactive Analysis:**  
  Example notebooks provide queries and interactive visualizations using Plotly.
- **Metrics:**  
  Visualizations include grouped bar charts for engagement metrics and line charts for monthly signups across the top MailChimp lists.

## Prerequisites

### Databricks Environment
- This project is designed to run in Databricks notebooks.

### Azure Data Lake Storage (ADLS)
- Ensure you have an ADLS account with appropriate containers for Bronze, Silver, and Gold data.
- Update the account names and container names in the code as needed.

### MailChimp API Access
- A valid MailChimp API key is required.
- The API key is accessed securely via `dbutils.secrets.get()`, so configure your Databricks secrets accordingly.

### Python Libraries
Ensure the following libraries are installed (consider listing them in a `requirements.txt` file):
- `mailchimp_marketing`
- `azure-identity`
- `azure-storage-file-datalake`
- `pandas`
- `pyspark`
- `plotly`

## Setup & Configuration

### Clone the Repository
```bash
git clone https://github.com/dejong-LLMOPS/MailChimp_Databricks_ETL.git
