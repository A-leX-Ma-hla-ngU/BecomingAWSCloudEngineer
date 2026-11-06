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

`![Screenshot: Lab environment overview](screenshots/database-lab-overview.png)`

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

`![Screenshot: Command Host Session Manager](screenshots/command-host-session.png)`

**Screenshot placeholder:** Successful MySQL connection at the prompt. No password should be visible.

`![Screenshot: MySQL connected](screenshots/mysql-connected.png)`

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

`![Screenshot: SHOW DATABASES output](screenshots/show-databases.png)`

**Screenshot placeholder:** Query results for `SELECT * FROM world.country;` and `SELECT COUNT(*) FROM world.country;`.

`![Screenshot: Country table and row count](screenshots/country-table-and-count.png)`

**Screenshot placeholder:** `SHOW COLUMNS FROM world.country;` output showing the table schema.

`![Screenshot: Country table columns](screenshots/country-columns.png)`

### Selected and aliased columns

I selected the country name, capital, region, surface area, and population. I used `AS` to display the `SurfaceArea` column under the more readable heading `Surface Area`.

```sql
SELECT Name, Capital, Region, SurfaceArea, Population
FROM world.country;

SELECT Name, Capital, Region, SurfaceArea AS "Surface Area", Population
FROM world.country;
```

**Screenshot placeholder:** Selected country columns with the `Surface Area` alias visible.

`![Screenshot: Selected columns and alias](screenshots/select-columns-alias.png)`

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

`![Screenshot: Population sort](screenshots/order-by-population.png)`

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

`![Screenshot: WHERE and AND results](screenshots/where-and-population-results.png)`

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

`![Screenshot: Southern Europe population challenge](screenshots/southern-europe-challenge.png)`

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
