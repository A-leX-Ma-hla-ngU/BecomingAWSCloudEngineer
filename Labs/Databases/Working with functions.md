# Working with functions — Documentation Journey

This document described the hands‑on journey I had completed for the "Working with functions" lab. It was written in past tense and included placeholders for screenshots of the most important steps.

---

## Overview

The lab demonstrated how to use common SQL functions with the SELECT statement and WHERE clause against a provisioned `world` database. The objectives that were achieved during the lab included:

- Using aggregate functions SUM(), MIN(), MAX(), AVG(), and COUNT() to summarize data.
- Using SUBSTRING_INDEX() to split strings.
- Using LENGTH() and TRIM() to determine string length and clean whitespace.
- Using DISTINCT to filter duplicate records.
- Using functions in the SELECT clause and the WHERE clause.

Sample data used in the exercises was taken from Statistics Finland (General regional statistics, 2022-02-04). The lab required approximately 45 minutes to complete.

---

## Preconditions and resources

Before I began, the following resources had been provided:

- An EC2 instance (the Command Host) with a database client (MySQL client) installed.
- A relational database instance containing a `world` database with three tables: `city`, `country`, and `countrylanguage`.
- A configured root password for the MySQL instance for lab access.

Placeholder screenshot:

![Screenshot: Lab provisioning overview](screenshots/lab-provisioning-overview.png)

---

## Task 1 — Connected to the Command Host and database

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

Screenshot placeholder: SHOW DATABASES output highlighting the `world` database.

![Screenshot: SHOW DATABASES output](screenshots/show-databases.png)

---

## Task 2 — Queried the world database using functions

I explored the `country` table and used various SQL functions to summarize and manipulate data.

1. I reviewed the table contents:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: Initial SELECT * output for `world.country`.

![Screenshot: SELECT * FROM world.country](screenshots/select-all-country.png)

2. I used aggregate functions to summarize population values across all rows:

```sql
SELECT SUM(Population), AVG(Population), MAX(Population), MIN(Population), COUNT(Population)
FROM world.country;
```

- SUM() added all population values.
- AVG() returned the average population.
- MAX() returned the highest population value.
- MIN() returned the lowest population value.
- COUNT() returned the number of rows with a population value.

Screenshot placeholder: Aggregate results (SUM, AVG, MAX, MIN, COUNT).

![Screenshot: Aggregate functions result](screenshots/aggregate-functions.png)

3. I split the Region string using SUBSTRING_INDEX() to extract the first token (before a space) and observed the results:

```sql
SELECT Region, SUBSTRING_INDEX(Region, ' ', 1)
FROM world.country;
```

Screenshot placeholder: SUBSTRING_INDEX output showing split region names.

![Screenshot: SUBSTRING_INDEX result](screenshots/substring-index.png)

4. I used SUBSTRING_INDEX() in a WHERE clause to filter records whose first region token equaled "Southern":

```sql
SELECT Name, Region
FROM world.country
WHERE SUBSTRING_INDEX(Region, ' ', 1) = 'Southern';
```

Screenshot placeholder: SELECT filtered by SUBSTRING_INDEX in WHERE.

![Screenshot: SUBSTRING_INDEX WHERE result](screenshots/substring-index-where.png)

5. I measured string lengths after trimming whitespace using LENGTH() and TRIM(), returning regions with fewer than 10 characters:

```sql
SELECT Region
FROM world.country
WHERE LENGTH(TRIM(Region)) < 10;
```

Screenshot placeholder: LENGTH(TRIM(...)) output showing short region names.

![Screenshot: LENGTH TRIM result](screenshots/length-trim.png)

6. I removed duplicate region names by using DISTINCT:

```sql
SELECT DISTINCT(Region)
FROM world.country
WHERE LENGTH(TRIM(Region)) < 10;
```

Screenshot placeholder: DISTINCT output for short region names.

![Screenshot: DISTINCT result](screenshots/distinct-regions.png)

---

## Challenge — Split a compound Region value into two columns

I practiced splitting a region value that used a slash ("/") to separate two region names and produced two aliased columns. I executed:

```sql
SELECT Name,
       SUBSTRING_INDEX(Region, '/', 1) AS "Region Name 1",
       SUBSTRING_INDEX(Region, '/', -1) AS "Region Name 2"
FROM world.country
WHERE Region = 'Micronesia/Caribbean';
```

Screenshot placeholder: Challenge query output showing two region name columns.

![Screenshot: Challenge split regions](screenshots/challenge-split-regions.png)

---

## Lessons learned and notes

- The lab reinforced how to summarize data with aggregate functions and how to manipulate strings using SUBSTRING_INDEX, LENGTH, TRIM, and DISTINCT.
- I used functions both in the SELECT output and as conditions in the WHERE clause.
- I confirmed that splitting strings and trimming whitespace helped create reliable filters and clearer query outputs.

---

## Attachments and screenshot checklist

Please add screenshots to the following paths (or update the links after you uploaded screenshots):

- screenshots/lab-provisioning-overview.png — EC2/Console view showing the lab.
- screenshots/command-host-session.png — Session Manager connect screen.
- screenshots/mysql-connected.png — MySQL prompt after connecting.
- screenshots/show-databases.png — SHOW DATABASES output showing `world`.
- screenshots/select-all-country.png — Initial SELECT * output for the country table.
- screenshots/aggregate-functions.png — Aggregate functions output (SUM/AVG/MAX/MIN/COUNT).
- screenshots/substring-index.png — SUBSTRING_INDEX results.
- screenshots/substring-index-where.png — SUBSTRING_INDEX used in WHERE clause.
- screenshots/length-trim.png — LENGTH(TRIM()) results.
- screenshots/distinct-regions.png — DISTINCT output for short region names.
- screenshots/challenge-split-regions.png — Challenge result splitting Micronesia/Caribbean.

---

## Conclusion

I completed the lab by connecting to the Command Host and running queries that used aggregate and string functions to summarize and manipulate data in the `world.country` table. The exercise improved my ability to apply SQL functions in both SELECT outputs and WHERE conditions to produce more useful and precise result sets.
