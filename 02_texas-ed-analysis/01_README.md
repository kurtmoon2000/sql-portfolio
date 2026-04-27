# Texas Emergency Department Visit Analysis 2025

## Overview
Analyzed Q1 and Q2 2025 emergency department visit data across 854 Texas hospitals
for a Texas Hospital Association board-level report. Raw data was sourced from the
Texas Health Care Information Collection (THCIC) and cleaned entirely in Google BigQuery
before analysis.

---

## The Business Question
> *"Which counties in Texas are showing the highest emergency department volume in 2025,
> and which hospitals within those counties are driving that volume? Which hospitals had
> the biggest drop or biggest growth from Q1 to Q2?"*

---

## Tools Used
| Tool | Purpose |
|---|---|
| Google BigQuery | Data cleaning, transformation, analysis |
| SQL | COALESCE · CASE WHEN · GROUP BY · ROUND · NULLIF · ORDER BY |
| Power BI | Dashboard visualization *(coming soon)* |

---

## Data Source
**Texas Health Care Information Collection (THCIC)**  
Texas Department of State Health Services  
[https://www.dshs.texas.gov/thcic](https://www.dshs.texas.gov/thcic)

- 854 hospitals across Texas
- Q1 2025 and Q2 2025 outpatient ED visit counts
- Raw format: Excel (.xlsx) with comma-formatted numbers and NULL values

---

## Data Cleaning Process — 7 Steps

### Step 1 — Initial Look
Ran `SELECT *` to understand column names, data types, and whether the data
made sense at first glance before touching anything.

### Step 2 — Count NULLs
Used `COUNTIF` to identify missing data across every column before making
any cleaning decisions.

| Column | NULLs Found |
|---|---|
| hospital_id | 0 |
| hospital_name | 0 |
| hospital_city | 0 |
| county_name | 0 |
| county_FIPS | 0 |
| q1_visits | 28 (3.3%) |
| q2_visits | 13 (1.5%) |

### Step 3 — View the Actual NULL Rows
Identified which hospitals had missing data and understood WHY before
deciding how to handle them.
- Hospitals with NULL q1_visits but valid q2_visits — newly opened or started reporting in Q2
- Hospitals with NULL q2_visits but valid q1_visits — closed or stopped reporting after Q1
- These are NOT data entry errors — they reflect real operational status

### Step 4 — Confirm No Hospital is Completely Empty
Confirmed zero hospitals had both Q1 and Q2 null — ruled out the worst
case before applying any fix.

### Step 5 — Final Cleaning Query
Saved a brand new clean table (`txed_outpatient2025_clean`) with:
- NULLs replaced by 0 via COALESCE
- total_visits, q1_to_q2_change, pct_change calculated
- reporting_status flag added per hospital
- Raw table preserved untouched as source of truth

### Step 6 — Verification Checks
- Row count confirmed: **854**
- Remaining NULLs in cleaned columns: **0**

### Step 7 — Analysis Queries
Built three queries to directly answer the stakeholder question:
- Top 10 counties by total ED volume
- Top 10 hospitals with biggest DROP from Q1 to Q2
- Top 10 hospitals with biggest GROWTH from Q1 to Q2

---

## Key Findings

| Rank | Hospital | City | Total Visits |
|---|---|---|---|
| 1 | Parkland Memorial Hospital | Dallas | 99,871 |
| 2 | John Peter Smith Hospital | Fort Worth | 64,529 |
| 3 | Cook Children's Medical Center | Fort Worth | 60,317 |
| 4 | University Hospital | San Antonio | 49,033 |
| 5 | Methodist Hospital | San Antonio | 44,166 |

- **28 hospitals (3.3%)** reported Q2 only — new or late-reporting facilities
- **13 hospitals (1.5%)** reported Q1 only — closed or stopped reporting after Q1
- **DFW and San Antonio** dominate the top 5 by total ED volume

---

## Files in This Folder

| File | Description |
|---|---|
| `texas_ed_analysis_final.sql` | Complete documented SQL — investigation, cleaning, verification, and analysis |

---

## SQL Highlights

```sql
-- Replace NULLs with 0 so math works on all rows
COALESCE(q1_visits, 0) AS q1_visits,
COALESCE(q2_visits, 0) AS q2_visits,

-- % change — NULLIF prevents divide by zero crash
ROUND(
  (COALESCE(q2_visits, 0) - COALESCE(q1_visits, 0))
  * 100.0
  / NULLIF(COALESCE(q1_visits, 0), 0)
, 1) AS pct_change,

-- Flag each hospital by reporting completeness
CASE
  WHEN q1_visits IS NULL THEN 'Q2 Only - new or late reporting'
  WHEN q2_visits IS NULL THEN 'Q1 Only - closed or stopped reporting'
  ELSE 'Full Year'
END AS reporting_status,

-- Top 10 counties by total ED volume
SELECT county_name, SUM(total_visits) AS county_total_visits
FROM txed_outpatient2025_clean
GROUP BY county_name
ORDER BY county_total_visits DESC
LIMIT 10;
```

---

## Clinical Context
As a Registered Nurse with experience in Epic, Cerner, and Meditech, I understand
what these numbers mean beyond the data. A hospital with 99,871 ED visits in 6 months
means an average of 548 patients walking through that door every single day. That is
staffing decisions, capacity planning, and patient safety — not just a number in a table.

---

*Part of the [SQL Portfolio](https://github.com/kurtmoon2000/sql-portfolio) by Kurt Moon RN BSN | MSN Health Informatics (UT Tyler, 2026)*
