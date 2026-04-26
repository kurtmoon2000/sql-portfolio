/*USING VITALSTATISTICS DATABASE TO CREATE TABLES FOR FETAL MORTALITY REPORT */
USE VitalStatistics
GO

/*CREATING TABLE FOR FETAL DEATHS DATA */
CREATE TABLE VitalStats_National (
    StatID INT IDENTITY(1,1) PRIMARY KEY,
    Year INT NOT NULL,
    TotalFetalDeaths INT,
    TotalLiveBirths INT,
    TotalFetalMortalityRate DECIMAL(5,2),
    EarlyFetalMortalityRate DECIMAL (5,2),
    LateFetalMortalityRate DECIMAL (5,2)
);
ALTER TABLE VitalStats_National
ADD   TotalEarlyFetalDeaths INT,
    TotalLateFetalDeaths INT;


/* CREATING TABLE FOR RACE AND ETHNICITY DATA */
CREATE TABLE VitalStats_RaceEthnicity (
    RaceID INT IDENTITY (1,1) PRIMARY KEY,
    Year INT NOT NULL,
    RaceEthnicity VARCHAR (100),
    FetalDeaths INT,
    LiveBirths INT,
    FetalMortalityRate DECIMAL (5,2)

);

/* CREATING TABLE FOR  Number of fetal deaths and births and fetal mortality rate, by state */
CREATE TABLE VitalStats_ByState (
    StateID INT IDENTITY (1,1) PRIMARY KEY,
    Year INT NOT NULL,
    State VARCHAR (100),
    FetalDeaths INT,
    LiveBirths INT,
    FetalMortalityRate DECIMAL (5,2),
    PercentChangeRate DECIMAL (5,2)

);

