/* ============================================================
   PROJECT  : Texas Emergency Department Visit Analysis 2025
   AUTHOR   : Kurt Moon RN BSN MSN
   DATASET  : edstat2q2025-2.xlsx — Texas Health Care Information
              Collection (THCIC) — 854 hospitals
   TOOL     : Google BigQuery
   PURPOSE  : Clean, verify, and analyze Q1 and Q2 2025 ED outpatient
              visit data for a Texas Hospital Association board report
   ============================================================ */


/* ============================================================
   STEP 1 — INITIAL LOOK
   Running SELECT * to understand column names, data types,
   and whether data makes sense at first glance
   ============================================================ */

SELECT *
FROM `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025`
LIMIT 10;

/* FINDINGS:
   - 854 hospitals across Texas
   - Columns: hospital_id, hospital_name, hospital_city,
     county_name, county_FIPS, q1_visits, q2_visits
   - Q1 and Q2 were originally imported as STRING with comma
     formatting (e.g. 7,058) — required REGEXP_REPLACE + SAFE_CAST
   - One junk column "end of list" was present — dropped via
     ALTER TABLE DROP COLUMN before this query was written
*/


/* ============================================================
   STEP 2 — COUNT NULLS
   Identify which columns have missing data before making
   any cleaning decisions
   ============================================================ */

SELECT
  COUNTIF(hospital_id   IS NULL) AS null_hospital_id,
  COUNTIF(hospital_name IS NULL) AS null_hospital_name,
  COUNTIF(hospital_city IS NULL) AS null_hospital_city,
  COUNTIF(county_name   IS NULL) AS null_county_name,
  COUNTIF(county_FIPS   IS NULL) AS null_county_fips,
  COUNTIF(q1_visits     IS NULL) AS null_q1,
  COUNTIF(q2_visits     IS NULL) AS null_q2,
  COUNT(*)                       AS total_rows
FROM `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025`;

/* FINDINGS:
   - total rows        : 854
   - null hospital_id  : 0
   - null hospital_name: 0
   - null hospital_city: 0
   - null county_name  : 0
   - null county_FIPS  : 0
   - null q1_visits    : 28  (3.3% of hospitals)
   - null q2_visits    : 13  (1.5% of hospitals)
*/


/* ============================================================
   STEP 3 — VIEW THE ACTUAL NULL ROWS
   Identify which hospitals have missing data and understand
   WHY before deciding how to handle them
   ============================================================ */

SELECT
  hospital_id,
  hospital_name,
  hospital_city,
  county_name,
  county_FIPS,
  q1_visits,
  q2_visits
FROM `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025`
WHERE q1_visits IS NULL
   OR q2_visits IS NULL
ORDER BY hospital_name;

/* FINDINGS:
   - Hospitals with NULL q1_visits but valid q2_visits are most
     likely newly opened facilities that started reporting in Q2
   - Hospitals with NULL q2_visits but valid q1_visits likely
     stopped reporting or closed after Q1
   - These are NOT data entry errors — they reflect real
     operational status of each facility
   - Decision: use COALESCE to replace NULL with 0 so all
     calculations still work correctly
*/


/* ============================================================
   STEP 4 — CONFIRM NO HOSPITAL IS COMPLETELY EMPTY
   Rule out the worst case before applying any fix
   ============================================================ */

SELECT
  hospital_name,
  q1_visits,
  q2_visits
FROM `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025`
WHERE q1_visits IS NULL
  AND q2_visits IS NULL;

/* FINDINGS:
   - Returns 0 rows — no hospital is completely empty
   - Every hospital reported at least one quarter
   - Safe to proceed with COALESCE replacing NULLs with 0
*/


/* ============================================================
   STEP 5 — FINAL CLEANING QUERY WITH CALCULATED COLUMNS
   Saves a new clean table with:
   - NULLs replaced by 0 via COALESCE
   - total_visits, q1_to_q2_change, pct_change calculated
   - reporting_status flag added per hospital
   Raw table stays untouched as source of truth
   ============================================================ */

CREATE OR REPLACE TABLE
  `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025_clean`
AS
SELECT
  hospital_id,
  hospital_name,
  hospital_city,
  county_name,
  county_FIPS,

  /* Replace NULL with 0 so math works on all rows */
  COALESCE(q1_visits, 0)                    AS q1_visits,
  COALESCE(q2_visits, 0)                    AS q2_visits,

  /* Total visits both quarters combined */
  COALESCE(q1_visits, 0)
  + COALESCE(q2_visits, 0)                  AS total_visits,

  /* Change from Q1 to Q2 — negative = drop, positive = growth */
  COALESCE(q2_visits, 0)
  - COALESCE(q1_visits, 0)                  AS q1_to_q2_change,

  /* % change — NULLIF prevents divide by zero crash */
  ROUND(
    (COALESCE(q2_visits, 0) - COALESCE(q1_visits, 0))
    * 100.0
    / NULLIF(COALESCE(q1_visits, 0), 0)
  , 1)                                      AS pct_change,

  /* Flag each hospital by reporting completeness */
  CASE
    WHEN q1_visits IS NULL THEN 'Q2 Only - new or late reporting'
    WHEN q2_visits IS NULL THEN 'Q1 Only - closed or stopped reporting'
    ELSE 'Full Year'
  END                                       AS reporting_status

FROM `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025`
ORDER BY total_visits DESC;


/* ============================================================
   STEP 6 — VERIFICATION CHECKS
   Confirm data is correct before connecting to Power BI
   ============================================================ */

-- Check 1: Row count should be 854
SELECT COUNT(*) AS total_rows
FROM `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025_clean`;

-- Check 2: Zero nulls should remain in cleaned columns
SELECT COUNT(*) AS remaining_nulls
FROM `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025_clean`
WHERE q1_visits IS NULL
   OR q2_visits IS NULL;

/* EXPECTED RESULTS:
Check 1 : 854
Check 2 : 0

*/


/* =================================================================
STEP 7 - ANALYSIS QUERIES FOR POWER BI
Possible questions from stakeholder 
  1. Which counties have the highest ED volume?
  2. Which hospitals drive it?
  3. Who grew or dropped from Q1 to Q2?"
=================================================================== */

-- Top 10 counties by total ED volume
SELECT
  county_name,
  SUM(total_visits) AS county_total_visits,
  COUNT(*)          AS hospital_count
FROM 
  `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025_clean`
GROUP BY
  county_name
ORDER by county_total_visits DESC
LIMIT 10;

-- Top 10 hospitals with DROP from Q1 to Q2
SELECT
  hospital_name,
  hospital_city,
  county_name,
  q1_visits,
  q2_visits,
  q1_to_q2_change,
  pct_change
FROM
  `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025_clean`
WHERE reporting_status = 'Full Year'
  AND q1_visits > 0
ORDER by q1_to_q2_change ASC
LIMIT 10;

-- Top 10 hospital with the best growth from Q1 to Q2
SELECT
  hospital_name,
  hospital_city,
  county_name,
  q1_visits,
  q2_visits,
  q1_to_q2_change,
  pct_change
FROM
  `project-145a3a7a-3553-489d-ae7.ed_admit.txed_outpatient2025_clean`
WHERE reporting_status = 'Full Year'
  AND q1_visits > 0
ORDER by q1_to_q2_change DESC
LIMIT 10;

/* ============================================================
   END OF FILE
   Tools     : Google BigQuery (SQL)
   Viz tool  : Tableau
   Data source: Texas Health Care Information Collection (THCIC)
                edstat2q2025-2.xlsx — Q1 and Q2 2025
   ============================================================ */
