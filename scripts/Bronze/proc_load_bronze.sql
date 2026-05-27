USE DataWarehouse;

GO
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, @end_time DATETIME;

		SET @start_time = GETDATE();
		
		PRINT @start_time;

		PRINT '****Loading Bronze Layer****';

		-- Insert CSV file into 'bronze.crm_cust_info' table

		PRINT '****Loading CRM Tables****';

		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT 'Inserting Data Into : bronze.crm_cust_info';

		BULK INSERT bronze.crm_cust_info
		FROM 'E:\Git\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- Insert CSV file into 'bronze.crm_prd_info' table

		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT 'Inserting Data Into : bronze.crm_prd_info';

		BULK INSERT bronze.crm_prd_info
		FROM 'E:\Git\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- Insert CSV file into 'bronze.crm_sales_details' table

		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT 'Inserting Data Into : bronze.crm_sales_details';

		BULK INSERT bronze.crm_sales_details
		FROM 'E:\Git\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT '****Loading ERP Tables****';

		-- Insert CSV file into 'bronze.erp_cust_az12' table

		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT 'Inserting Data Into : bronze.erp_cust_az12';

		BULK INSERT bronze.erp_cust_az12
		FROM 'E:\Git\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- Insert CSV file into 'bronze.erp_loc_a101' table

		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT 'Inserting Data Into : bronze.erp_loc_a101';

		BULK INSERT bronze.erp_loc_a101
		FROM 'E:\Git\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- Insert CSV file into 'bronze.erp_px_cat_g1v2' table

		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT 'Inserting Data Into : bronze.erp_px_cat_g1v2';

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'E:\Git\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 1,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '**Loading Bronze Layer is Completed**';
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds'
	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
	END CATCH;
END;

EXEC bronze.load_bronze;