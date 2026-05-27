SELECT * FROM bronze.crm_prd_info;

-- Check For Null or Duplicates in Primary Key

SELECT 
	prd_id,
	COUNT(*) prd_id_count
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces

SELECT * FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm); 

-- Check for NULLs or Negative Numbers

SELECT * FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL; 

-- Data Standardization & Consistency

SELECT DISTINCT prd_line 
FROM bronze.crm_prd_info;

-- Check for Invalid Date Orders

SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT 
	prd_id,
	prd_key,
	prd_nm,
	prd_start_dt,
	prd_end_dt,
	LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');

-- Final cleaned data from the 'bronze.crm_prd_info' table for the insert

INSERT INTO silver.crm_prd_info (prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line,prd_start_dt,prd_end_dt)
SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END prd_line,
	CAST(prd_start_dt AS DATE) prd_start_dt,
	CAST(
		LEAD(prd_start_dt) 
		OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
		AS DATE
	) prd_end_dt -- Calculate end date as one day before the next start date
FROM bronze.crm_prd_info;

SELECT * FROM silver.crm_prd_info;