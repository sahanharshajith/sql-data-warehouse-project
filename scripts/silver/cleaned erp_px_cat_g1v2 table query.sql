USE DataWarehouse;

SELECT * FROM bronze.erp_px_cat_g1v2;

-- Check for Unwanted Spaces

SELECT * 
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(cat) != cat
OR TRIM(subcat) != subcat
OR TRIM(maintenance) != maintenance

SELECT * 
FROM bronze.erp_px_cat_g1v2
WHERE cat = 'CAT';

DELETE FROM bronze.erp_px_cat_g1v2
WHERE cat = 'CAT';

-- Data Standardization & Consistency

SELECT DISTINCT cat, COUNT(cat)
FROM bronze.erp_px_cat_g1v2
GROUP BY cat;

SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2

-- Final cleaned data from the 'bronze.erp_px_cat_g1v2' table for the insert

INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
SELECT 
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2

SELECT * FROM silver.erp_px_cat_g1v2;