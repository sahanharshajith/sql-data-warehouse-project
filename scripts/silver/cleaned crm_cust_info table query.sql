USE DataWarehouse;

-- Check For Null or Duplicates in Primary Key

SELECT 
	cst_id,
	COUNT(*) cst_id_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT *,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last_date
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

SELECT *,
	ROW_NUMBER() 
	OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last_date
FROM bronze.crm_cust_info

-- Check for Unwanted Spaces

SELECT * FROM bronze.crm_cust_info;

SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_material_status
FROM bronze.crm_cust_info
WHERE cst_material_status != TRIM(cst_material_status);

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

SELECT 
	cst_id, cst_key, 
	TRIM(cst_firstname) cst_firstname,
	TRIM(cst_lastname) cst_lastname,
	cst_material_status, cst_gndr, cst_create_date
FROM (
	SELECT *,
		ROW_NUMBER() 
		OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last_date
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t WHERE flag_last_date = 1;

-- Data Standardization & Consistency

SELECT 
	DISTINCT (cst_gndr)
FROM bronze.crm_cust_info;

SELECT 
	cst_id, cst_key, 
	TRIM(cst_firstname) cst_firstname,
	TRIM(cst_lastname) cst_lastname,
	CASE 
		WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
	END cst_material_status, 
	CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
	END cst_gndr, 
	cst_create_date
FROM (
	SELECT *,
		ROW_NUMBER() 
		OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last_date
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t WHERE flag_last_date = 1;

SELECT 
	DISTINCT (cst_material_status)
FROM bronze.crm_cust_info;


-- Final cleaned data from the 'bronze.crm_cust_info' table for the insert

GO
INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
SELECT 
	cst_id, 
	cst_key, 
	TRIM(cst_firstname) cst_firstname,
	TRIM(cst_lastname) cst_lastname,
	-- Normalize material status values
	CASE 
		WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
	END cst_material_status, 
	-- Normalize gender values
	CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
	END cst_gndr, 
	cst_create_date
FROM (
	SELECT 
		*,
		ROW_NUMBER() 
		OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last_date
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t WHERE flag_last_date = 1; -- Select the most recent record

GO
SELECT * 
FROM silver.crm_cust_info;