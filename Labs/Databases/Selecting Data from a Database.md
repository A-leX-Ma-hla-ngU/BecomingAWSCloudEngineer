# Selecting Data from a Database — Documentation Journey

This document recorded my hands-on work in the **Selecting Data from a Database** lab. I connected to the provided Command Host and queried the `world` database using `SELECT`, `COUNT()`, column aliases, comparison operators, `WHERE`, `AND`, and `ORDER BY`.

---

## Overview

The lab demonstrated how I could retrieve and filter relational data with SQL. The database contained `city`, `country`, and `countrylanguage` tables. The sample data was based on Statistics Finland, general regional statistics, dated February 4, 2022.

The lab required approximately 45 minutes.

By completing the lab, I had:

- Used `SELECT` to query a database.
- Used `COUNT()` to count table rows.
- Inspected a table's columns.
- Selected specific columns and renamed an output column with `AS`.
- Sorted query results with `ORDER BY` in ascending and descending order.
- Filtered results using `WHERE`, `<`, `>`, `=`, and `AND`.

---

## Resources provided

The lab environment had included:

- An EC2 instance named **Command Host** with a database client.
- A relational database with a `world` database and its `city`, `country`, and `countrylanguage` tables.
- A configured database login for the lab.

**Screenshot placeholder:** Lab environment showing the Command Host instance and database resources.

<img width="969" height="544" alt="Screenshot 2026-07-31 at 16 07 40" src="https://github.com/user-attachments/assets/5724128a-f378-45f8-b383-7e60649b9c7b" />

<img width="970" height="541" alt="Screenshot 2026-07-31 at 16 09 20" src="https://github.com/user-attachments/assets/73659a19-e53c-4985-9c9f-1fa0ea03efa8" />


---

## Task 1 — Connected to the Command Host

I opened the AWS Management Console and navigated to **EC2 → Instances**. I selected the **Command Host** instance, chose **Connect**, opened the **Session Manager** tab, and connected to a terminal session.

I prepared the shell environment and opened the MySQL client using the lab-provided credentials. I kept passwords and other credentials out of screenshots and documentation.

```bash
sudo su
cd /home/ec2-user/
mysql -u root --password='<lab-provided-password>'
```

**Screenshot placeholder:** Command Host instance selected in the EC2 console and Session Manager connection.

<img width="633" height="470" alt="Screenshot 2026-07-31 at 16 15 46" src="https://github.com/user-attachments/assets/091a1a97-b0a4-4830-9a52-6db04f5f341c" />

<img width="920" height="736" alt="Screenshot 2026-07-31 at 16 20 39" src="https://github.com/user-attachments/assets/270304ee-97bd-4cc9-984e-b1fb6576e059" />


**Screenshot placeholder:** Successful MySQL connection at the prompt. No password should be visible.

<img width="850" height="216" alt="Screenshot 2026-07-31 at 16 23 47" src="https://github.com/user-attachments/assets/df207869-2478-4207-9803-692a5205bd1a" />


---

## Task 2 — Queried the `world` database

### Verified the database and inspected the country table

I listed the available databases and confirmed that `world` was present. I then retrieved all rows and columns in the `country` table, counted its rows, and checked its schema.

```sql
SHOW DATABASES;

SELECT * FROM world.country;

SELECT COUNT(*) FROM world.country;

SHOW COLUMNS FROM world.country;
```

**Screenshot placeholder:** `SHOW DATABASES;` output showing the `world` database.

<img width="611" height="290" alt="Screenshot 2026-07-31 at 16 24 10" src="https://github.com/user-attachments/assets/8a2416de-aee0-4566-9c66-77c3e843b837" />


**Screenshot placeholder:** Query results for <img width="620" height="61" alt="Screenshot 2026-07-31 at 16 24 36" src="https://github.com/user-attachments/assets/c01f682d-d3db-4b79-b70d-4b6df8eb0fed" /> 
<img width="1099" height="890" alt="Screenshot 2026-07-31 at 16 24 53" src="https://github.com/user-attachments/assets/c9e3755b-9299-48b2-947d-d97d8163037b" />

and <img width="745" height="222" alt="Screenshot 2026-07-31 at 16 28 04" src="https://github.com/user-attachments/assets/5a6c0aed-37eb-40f6-8b00-fc0ef3ce8153" />

**Screenshot placeholder:** <img width="631" height="46" alt="Screenshot 2026-07-31 at 16 28 22" src="https://github.com/user-attachments/assets/f5bd0361-7700-4f1a-b05d-0d8d4d5030e3" /> output showing the table schema.

<img width="963" height="695" alt="Screenshot 2026-07-31 at 16 28 38" src="https://github.com/user-attachments/assets/68fbbcc5-af1c-4501-90ea-f1e4e1a9e608" />

<img width="1064" height="886" alt="Screenshot 2026-07-31 at 16 28 45" src="https://github.com/user-attachments/assets/40040b5e-4ce6-4b01-9165-12d353e0c607" />

### Selected and aliased columns

I selected the country name, capital, region, surface area, and population. I used `AS` to display the `SurfaceArea` column under the more readable heading `Surface Area`.

```sql
SELECT Name, Capital, Region, SurfaceArea, Population
FROM world.country;

SELECT Name, Capital, Region, SurfaceArea AS "Surface Area", Population
FROM world.country;
```

**Screenshot placeholder:** Selected country columns with the `Surface Area` alias visible.

<img width="936" height="48" alt="Screenshot 2026-07-31 at 16 29 24" src="https://github.com/user-attachments/assets/a8fb277c-77b2-40ac-a976-e7b4ea865981" />

<img width="937" height="707" alt="Screenshot 2026-07-31 at 16 32 55" src="https://github.com/user-attachments/assets/15ac185d-26db-4624-bb26-faa315fd6d71" />

<img width="939" height="705" alt="Screenshot 2026-07-31 at 16 32 23" src="https://github.com/user-attachments/assets/cfc9f7ce-e2ee-42e1-b0fb-c63311e239ac" />


### Sorted query results

I used `ORDER BY Population` to sort the results in ascending order, which was the default. I then added `DESC` to sort the countries from highest population to lowest.

```sql
SELECT Name, Capital, Region, SurfaceArea AS "Surface Area", Population
FROM world.country
ORDER BY Population;

SELECT Name, Capital, Region, SurfaceArea AS "Surface Area", Population
FROM world.country
ORDER BY Population DESC;
```

**Screenshot placeholder:** Country results ordered by population in ascending and descending order.

<img width="836" height="714" alt="Screenshot 2026-07-31 at 16 41 12" src="https://github.com/user-attachments/assets/dd4670e5-2f40-48b1-aa28-94b4ab8f5356" />

<img width="841" height="698" alt="Screenshot 2026-07-31 at 16 41 35" src="https://github.com/user-attachments/assets/53e44566-cdad-4ae0-8816-41769b24ba7b" />

<img width="831" height="57" alt="Screenshot 2026-07-31 at 16 42 07" src="https://github.com/user-attachments/assets/ebd05f57-dc29-43d1-a81c-bfb8b6d743c4" />

<img width="838" height="714" alt="Screenshot 2026-07-31 at 16 42 32" src="https://github.com/user-attachments/assets/e3a3a18f-8471-48a8-bb0e-5ac8d190c1f5" />

<img width="840" height="716" alt="Screenshot 2026-07-31 at 16 42 44" src="https://github.com/user-attachments/assets/be1be630-9dbe-4dc1-8925-50c14371d663" />



### Filtered rows with comparison operators and `AND`

I used a `WHERE` condition to find countries with a population greater than 50,000,000, then ordered the results in descending order. After that, I used `AND` to restrict the results to countries with a population greater than 50,000,000 and less than 100,000,000.

```sql
SELECT Name, Capital, Region, SurfaceArea AS "Surface Area", Population
FROM world.country
WHERE Population > 50000000
ORDER BY Population DESC;

SELECT Name, Capital, Region, SurfaceArea AS "Surface Area", Population
FROM world.country
WHERE Population > 50000000
  AND Population < 100000000
ORDER BY Population DESC;
```

**Screenshot placeholder:** Filtered country results for populations over 50 million and the restricted range query.

<img width="838" height="73" alt="Screenshot 2026-07-31 at 16 44 13" src="https://github.com/user-attachments/assets/e68971fe-4ff0-4c2f-ace2-2b02bf34bbed" />

<img width="841" height="700" alt="Screenshot 2026-07-31 at 16 44 25" src="https://github.com/user-attachments/assets/0ca3f43b-25f6-48d9-b46c-9dcfbccc11ac" />

<img width="842" height="619" alt="Screenshot 2026-07-31 at 16 44 33" src="https://github.com/user-attachments/assets/ddc72748-3659-4b5e-bad1-5c1e3fea428b" />

<img width="828" height="72" alt="Screenshot 2026-07-31 at 16 47 34" src="https://github.com/user-attachments/assets/28138dbb-bec3-4f88-baf0-e24c787160bd" />

<img width="1102" height="890" alt="Screenshot 2026-07-31 at 16 47 52" src="https://github.com/user-attachments/assets/21737d09-258a-487d-9197-429e1a0f85b9" />



---

## Challenge — Southern Europe country over 50 million

I queried the country table for countries in Southern Europe with a population greater than 50,000,000. The result identified **Italy**.

```sql
SELECT Name, Region, Population
FROM world.country
WHERE Region = 'Southern Europe'
  AND Population > 50000000;
```

**Screenshot placeholder:** Challenge query showing Italy as the matching country.

<img width="843" height="277" alt="Screenshot 2026-07-31 at 16 51 06" src="https://github.com/user-attachments/assets/f3fc333f-de03-42b6-b2e1-8e8ba070ea97" />



---

## Key takeaways

- `SELECT` returned all columns with `*` or only the columns I named.
- `COUNT(*)` returned the number of rows in a table.
- `AS` made a result heading more descriptive without changing the table schema.
- `ORDER BY` sorted results ascending by default, while `DESC` reversed the order.
- `WHERE` filtered rows, and comparison operators such as `>` and `<` expressed numeric conditions.
- `AND` required both conditions to be true.

---

## Screenshot checklist

The following screenshot placeholders were included for the lab record:

- `screenshots/database-lab-overview.png` — Lab resources and Command Host.
- `screenshots/command-host-session.png` — Session Manager connection.
- `screenshots/mysql-connected.png` — MySQL prompt after connecting.
- `screenshots/show-databases.png` — Database list showing `world`.
- `screenshots/country-table-and-count.png` — Country data and row count.
- `screenshots/country-columns.png` — Country table schema.
- `screenshots/select-columns-alias.png` — Selected columns and alias.
- `screenshots/order-by-population.png` — Ascending and descending sort output.
- `screenshots/where-and-population-results.png` — Population filters using `WHERE` and `AND`.
- `screenshots/southern-europe-challenge.png` — Challenge result showing Italy.

---

## Conclusion

I completed the lab by connecting to the Command Host, confirming the `world` database was available, and querying the `country` table with SQL. I counted rows, inspected columns, selected and aliased fields, sorted data, applied comparison conditions, and used `AND` to answer the Southern Europe challenge.
