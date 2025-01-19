-- Data Cleaning

SELECT * 
FROM layoffs;

-- 1. Remove duplicates if any
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

# here we created a new table with the same data as in layoffs table
# we are gonna do a lot of changes in the layoffs_staging table so
# if any mistake happens we are just making sure we have the raw data intact in layoffs table.

-- removing duplicates if any

WITH duplicate_cte As
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
# here if the row_num value is more than 1 then the data is said to have duplicates
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

#now what we can do is create a another table with an extra column that that row_num and
# insert the above data in it and deleting the row where row_num is more than 1.
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO  layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1 ;

DELETE
FROM layoffs_staging2
WHERE row_num > 1 ;

-- standardizing data ( finding issues and fixing it)

SELECT company, TRIM(company) # trim removes the white spaces from the data
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'crypto%'; # we are doing this because we had same industry
# with different name that is crypto and crypto currency so we are updating all the values to the same term which is crypto



UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1; # location column is good to go no need to alter anything

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1; # here we found a data with the same country name but with additional terms on the back like united states where some name has .. behind them. we need to change that

# we can use trim to remove the . in the data using trailing keyword as
 UPDATE layoffs_staging2
 SET country = TRIM( TRAILING '.' FROM country); # now the issue is fixed
 
 # now the date in his table is in text datatype we need to change that into datetime datatype for which
 
 SELECT `date` # here we used back tick to select the column because date is a keyword in sql and we are extracting the attribute
 FROM layoffs_staging2;
 
 UPDATE layoffs_staging2
 SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y'); # here we used capital y because it denotes 4 numbered year
 # after formating is done now we can change the date column from text to datetime
 
 ALTER TABLE layoffs_staging2
 MODIFY COLUMN `date` DATE;
 
 
 -- working with null and blank values
 
 SELECT *
 FROM layoffs_staging2
 WHERE industry IS NULL
 OR industry = '';
 
 # we can populate the data if we can for eg in the data airbnb compani has blank in industry but we can see if other airbnb data has any values , if so we can populate the airbnb with the same data
 
 SELECT *
 FROM layoffs_staging2
 WHERE company = 'Airbnb';
 # after the query we can see airbnb is a travel industry so we can populate the blank or null airbnb inudstry data with travel
 # first lets change all the blank values in the industry to null
 
 UPDATE layoffs_staging2
 SET industry = null
 WHERE industry ='';
 
 # now what we can do is we can join the table within itself and fill the values where industry is null from the value where the industry is not
  #checking the join
 SELECT t1.industry,t2.industry
 FROM layoffs_staging2 t1
 JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
#updating
 UPDATE layoffs_staging2 t1
 JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
 # we cant populate other data so thats it for null values and blank values cleaning
 
 # now we can look at cleaning rows and column which we need to
 # we ave multiple rows with multiple null datas
 SELECT *
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
 AND percentage_laid_off IS NULL;
 
 #we can delete such rows depending upon the situatuion
 #lets just go ahead and do it
 
 DELETE
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
 AND percentage_laid_off IS NULL;
 
 SELECT * 
 FROM layoffs_staging2;
 
 #we have one extra column we created during removing duplication we can go ahead and delete that column
 ALTER TABLE layoffs_staging2
 DROP COLUMN row_num;
 
 


