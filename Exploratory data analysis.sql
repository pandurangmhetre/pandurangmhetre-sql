-- EXPLORATORY DATA ANALYSIS --

USE data_cleaning;

SELECT * FROM layoffs_stagging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)                    -- Total laid off
FROM layoffs_stagging2;

SELECT *
FROM layoffs_stagging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;                          -- highest total laid off with 100% laid off

SELECT *
FROM layoffs_stagging
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;                    -- highest funds raised with 100% laid off


SELECT company, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;                        -- MAX laid off in company's


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_stagging2;                                   -- laid off period 2020 to 2023


SELECT industry, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;                        --  laid off in industry


SELECT country, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;                       --  laid off in country


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;                                          -- year wise layoff


SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)                -- month wise layoff
FROM layoffs_stagging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;                                           


WITH Rolling_total AS                                             -- rolling total
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_stagging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC                                         
)
SELECT `MONTH`,total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_total
FROM Rolling_total;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company, YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;


WITH Company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company, YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC

), Company_year_rank AS

(SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC ) AS ranking 
FROM Company_year
WHERE years IS NOT NULL
)
SELECT * FROM Company_year_rank 
WHERE ranking <=5;



