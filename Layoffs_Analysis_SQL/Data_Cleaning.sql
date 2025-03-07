-- Data Cleaning 

SELECT 
    *
FROM
    layoffs;

-- 1. Remove Duplicates
-- 2. Standardize Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns or Rows

CREATE TABLE layoffs_staging LIKE layoffs;

ALTER TABLE layoffs_staging ADD COLUMN row_num INT;

INSERT INTO layoffs_staging
SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY
    company, location, industry, total_laid_off, percentage_laid_off, date, 
    stage, country, funds_raised_millions) row_num
FROM layoffs;

-- 1. Remove Duplicates

SELECT * FROM layoffs_staging
WHERE row_num > 1; 

DELETE
FROM
    layoffs_staging
WHERE row_num > 1;

-- 2. Standardizing Data

SELECT DISTINCT company, TRIM(company) FROM layoffs_staging;

UPDATE layoffs_staging SET company = TRIM(company);

SELECT DISTINCT industry FROM layoffs_staging
ORDER BY industry;

UPDATE layoffs_staging SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location FROM layoffs_staging
ORDER BY location;

SELECT DISTINCT country FROM layoffs_staging
ORDER BY country;

UPDATE layoffs_staging SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT `date` FROM layoffs_staging;

UPDATE layoffs_staging SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging MODIFY COLUMN `date` DATE;

-- 3. Null Values or Blank Values

SELECT * FROM layoffs_staging
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

SELECT t1.industry , t2.industry FROM layoffs_staging t1
INNER JOIN layoffs_staging t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
AND t1.location = t2.location;

UPDATE layoffs_staging t1
INNER JOIN layoffs_staging t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
AND t1.location = t2.location;

-- 4. Remove Any Columns or Rows

ALTER TABLE layoffs_staging 
DROP COLUMN row_num;

SELECT * FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
