## Data Cleaning

SELECT * FROM layoffs;


#   1. Removing Duplicates
#   2.Standardize the Data
#   3.Null Values or Blanks values
#   4.Remove any columns


CREATE TABLE layoffs_staging
     LIKE layoffs;
     
SELECT * FROM layoffs_staging;

INSERT layoffs_staging 
SELECT * FROM layoffs; 

WITH CTE1 AS( 
SELECT * ,ROW_NUMBER() OVER( PARTITION BY company, industry,total_laid_off,date,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging)
DELETE FROM CTE1 WHERE row_num >1;



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
  `row_num`int
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
  
 set sql_safe_updates=0;
 
  SELECT *
  FROM layoffs_staging2;
  
INSERT INTO layoffs_staging2
SELECT * ,ROW_NUMBER() OVER( PARTITION BY company, industry,total_laid_off,date,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;

DELETE FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

# Standardizing Data 

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET company = TRIM(company);

UPDATE layoffs_staging2 
SET industry = "crypto"
WHERE industry LIKE "crypto%";


SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT country,trim(TRAILING "." FROM country)
FROM layoffs_staging2
ORDER BY 1;
  
UPDATE layoffs_staging2 
SET country = trim(TRAILING "." FROM country)
WHERE industry LIKE "united states%";

SELECT DISTINCT date, STR_TO_DATE(date,"%m/%d/%Y")
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET date = STR_TO_DATE(date,"%m/%d/%Y");

ALTER TABLE layoffs_staging2 
MODIFY column date datetime;

SELECT * 
FROM layoffs_staging2
WHERE industry is null or industry= "";

UPDATE layoffs_staging2 SET industry = null
WHERE industry="";

SELECT *
FROM layoffs_staging2 t1 JOIN layoffs_staging2 t2 ON
                            t1.company=t2.company AND
                            t1.location=t2.location WHERE
                            (t1.industry IS NULL OR t1.industry = "") AND t2.industry IS not null;
                            
UPDATE layoffs_staging2 t1 JOIN layoffs_staging2 t2  on t1.company=t2.company 
 set t1.industry = t2.industry WHERE t1.industry  IS NULL  AND t2.industry IS not null;
 
 DELETE FROM layoffs_staging2 where 
 total_laid_off is null AND
 percentage_laid_off IS null;


 SELECT *  FROM layoffs_staging2 where 
 total_laid_off is null AND
 percentage_laid_off IS null;

SELECT * FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP row_num;





