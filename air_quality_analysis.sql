USE Air_quality_analysis
go;

select * from final_dataset
SELECT TOP 10 *
FROM final_dataset;

SELECT *
FROM final_dataset
WHERE PM10 IS NOT NULL
  AND PM2_5 IS NOT NULL
  AND AQI IS NOT NULL
  AND Date IS NOT NULL;
------------------------------------------------------------------------------------------
/* total count*/
 select count(*) from final_dataset;

 select * from final_dataset;

-- List all columns in your table
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'final_dataset';
--------------------------------------------------------------------------------------
 /* add new column as full date */
SELECT 
    DATEFROMPARTS(year, month, day) AS full_date
FROM final_dataset

ALTER TABLE  final_dataset
ADD full_date DATE;

UPDATE final_dataset
SET full_date = DATEFROMPARTS([Year], [Month], [Date]);
---------------------------------------------------------------------------------------
/* new column as month name */
ALTER TABLE final_dataset
ADD month_name VARCHAR(20);

UPDATE final_dataset
SET month_name = DATENAME(MONTH, full_date);
-----------------------------------------------------------------------------------------
/* Add a new column – Season*/

ALTER TABLE final_dataset
ADD Season VARCHAR(20);

/*Update the Season column*/

UPDATE final_dataset
SET Season = CASE 
    WHEN Month IN (12, 1, 2) THEN 'Winter'
    WHEN Month IN (3, 4, 5) THEN 'Summer'
    WHEN Month IN (6, 7, 8) THEN 'Monsoon'
    WHEN Month IN (9, 10, 11) THEN 'Post-Monsoon'
END;
---------------------------------------------------------------------------------------------
/* Add a new column –AQI_Category*/

ALTER TABLE final_dataset
ADD AQI_Category VARCHAR(20);

/*Update the Season AQI_Category*/

UPDATE final_dataset
SET AQI_Category =
    CASE
        WHEN AQI <= 50 THEN 'Good'
        WHEN AQI <= 100 THEN 'Moderate'
        WHEN AQI <= 200 THEN 'Poor'
        WHEN AQI <= 300 THEN 'Very Poor'
        WHEN AQI <= 400 THEN 'Severe'
        ELSE 'Hazardous'
    END;
--------------------------------------------------------------------------------------------------
/* Add a new column –Weekday_Name*/

ALTER TABLE  final_dataset
ADD Weekday_Name VARCHAR(20);

/*Update the Season Weekday_Name*/

UPDATE final_dataset
SET Weekday_Name = DATENAME(WEEKDAY, full_date);
-----------------------------------------------------------------------------------------------------
/* Add a new column –DayType*/

ALTER TABLE final_dataset
ADD DayType VARCHAR(20);

/*Update the Season DayType*/
UPDATE final_dataset
SET DayType =
    CASE 
        WHEN Holidays_Count = 1 THEN 'Holiday'
        ELSE 'Working Day'
    END;


------------------------------------------------------------------------------------------------------------------------------------
/*Top pollutants contributing to high AQI */
 SELECT 
    'PM10' AS pollutant, AVG(PM10) AS avg_level
FROM final_dataset
WHERE AQI > 100
UNION ALL
SELECT 
    'PM2.5', AVG(PM2_5)
FROM final_dataset
WHERE AQI > 100
UNION ALL
SELECT 
    'NO2', AVG(NO2)
FROM final_dataset
WHERE AQI > 100
UNION ALL
SELECT 
    'SO2', AVG(SO2)
FROM final_dataset
WHERE AQI > 100
UNION ALL
SELECT 
    'CO', AVG(CO)
FROM final_dataset
WHERE AQI > 100
UNION ALL
SELECT 
    'O3', AVG(Ozone)
FROM final_dataset
WHERE AQI > 100
ORDER BY avg_level DESC;

SELECT 
    [Month],
    AVG(AQI) AS Avg_AQI
FROM final_dataset
GROUP BY [Month]
ORDER BY [Month];
-----------------------------------------------------------------------------------------------
/* Average AQI per month*/

select Month_name,avg(aqi) as avg_AQI,season
from final_dataset
group by month_name ,season order by avg_AQI desc

-----------------------------------------------------------------------------------------------
/* Top 10 AQI days in winter*/

select top 10
full_date , AQI,season
from final_dataset
where season='winter'
order by AQI desc
------------------------------------------------------------------------------------------------
/*Average AQI on weekdays vs weekends/holidays*/

select daytype, AVG(AQI) as Avg_AQI
from final_dataset group by DayType order by Avg_AQI desc
-----------------------------------------------------------------------------------------------------------

/*Count of days per AQI category*/

select AQI_Category,
count(*) as total_days
from final_dataset
group by AQI_Category
order by total_days desc
---------------------------------------------------------------------------------------------------------------
/*Average PM10 & PM2.5 by season*/

select AVG(PM10) as Avg_PM10,
AVG(PM2_5) as Avg_PM2_5,Season
from final_dataset
group by Season
order by Avg_PM10 desc
---------------------------------------------------------------------------------------------------------------
/* Total AQI TREND OVER TIME*/
select YEAR,sum(AQI) as Total_AQI
from final_dataset
group by Year order by Total_AQI desc
----------------------------------------------------------------------------------------------------------------





