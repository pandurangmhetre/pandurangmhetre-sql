-- DATA CLEANING PROJECT USING SQL -- 

CREATE DATABASE data_cleaning;

USE data_cleaning;

SELECT * FROM layoffs;

-- Remove duplicates
-- Standardize the data
-- Null value or blank value
-- Remove column

CREATE TABLE layoffs_stagging                      -- created row data table 
LIKE layoffs;

SELECT * FROM layoffs_stagging;                      

INSERT INTO layoffs_stagging
SELECT * FROM layoffs;
    
-- Remove duplicates --

WITH duplicate_cte AS                               
(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
    date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging
    
)
SELECT * FROM duplicate_cte
WHERE row_num > 1;

SELECT * FROM layoffs_stagging
WHERE company = 'Cazoo';

-- layoffs_stagging + right click + copy to clipboard + create statement --

CREATE TABLE `layoffs_stagging2` (
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

SELECT * FROM layoffs_stagging2;

INSERT INTO layoffs_stagging2
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
    date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging;

SELECT * FROM layoffs_stagging2
WHERE row_num > 1;

DELETE  FROM layoffs_stagging2
WHERE row_num > 1;

SELECT * FROM layoffs_stagging2;

-- IF PK{id} is present in the table then following is enough for removing duplicate. --

SELECT 
	id,
	COUNT(*) OVER(PARTITION BY id) AS CheckPK
FROM layoffs_stagging;


-- Standardize the data --

SELECT company, TRIM(company)
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET company = TRIM(company);

SELECT DISTINCT industry FROM layoffs_stagging2
ORDER BY 1;

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country FROM layoffs_stagging2;

SELECT 
	DISTINCT country
FROM layoffs_stagging2
WHERE country LIKE 'United States%';

UPDATE layoffs_stagging2
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT `date`,
    STR_TO_DATE(`date` , '%m/%d/%Y')
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET `date` = STR_TO_DATE(`date` , '%m/%d/%Y');

ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_stagging2;


-- Null value or blank value

SELECT * 
	FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *                                       -- we need to populate the blank industry were similar country is present.
	FROM layoffs_stagging2
WHERE industry IS NULL
OR industry = '';

SELECT * FROM layoffs_stagging2
WHERE company = "Airbnb";


UPDATE layoffs_stagging2
SET industry = NULL
WHERE industry = "";


SELECT t1.industry, t2.industry
FROM layoffs_stagging2 AS t1
JOIN layoffs_stagging2 AS t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL 
AND t1.industry IS NOT NULL;


UPDATE 
	layoffs_stagging2 AS t1
    JOIN layoffs_stagging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry	
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;


SELECT *                                               -- We need to delete this null data.
	FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
	FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_stagging2;

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;












USE school;
SELECT * FROM students;

UPDATE students
SET name = upper(name);

SET SQL_SAFE_UPDATES = 0;

UPDATE students
SET name = 'xyz'
WHERE name IS NULL 
OR email IS NULL;

DELETE FROM students
WHERE year_founded > current_date();


