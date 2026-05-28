# SQL Data Warehouse Project

This project demonstrating a modern SQL-based data warehouse pipeline, following the Bronze → Silver → Gold layered architecture. This repository includes sample data, ETL/DDL scripts, and instructions for loading, transforming, and querying data.

---

## Table of Contents

- [Features](#features)
- [Repository Layout](#repository-layout)
- [Getting Started](#getting-started)
- [Data Sources](#data-sources)
- [Contributing](#contributing)

---

## Features

- Simple data warehouse pipeline with layered (Bronze, Silver, Gold) architecture
- Sample source CSV data for CRM and ERP systems
- SQL scripts for database setup, loading, transformation, and sample analytics

---

## Repository Layout

```
datasets/
	source_crm/
		cust_info.csv
		prd_info.csv
		sales_details.csv
	source_erp/
		CUST_AZ12.csv
		LOC_A101.csv
		PX_CAT_G1V2.csv
scripts/
	init_database.sql
	bronze/
		ddl_bronze.sql
		proc_load_bronze.sql
	silver/
		ddl_silver.sql
		proc_load_silver.sql
	gold/
		ddl_gold.sql
		SQLQuery1.sql
		...
```

---

## Getting Started

### Prerequisites

- [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) : Lightweight server for hosting your SQL database.
- [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver22) : GUI for managing and interacting with databases.

### Setup Instructions

1. **Clone this repository:**
	 ```bash
	 git clone https://github.com/sahanharshajith/sql-data-warehouse-project.git
	 cd sql-data-warehouse-project
	 ```

2. **Create or connect to a SQL Server instance.**

3. **Initialize the database objects:**

	 ```bash
	 sqlcmd -S <SERVER> -U <USER> -P <PASSWORD> -i .\scripts\init_database.sql
	 ```

4. **Load Bronze-layer tables:**
	 - Run `scripts/bronze/ddl_bronze.sql` to create Bronze tables.
	 - Execute `scripts/bronze/proc_load_bronze.sql` or call the stored procedure it defines to load data.

5. **Run Silver transformations:**
	 - Use transformation queries in `scripts/silver/`.
	 - Execute `scripts/silver/proc_load_silver.sql` as needed.

6. **Build Gold artifacts:**
	 - Run scripts in `scripts/gold/` (e.g., `ddl_gold.sql`, `SQLQuery1.sql`) for Gold-layer tables and example analytics.

---

## Data Sources

- `datasets/source_crm/` — CRM sample files:  
	`cust_info.csv`, `prd_info.csv`, `sales_details.csv`
- `datasets/source_erp/` — ERP sample files:  
	`CUST_AZ12.csv`, `LOC_A101.csv`, `PX_CAT_G1V2.csv`

These are used as input for ETL scripts in the Bronze layer.

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for improvements, bug fixes, or additional documentation.
