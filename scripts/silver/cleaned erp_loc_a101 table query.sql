USE DataWarehouse;

SELECT * FROM bronze.erp_loc_a101;

SELECT cst_key 
FROM silver.crm_cust_info;

SELECT 
	cid,
	REPLACE(cid, '-', '') cid,
	cntry
FROM bronze.erp_loc_a101 WHERE REPLACE(cid, '-', '') NOT IN
(SELECT cst_key FROM silver.crm_cust_info);

-- Data Standardization & Consistency

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101;

SELECT
DISTINCT
	CASE
		WHEN UPPER(TRIM(cntry)) IN ('GERMANY', 'DE') THEN 'Germany'
		WHEN UPPER(TRIM(cntry)) IN ('USA', 'US', 'UNITED STATES') THEN 'United States'
		WHEN UPPER(TRIM(cntry)) = 'AUSTRALIA' THEN 'Australia'
		WHEN UPPER(TRIM(cntry)) = 'UNITED KINGDOM' THEN 'United Kingdom'
		WHEN UPPER(TRIM(cntry)) = 'CANADA' THEN 'Canada'
		WHEN UPPER(TRIM(cntry)) = 'FRANCE' THEN 'France'
		ELSE 'n/a'
	END cntry
FROM bronze.erp_loc_a101;

-- Final cleaned data from the 'bronze.erp_loc_a101' table for the insert

INSERT INTO silver.erp_loc_a101 (cid, cntry)
SELECT 
	REPLACE(cid, '-', '') cid,
	CASE
		WHEN UPPER(TRIM(cntry)) IN ('GERMANY', 'DE') THEN 'Germany'
		WHEN UPPER(TRIM(cntry)) IN ('USA', 'US', 'UNITED STATES') THEN 'United States'
		WHEN UPPER(TRIM(cntry)) = 'AUSTRALIA' THEN 'Australia'
		WHEN UPPER(TRIM(cntry)) = 'UNITED KINGDOM' THEN 'United Kingdom'
		WHEN UPPER(TRIM(cntry)) = 'CANADA' THEN 'Canada'
		WHEN UPPER(TRIM(cntry)) = 'FRANCE' THEN 'France'
		ELSE 'n/a'
	END cntry -- Normalize and Handle missing or blank country codes
FROM bronze.erp_loc_a101;

SELECT * FROM silver.erp_loc_a101;