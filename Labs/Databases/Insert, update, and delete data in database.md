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

![Screenshot: Lab Provisioning Overview](screenshots/lab-provisioning-overview.png)

---

## Task 1 — Connecting to the Command Host and Database

I connected to the Command Host using the AWS Console and Session Manager to access the MySQL client. The steps I followed were:

1. In the AWS Management Console, I opened Services → Compute → EC2 and selected Instances.
2. I located the instance labelled "Command Host", selected it, and clicked Connect.
3. I chose the Session Manager tab and clicked Connect to open a terminal session.

Screenshot placeholder: Command Host selected in the EC2 console and Session Manager button.

![Screenshot: Command Host Session Manager](screenshots/command-host-session.png)

4. In the terminal, I prepared the environment by switching to the root user and moving to the ec2-user home directory:

```bash
sudo su
cd /home/ec2-user/
```

5. I connected to the database instance using the MySQL client with the provided credentials:

```bash
mysql -u root --password='re:St@rt!9'
```

Screenshot placeholder: Active MySQL prompt after successful connection.

![Screenshot: MySQL prompt connected](screenshots/mysql-connected.png)

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

![Screenshot: Initial SELECT all countries](screenshots/select-all-initial.png)

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

![Screenshot: SELECT inserted rows](screenshots/select-inserted-rows.png)

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

![Screenshot: SELECT after population update](screenshots/select-after-population-update.png)

3. I updated both `Population` and `SurfaceArea` columns for all rows:

```sql
UPDATE world.country SET Population = 100, SurfaceArea = 100;
```

4. I verified the changes again with:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: SELECT output after population and surface area updates.

![Screenshot: SELECT after population and surface updates](screenshots/select-after-multiple-updates.png)

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

![Screenshot: SELECT after delete all rows](screenshots/select-after-delete.png)

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

![Screenshot: ls world.sql file](screenshots/ls-world-sql.png)

3. I imported the SQL file into MySQL to create tables and insert data:

```bash
mysql -u root --password='re:St@rt!9' < /home/ec2-user/world.sql
```

4. I reconnected to MySQL:

```bash
mysql -u root --password='re:St@rt!9'
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

![Screenshot: SHOW TABLES after import](screenshots/show-tables-after-import.png)

![Screenshot: SELECT country after import](screenshots/select-country-after-import.png)

---

## Lessons learned and notes

- The lab reinforced the core DML operations: INSERT, UPDATE, DELETE and the importance of careful use of WHERE clauses.
- I learned how to import a dataset from a SQL file to quickly restore or populate tables.
- I verified that destructive operations (DELETE) were final unless backups existed, and therefore backups or scripts to restore data were important.

---

## Attachments and screenshot checklist

Please add screenshots to the following files/paths in the repository or update the links after uploading screenshots:

- screenshots/lab-provisioning-overview.png — EC2/Console view showing the lab provisioning.
- screenshots/command-host-session.png — Session Manager connect screen.
- screenshots/mysql-connected.png — MySQL prompt after connecting.
- screenshots/select-all-initial.png — Initial SELECT * output for country.
- screenshots/select-inserted-rows.png — Output showing inserted IRL and AUS rows.
- screenshots/select-after-population-update.png — Output after setting Population = 0.
- screenshots/select-after-multiple-updates.png — Output after updating Population and SurfaceArea.
- screenshots/select-after-delete.png — Output showing empty country table.
- screenshots/ls-world-sql.png — Output showing /home/ec2-user/world.sql file.
- screenshots/show-tables-after-import.png — SHOW TABLES output after import.
- screenshots/select-country-after-import.png — SELECT output after import showing multiple rows.

---

## Conclusion

I completed the lab by inserting sample rows into the `country` table, updating values across rows, deleting all rows, and importing a SQL backup file to restore the dataset. The exercise reinforced the practical implications of DML statements and the need for caution when performing updates and deletes on production data.
