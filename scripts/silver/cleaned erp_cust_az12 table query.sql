USE DataWarehouse;

SELECT * 
FROM bronze.erp_cust_az12;

SELECT * 
FROM silver.crm_cust_info;

SELECT 
	cid,
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END cid,
	bdate,
	gen
FROM bronze.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) ELSE cid END
NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);

SELECT 
	bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Data Standardization & Consistency

SELECT DISTINCT
CASE
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		ELSE 'n/a'
END gen
FROM bronze.erp_cust_az12;

-- Final cleaned data from the 'bronze.erp_cust_az12' table for the insert

INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
SELECT 
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END cid, -- Remove 'NAS' prefix if present
	CASE
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END bdate, -- Set future bdate to NULL
	CASE
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		ELSE 'n/a'
	END gen
FROM bronze.erp_cust_az12; -- Normalize gender values and handle unknown cases

SELECT * FROM silver.erp_cust_az12;