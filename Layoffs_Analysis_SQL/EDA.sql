-- Exploratory Data Analysis

SELECT 
    *
FROM
    layoffs_staging;

SELECT 
    MAX(total_laid_off), MAX(percentage_laid_off)
FROM
    layoffs_staging;

SELECT 
    *
FROM
    layoffs_staging
WHERE
    percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT 
    *
FROM
    layoffs_staging
WHERE
    percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging
GROUP BY company
ORDER BY 2 DESC;

SELECT 
    MIN(`date`), MAX(`date`)
FROM
    layoffs_staging;

SELECT 
    industry, SUM(total_laid_off)
FROM
    layoffs_staging
GROUP BY industry
ORDER BY 2 DESC;

SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_staging
GROUP BY country
ORDER BY 2 DESC;

SELECT 
    YEAR(`date`) `year`, SUM(total_laid_off)
FROM
    layoffs_staging
GROUP BY `year`
ORDER BY 2 DESC;

SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging
GROUP BY stage
ORDER BY 2 DESC;

WITH laid_off_per_month (`MONTH`, total_laid_off) AS 
( 
SELECT 
	DATE_FORMAT(`date`, '%Y-%m') AS `MONTH`,
    SUM(total_laid_off) 
FROM layoffs_staging
WHERE DATE_FORMAT(`date`, '%Y-%m') IS NOT NULL
GROUP BY `MONTH`
)

SELECT *,
	SUM(total_laid_off) OVER(ORDER BY `MONTH`) rolling_total
 FROM laid_off_per_month;
 
  
 
 WITH company_laid_off AS 
 (
 SELECT company, YEAR(`date`) `year`, SUM(total_laid_off) total_laid_off FROM layoffs_staging
 GROUP BY company, `year`
 ),
 Co_Ran_Ov_Ye AS 
 (
 SELECT *,
 DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laid_off DESC) as ranking
 FROM company_laid_off
 WHERE `year` IS NOT NULL
 )
 
 SELECT * FROM Co_Ran_Ov_Ye
 WHERE ranking <=5
 ORDER BY `year` DESC;
 
 WITH industry_laid_off AS 
 (
 SELECT industry, YEAR(`date`) `year`, SUM(total_laid_off) total_laid_off FROM layoffs_staging
 GROUP BY industry, `year`
 ),
 In_Ran_Ov_Ye AS 
 (
 SELECT *,
 DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laid_off DESC) as ranking
 FROM industry_laid_off
 WHERE `year` IS NOT NULL
 )
 
 SELECT * FROM In_Ran_Ov_Ye
 WHERE ranking <=5
 ORDER BY `year` DESC;
 
