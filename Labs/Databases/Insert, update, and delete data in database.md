# Insert, update, and delete data in database — Documentation Journey

This document described the hands-on journey I had completed for the "Insert, update, and delete data in database" lab. It was written in past tense and included placeholders for screenshots of the most important steps.

---

## Overview

The lab demonstrated how to perform common data manipulation operations (DML) on a provisioned relational database instance named `world`. The objectives that were achieved during the lab included:

- Inserting rows into a table using INSERT statements.
- Updating rows in a table using UPDATE statements.
- Deleting rows from a table using DELETE statements.
- Importing rows from a database backup (.sql) file.

Sample data used in the exercises was taken from Statistics Finland (general regional statistics, 2022-02-04). The lab duration was approximately 45 minutes.

---

## Preconditions and Resources

Before I began, the following resources had been provided:

- An EC2 instance (the Command Host) with a database client (MySQL client) installed.
- A relational database instance containing a `world` database with three tables: `city`, `country`, and `countrylanguage`.
- A configured root password for the MySQL instance for lab access.

Placeholder screenshot:
<img width="719" height="406" alt="Screenshot 2026-07-31 at 15 02 13" src="https://github.com/user-attachments/assets/98a3cbba-2207-4215-b6da-32a177b96829" />

<img width="715" height="399" alt="Screenshot 2026-07-31 at 15 02 33" src="https://github.com/user-attachments/assets/39b83249-ce18-4121-9c81-5f7fa7b8e6dd" />

---

## Task 1 — Connecting to the Command Host and Database

I connected to the Command Host using the AWS Console and Session Manager to access the MySQL client. The steps I followed were:

1. In the AWS Management Console, I opened Services → Compute → EC2 and selected Instances.
2. I located the instance labelled "Command Host", selected it, and clicked Connect.
3. I chose the Session Manager tab and clicked Connect to open a terminal session.

Screenshot placeholder: Command Host selected in the EC2 console and Session Manager button.

<img width="831" height="533" alt="Screenshot 2026-07-31 at 15 10 01" src="https://github.com/user-attachments/assets/2e283ce4-3ade-4ae4-81cc-b0a2b88ea5a4" />

<img width="822" height="675" alt="Screenshot 2026-07-31 at 15 11 22" src="https://github.com/user-attachments/assets/fc566ea5-87c1-47c7-812d-e925108842ee" />



4. In the terminal, I prepared the environment by switching to the root user and moving to the ec2-user home directory:

```bash
sudo su
cd /home/ec2-user/
```

5. I connected to the database instance using the MySQL client with the provided credentials:

```bash
mysql -u root --password='.....'
```

Screenshot placeholder: Active MySQL prompt after successful connection.

<img width="648" height="44" alt="Screenshot 2026-07-31 at 15 13 36" src="https://github.com/user-attachments/assets/491bb95d-c6db-4be8-b8af-f86f33363752" />

<img width="894" height="204" alt="Screenshot 2026-07-31 at 15 32 35" src="https://github.com/user-attachments/assets/5580d14b-2e10-403a-b7d4-3d73d7b291fa" />

6. I verified available databases with:

```sql
SHOW DATABASES;
```

---

## Task 2 — Insert data into the country table

I validated the `country` table and inserted sample rows as part of the lab.

1. I confirmed the `country` table content and structure by running:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: Initial SELECT * output.

<img width="604" height="101" alt="Screenshot 2026-07-31 at 15 15 29" src="https://github.com/user-attachments/assets/90cfe0a4-fabc-40bb-87b0-53a5032542cd" />

2. I inserted two sample rows into the `country` table using the following statements (the VALUES lists matched the table schema order):

```sql
INSERT INTO world.country VALUES ('IRL','Ireland','Europe','British Islands',70273.00,1921,3775100,76.8,75921.00,73132.00,'Ireland/Éire','Republic',1447,'IE');

INSERT INTO world.country VALUES ('AUS','Australia','Oceania','Australia and New Zealand',7741220.00,1901,18886000,79.8,351182.00,392911.00,'Australia','Constitutional Monarchy, Federation',135,'AU');
```

3. I verified that the two rows had been inserted by querying specifically for those codes:

```sql
SELECT * FROM world.country WHERE Code IN ('IRL', 'AUS');
```

Screenshot placeholder: SELECT for newly inserted rows.

<img width="1027" height="520" alt="Screenshot 2026-07-31 at 15 18 16" src="https://github.com/user-attachments/assets/56b77218-71e2-4670-a20b-eb689b95ce59" />

Expected result snapshot:

Code | Name | Continent | Region | SurfaceArea | IndepYear | Population | LifeExpectancy | GNP | GNPOld | LocalName | GovernmentForm | Capital | Code2
---|---|---|---:|---:|---:|---:|---:|---:|---:|---|---|---:|---
AUS | Australia | Oceania | Australia and New Zealand | 7741220 | 1901 | 18886000 | 79.8 | 351182 | 392911 | Australia | Constitutional Monarchy, Federation | 135 | AU
IRL | Ireland | Europe | British Islands | 70273 | 1921 | 3775100 | 76.8 | 75921 | 73132 | Ireland/Éire | Republic | 1447 | IE

---

## Task 3 — Update rows in a table

I practiced updating rows with UPDATE statements and observed the effects.

1. I updated all rows in the `country` table to set the `Population` to 0 (the UPDATE had no WHERE clause so it affected all rows):

```sql
UPDATE world.country SET Population = 0;
```

2. I verified the update with:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: SELECT output after Population set to 0.

<img width="1114" height="504" alt="Screenshot 2026-07-31 at 15 19 52" src="https://github.com/user-attachments/assets/494815e8-fa74-47cc-b307-dcbb9e4cc20d" />
3. I updated both `Population` and `SurfaceArea` columns for all rows:

```sql
UPDATE world.country SET Population = 100, SurfaceArea = 100;
```
<img width="965" height="128" alt="Screenshot 2026-07-31 at 15 20 18" src="https://github.com/user-attachments/assets/b75bdd1b-c88e-4fe1-862b-8710e9de2369" />

4. I verified the changes again with:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: SELECT output after population and surface area updates.

<img width="1125" height="502" alt="Screenshot 2026-07-31 at 15 20 55" src="https://github.com/user-attachments/assets/687716bc-9e27-4498-a3bc-29fbc138608f" />

Notes: I took care to notice that updates without WHERE clauses affected every row in the table and that destructive changes required caution.

---

## Task 4 — Delete rows from a table

I practiced deleting rows and observed the irreversible effect without backups.

1. To delete all rows from the `country` table, I disabled foreign key checks (as shown in the lab) and executed a DELETE without a WHERE clause:

```sql
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM world.country;
```

2. I verified that the table was empty by running:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: SELECT output showing an empty table.

<img width="602" height="168" alt="Screenshot 2026-07-31 at 15 23 45" src="https://github.com/user-attachments/assets/466f3c4b-4397-4a17-b73c-76ad05a086f7" />

---

## Task 5 — Import data using an SQL file

I restored sample data from a backup SQL file to repopulate tables quickly.

1. I exited the MySQL prompt:

```sql
QUIT;
```

2. I confirmed the `world.sql` file existed on the Command Host:

```bash
ls /home/ec2-user/world.sql
```

Screenshot placeholder: ls output showing world.sql.

<img width="711" height="73" alt="Screenshot 2026-07-31 at 15 25 35" src="https://github.com/user-attachments/assets/d4171278-92a4-4579-bb8b-69799f64fe48" />

3. I imported the SQL file into MySQL to create tables and insert data:

```bash
mysql -u root --password='.....' < /home/ec2-user/world.sql
```

4. I reconnected to MySQL:

```bash
mysql -u root --password='.....'
```

5. I verified the database objects had been recreated and populated:

```sql
USE world;
SHOW TABLES;
SELECT * FROM country LIMIT 20;
SELECT * FROM city LIMIT 20;
SELECT * FROM countrylanguage LIMIT 20;
```

Screenshot placeholders: SHOW TABLES and SELECT outputs showing the repopulated tables.

<img width="817" height="356" alt="Screenshot 2026-07-31 at 15 33 29" src="https://github.com/user-attachments/assets/df6bd3f7-effc-4503-964e-951f49920c7b" />



<img width="1585" height="875" alt="Screenshot 2026-07-31 at 15 34 25" src="https://github.com/user-attachments/assets/1340b177-c21f-4a62-8263-5d23fb12c2ec" />

---

## Lessons learned and notes

- The lab reinforced the core DML operations: INSERT, UPDATE, DELETE and the importance of careful use of WHERE clauses.
- I learned how to import a dataset from a SQL file to quickly restore or populate tables.
- I verified that destructive operations (DELETE) were final unless backups existed, and therefore backups or scripts to restore data were important.


---

## Conclusion

I completed the lab by inserting sample rows into the `country` table, updating values across rows, deleting all rows, and importing a SQL backup file to restore the dataset. The exercise reinforced the practical implications of DML statements and the need for caution when performing updates and deletes on production data.
