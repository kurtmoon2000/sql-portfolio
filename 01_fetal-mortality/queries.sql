/* Queries for Total Fetal Deaths by Year */
SELECT Year, TotalFetalDeaths
FROM VitalStats_National
ORDER BY Year;

/*Queries for Fetal Mortality Trend (National level) */
SELECT Year, TotalFetalMortalityRate
FROM VitalStats_National
ORDER BY Year;


/*FIXING DUPLICATE*/
Select Year, COUNT (*) AS row_count
FROM VitalStats_National
GROUP BY Year
HAVING COUNT(*) > 1;

/*Deleting duplicate row for year 2022*/
WITH cte AS (
    SELECT *,
              ROW_NUMBER() OVER (PARTITION BY Year ORDER BY StatID) AS rn
    FROM VitalStats_National
)
DELETE FROM cte
WHERE rn > 1;

/*Re-checking table */
SELECT Year, TotalFetalMortalityRate
FROM VitalStats_National
ORDER BY Year;


/*Early vs.late fetal mortality (National Trend) */
SELECT 
    Year, 
    TotalEarlyFetalDeaths,
    TotalLateFetalDeaths,
    EarlyFetalMortalityRate,
    LateFetalMortalityRate
FROM VitalStats_National
ORDER BY Year;


/* Verify Data Loaded Correctly */
SELECT *
FROM VitalStats_ByState
ORDER BY Year, State;

/* Total Fetal Deaths by Year */
SELECT 
    Year,
    SUM (FetalDeaths) AS TotalFetalDeaths
FROM VitalStats_ByState
GROUP BY Year
ORDER BY Year;


/* Average Fetal Mortality Rate by Year */
SELECT
    Year,
    AVG (FetalMortalityRate) AS AVGFetalMortalityRate
FROM VitalStats_ByState
GROUP BY Year
ORDER BY Year;


/* Top 10 States with Highest Fetal Mortality Rate */
SELECT TOP 10
    State,
    Year,
    FetalMortalityRate
FROM VitalStats_ByState
GROUP BY Year, State, FetalMortalityRate
ORDER BY FetalMortalityRate DESC;

/* Texas vs. National Comparison */
SELECT
    s.Year,
    s.FetalDeaths AS TexasFetalDeaths,
    s.LiveBirths AS TexasLiveBirths, 
    s.FetalMortalityRate AS TexasRate,
    (SELECT AVG (FetalMortalityRate)
     FROM VitalStats_ByState
     WHERE Year = s.Year) AS NationalAvgRate

FROM VitalStats_ByState s
WHERE s.State = 'Texas'
ORDER BY s.Year;


/* Texas Rank Among All States (Each Year) */
WITH Ranked AS (
    SELECT
        State,
        Year,
        FetalMortalityRate,
        RANK() OVER (PARTITION By Year ORDER BY FetalMortalityRate DESC) AS RateRank
    FROM VitalStats_ByState
)
SELECT *
FROM Ranked
WHERE State = 'Texas'
ORDER BY Year;


/* Texas Forecast for Next Year (Simple Linear Projection) */
WITH Trend AS (
    SELECT
        Year,
        FetalMortalityRate,
        ROW_NUMBER () OVER (ORDER BY Year) AS ROW_NUMBER
    FROM VitalStats_ByState
    WHERE State = 'Texas'
)
SELECT
    MAX (Year) + 1 AS ForecastYear,
    AVG(FetalMortalityRate)
        + (AVG(FetalMortalityRate) - MIN(FetalMortalityRate)) AS ForecastRate
FROM Trend;


/* Rank Race / Ethnicity by Fetal Mortality Rate (Each Year) */
SELECT
    Year,
    RaceEthnicity,
    FetalMortalityRate,
    RANK() OVER (
        PARTITION BY YEAR
        ORDER BY FetalMortalityRate DESC
    ) AS RateRank
FROM VitalStats_RaceEthnicity
ORDER BY Year, RateRank;

