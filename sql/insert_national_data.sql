USE VitalStatistics
GO


/*INSERTING DATA FOR FETAL DEATHS AT NATIONAL LEVEL */
INSERT INTO VitalStats_National
(Year, TotalFetalDeaths, TotalEarlyFetalDeaths, TotalLateFetalDeaths, TotalLiveBirths, TotalFetalMortalityRate, EarlyFetalMortalityRate, LateFetalMortalityRate)
VALUES
(2022, 20202, 10246, 9956, 3666758, 5.48, 2.79, 2.71 ),
(2023, 20005, 10431, 9574, 3596017, 5.53, 2.89, 2.66 ),
(2024, 19756, 10485, 9271, 3628934, 5.41, 2.88, 2.55);

/*INSERTING DATA FOR FETAL DEATHS BY RACE AND ETHNICITY */
INSERT INTO VitalStats_RaceEthnicity
(Year, RaceEthnicity, FetalDeaths, LiveBirths, FetalMortalityRate)
VALUES
(2022, 'American Indian or Alaska Native', 187, 25721, 7.22),
(2022, 'Asian', 813, 218994, 3.7),
(2022, 'Black', 5194, 511439, 10.05),
(2022, 'Native Hawaiian or Other Pacific Islander', 106, 10122, 10.36),
(2022, 'White', 8280, 1840739, 4.48),
(2022, 'Hispanic', 4359, 937421, 4.63),
(2023, 'American Indian or Alaska Native', 170, 24571, 6.87),
(2023, 'Asian', 897, 215738, 4.14),
(2023, 'Black', 4941, 491494, 9.95), 
(2023, 'Native Hawaiian or Other Pacific Islander', 104, 10115, 10.18),
(2023, 'White', 8171, 1787051, 4.55),
(2023, 'Hispanic', 4520, 945200, 4.76),
(2024, 'American Indian or Alaska Native', 188, 24021, 7.77),
(2024, 'Asian', 890, 226860, 3.91),
(2024, 'Black', 4760, 473377, 9.96),
(2024, 'Native Hawaiian or Other Pacific Islander', 107, 10375, 10.21),
(2024, 'White', 8124, 1783156, 4.54),
(2024, 'Hispanic', 4568, 984092, 4.62);
GO

/* INSERTING DATA FOR FETAL DEATHS BY STATE FROM 2022 TO 2024 */
INSERT INTO VitalStats_ByState
(Year, State, FetalDeaths, LiveBirths, FetalMortalityRate)
VALUES
(2022, 'Alabama', 426, 58149, 7.27),
(2022, 'Alaska', 54, 9359, 5.74),
(2022, 'Arizona', 492, 78547, 6.22),
(2022, 'Arkansas', 265, 35471, 7.42),
(2022, 'California', 2115, 419104, 5.02), 
(2022, 'Colorado', 305, 62383, 4.87),
(2022, 'Connecticut', 175, 35332, 4.93), 
(2022, 'Delaware', 56, 10816, 5.15), 
(2022, 'District of Columbia', 65, 8075, 7.99),
(2022, 'Florida', 1548, 224433, 6.85),
(2022, 'Georgia', 1000, 126130, 7.87),
(2022, 'Hawaii', 97, 15535, 6.21),
(2022, 'Idaho', 91, 22391, 4.05),
(2022, 'Illinois', 737, 128350, 5.71 ),
(2022, 'Iowa', 163, 36506, 4.45),
(2022, 'Kansas', 205, 34401, 5.92),
(2022, 'Kentucky', 283, 52315, 5.38),
(2022, 'Louisiana', 300, 56479, 5.28 ),
(2022, 'Maine', 63, 12093, 5.18),
(2022, 'Maryland', 366, 68782, 5.29),
(2022, 'Massachusetts', 284, 68584, 4.12),
(2022, 'Michigan', 614, 102321, 5.96),
(2022, 'Minnesota', 351, 64015, 5.45),
(2022, 'Mississippi', 320, 36428, 7.69),
(2022, 'Missouri', 358, 68985, 5.16),
(2022, 'Montana', 54, 11175, 4.81),
(2022, 'Nebraska', 110, 24345, 4.50),
(2022, 'Nevada', 235, 33193, 7.03),
(2022, 'New Hampshire', 56, 12077, 4.62),
(2022, 'New Jersey', 498, 102893, 4.82 ),
(2022, 'New Mexico', 69, 21614, 3.18),
(2022, 'New York', 1211, 207774, 5.79),
(2022, 'North Carolina', 696, 121562, 5.69),
(2022, 'North Dakota', 47, 9567, 4.89),
(2022, 'Ohio', 741, 128231, 5.75),
(2022, 'Oklahoma', 293, 48332, 6.03),
(2022, 'Oregon', 195, 39493, 4.91),
(2022, 'Pennsylvania', 663, 130252, 5.06),
(2022, 'Rhode Island', 52, 10269, 5.04),
(2022, 'South Carolina', 288, 57820, 4.96 ),
(2022, 'South Dakota', 54, 11201, 4.80),
(2022, 'Tennessee', 538, 82265, 6.50),
(2022, 'Texas', 1613, 389741, 4.12),
(2022, 'Utah', 252, 45768, 5.48),
(2022, 'Vermont', 21, 5316, 3.93),
(2022, 'Virginia', 497, 95630, 5.17),
(2022, 'Washington', 421, 83333, 5.03),
(2022, 'West Virginia', 70, 16929, 4.12),
(2022, 'Wisconsin', 320, 60049, 5.30),
(2022, 'Wyoming', 36, 6049, 5.92),
(2023, 'Alabama', 436, 57858, 7.48),
(2023, 'Alaska', 42, 9015, 4.64),
(2023, 'Arizona', 494, 78096, 6.29),
(2023, 'Arkansas', 248, 35264, 6.98),
(2023, 'California', 1993, 400108, 4.96),
(2023, 'Colorado', 378, 61494, 6.11),
(2023, 'Connecticut', 171, 34559, 4.92),
(2023, 'Delaware', 62, 10427, 5.91),
(2023, 'District of Columbia', 55, 7896, 6.92), 
(2023, 'Florida', 1509, 221410, 6.77),
(2023, 'Georgia', 959, 125120, 7.61),
(2023, 'Hawaii', 90, 14808, 6.04),
(2023, 'Idaho', 123, 22397, 5.46),
(2023, 'Illinois', 740, 124820, 5.89),
(2023, 'Indiana', 496, 79000, 6.24),
(2023, 'Iowa', 159, 36052, 4.39),
(2023, 'Kansas', 184, 34065, 5.37),
(2023, 'Kentucky', 277, 51984, 5.30),
(2023, 'Louisiana', 296, 54927, 5.36),
(2023, 'Maine', 41, 11627, 3.51),
(2023, 'Maryland', 430, 65594, 6.51),
(2023, 'Massachusetts', 261, 67093, 3.88),
(2023, 'Michigan', 532, 99124,5.34),
(2023, 'Minnesota', 319, 61715, 5.14),
(2023, 'Mississippi', 343, 34459, 9.86),
(2023, 'Missouri', 372, 67123, 5.51),
(2023, 'Montana', 49, 11078, 4.40),
(2023, 'Nebraska', 123, 24111, 5.08),
(2023, 'Nevada', 245, 31794, 7.65),
(2023, 'New Hampshire', 44, 11936, 3.67),










