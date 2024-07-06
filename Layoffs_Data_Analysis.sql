SELECT * 
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging; 

WITH duplicate_CTE AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging 
)
Select * 
from duplicate_cte 
where row_num > 1;

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

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * FROM layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;


DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE '%crypto%';

UPDATE layoffs_staging2
SET INDUSTRY = 'Crypto'
WHERE industry LIKE '%crypto%';

SELECT DISTINCT	industry
FROM layoffs_staging2
order by 1;

SELECT DISTINCT	country
FROM layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET country = trim(trailing '.' from country)
WHERE country LIKE '%United States%' ;

 -- TO FORMAT TO DATE FORMAT
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= str_to_date(`date`, '%m/%d/%Y');


-- UPDATING IN THE TABLE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = " "; 

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';



SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry ="")
AND t2.industry	IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry ="")
AND t2.industry	IS NOT NULL;

-- changing blank values to NULL so that it's easy for updation

 UPDATE layoffs_staging2
 SET industry = NULL
 WHERE industry ='';
 
 DELETE 
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
 AND percentage_laid_off IS NULL;
 
 ALTER TABLE layoffs_staging2
 DROP COLUMN row_num;
 
 
 
-- EXPLORATOY DATA ANALYSIS

-- To calculate total layoff by each company

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- To calculate total layoff by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- To calculate total layoff by Country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- To calculate total layoff by Year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- To calculate total layoff by stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- To calculate rolling layoff Month wise

SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ; 

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total; 

-- To calculate total layoff by each company in a year

SELECT company,YEAR(`date`) AS `Year`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY company ASC;

WITH Company_Year AS
(
SELECT company,YEAR(`date`) AS `Year`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
), Company_Year_Rank AS
(
SELECT * , 
DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY total_laid_off DESC) AS `RANK`
FROM Company_Year
WHERE `Year` IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE `RANK` <= 5;







