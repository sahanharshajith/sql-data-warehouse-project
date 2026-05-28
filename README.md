# sql-data-warehouse-project

A small example project that demonstrates a SQL-based data warehouse pipeline
with Bronze → Silver → Gold layers and simple loading/transform scripts.

Status: prototype / educational

Prerequisites
- SQL Server (or compatible engine)
- `sqlcmd` or SQL Server Management Studio (SSMS)

Repository layout
- `datasets/` — sample source CSVs used by load scripts
	- `source_crm/` — CRM sample files (cust_info.csv, prd_info.csv, sales_details.csv)
	- `source_erp/` — ERP sample files (CUST_AZ12.csv, LOC_A101.csv, PX_CAT_G1V2.csv)
- `scripts/` — SQL DDL / ETL scripts and stored procedures
	- `init_database.sql` — creates the warehouse database and basic objects
	- `bronze/` — Bronze-layer DDL and load proc (`ddl_bronze.sql`, `proc_load_bronze.sql`)
	- `silver/` — cleaning/transform queries and `proc_load_silver.sql`
	- `gold/` — final DDL and example analytical queries (`ddl_gold.sql`, `SQLQuery1.sql`...)

Getting started
1. Create or connect to a SQL Server instance.
2. Initialize the database objects by running:

```powershell
sqlcmd -S <SERVER> -U <USER> -P <PASSWORD> -i .\scripts\init_database.sql
```

3. Load Bronze-layer tables (examples):
- Run `scripts/bronze/ddl_bronze.sql` to create Bronze tables.
- Execute the loader in `scripts/bronze/proc_load_bronze.sql` (or run the stored procedure it defines).

4. Run Silver transformations using the queries in `scripts/silver/` and `scripts/proc_load_silver.sql`.

5. Build Gold artifacts from `scripts/gold/` and run the example analytical queries.

Data sources
- See `datasets/source_crm/` and `datasets/source_erp/` for sample CSV inputs used by the loaders.

Notes
- This repository is intended as a starting point for learning and experimentation.
- Scripts are simple and may need tuning for production (error handling, batching, security).

Questions or contributions
- Open an issue or submit a pull request with improvements, fixes, or additional documentation.

