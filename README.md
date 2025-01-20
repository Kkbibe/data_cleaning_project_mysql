
# Data Cleaning Project

## Overview
This project demonstrates a structured approach to cleaning and transforming raw data using SQL. The dataset used is related to company layoffs, sourced from the provided `layoffs.csv` file. The objective is to prepare this dataset for analysis by addressing common data quality issues such as duplicates, inconsistent formats, missing values, and irrelevant columns.

## Project Files

### Files Included
- **`16. DATA CLEANING PROJECT.sql`**: The SQL script that contains all the steps for cleaning the data.
- **`layoffs.csv`**: The raw dataset containing details about layoffs, including company names, locations, industries, layoff statistics, and more.

### Dataset Description
The `layoffs.csv` file contains the following columns:
- `company`: Name of the company.
- `location`: Location of the company.
- `industry`: Industry type.
- `total_laid_off`: Total number of employees laid off.
- `percentage_laid_off`: Percentage of workforce laid off.
- `date`: Date of the layoffs (in text format).
- `stage`: Funding or operational stage of the company.
- `country`: Country of the company.
- `funds_raised_millions`: Funds raised by the company in millions.

## Data Cleaning Steps
1. **Preserving Raw Data**:
   - Created a staging table (`layoffs_staging`) to ensure raw data remains intact.

2. **Duplicate Removal**:
   - Identified duplicates using `ROW_NUMBER()` and removed them.

3. **Standardizing Data**:
   - Trimmed whitespace in text fields (e.g., `company`, `location`).
   - Corrected inconsistent entries, such as aligning `crypto` and `crypto currency` under one value (`crypto`).
   - Removed trailing characters from `country` values (e.g., `United States.` to `United States`).

4. **Handling Missing Values**:
   - Replaced blank or null values in the `industry` column with appropriate values based on related data (e.g., `Airbnb` was categorized under `Travel`).
   - Deleted rows with critical missing values (e.g., both `total_laid_off` and `percentage_laid_off` were null).

5. **Date Conversion**:
   - Converted the `date` column from text to `DATE` format for consistency and usability in analysis.

6. **Column Removal**:
   - Dropped the `row_num` column used temporarily during duplicate removal.

## SQL Highlights
Key SQL techniques and functions used:
- **CTEs (Common Table Expressions)**: Simplified complex queries for duplicate identification.
- **Window Functions**: Used `ROW_NUMBER()` to detect duplicates.
- **String Manipulation**: Used `TRIM()` and `TRAILING` to clean text fields.
- **Date Conversion**: Leveraged `STR_TO_DATE()` and `ALTER TABLE` for date formatting.
- **Self-Joins**: Filled missing values in `industry` by matching related data.

## Prerequisites
To run the SQL script:
- A MySQL or compatible database environment.
- The `layoffs.csv` file loaded into a table named `layoffs`.

## Execution Steps
1. Import the `layoffs.csv` file into your database as a table named `layoffs`.
2. Run the SQL script (`16. DATA CLEANING PROJECT.sql`) step-by-step or as a whole.
3. Verify the cleaned data in the `layoffs_staging2` table.

## Results
The cleaned data in `layoffs_staging2` is ready for further analysis, with:
- No duplicate rows.
- Standardized and consistent values.
- Missing values addressed.
- Relevant columns retained and formatted.

## Example Query
After cleaning, you can execute queries like:
```sql
SELECT industry, COUNT(*) AS company_count
FROM layoffs_staging2
GROUP BY industry
ORDER BY company_count DESC;
```
This query provides the number of companies affected by layoffs in each industry.

## Conclusion
This project highlights best practices for data cleaning using SQL, ensuring the dataset is accurate, consistent, and analysis-ready.


