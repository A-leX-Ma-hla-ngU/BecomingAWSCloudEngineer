# Performing a conditional search — Documentation Journey

This document described the hands‑on journey I had completed for the "Performing a conditional search" lab. It was written in past tense and included placeholders for screenshots of the most important steps.

---

## Overview

The lab demonstrated how to use conditional searches with the SELECT statement and WHERE clause against a provisioned `world` database. The objectives that were achieved during the lab included:

- Writing search conditions with the WHERE clause.
- Using the BETWEEN operator for range queries.
- Using the LIKE operator with wildcard characters for pattern searches.
- Using the AS operator to create column aliases.
- Using functions in SELECT statements and WHERE clauses (for example, SUM and LOWER).

Sample data used in the exercises was taken from Statistics Finland (General regional statistics, 2022-02-04). The lab duration was approximately 45 minutes.

---

## Preconditions and Resources

Before I began, the following resources had been provided:

- An EC2 instance (the Command Host) with a database client (MySQL client) installed.
- A relational database instance containing a `world` database with three tables: `city`, `country`, and `countrylanguage`.
- A configured root password for the MySQL instance for lab access.

Placeholder screenshot:

![Screenshot: Lab provisioning overview](screenshots/lab-provisioning-overview.png)

---

## Task 1 — Connected to the Command Host and Database

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

## Task 2 — Queried the world database with conditional searches

I explored the `country` table and used various conditional queries to filter results.

1. I reviewed the table schema and data to understand the available columns:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: Initial SELECT * output for `world.country`.

![Screenshot: SELECT * FROM world.country](screenshots/select-all-country.png)

2. I filtered records using a range condition with the >= and <= operators to find countries with population between 50,000,000 and 100,000,000:

```sql
SELECT Name, Capital, Region, SurfaceArea, Population
FROM world.country
WHERE Population >= 50000000 AND Population <= 100000000;
```

3. I repeated the same query using the BETWEEN operator (which was inclusive) to make the query easier to read:

```sql
SELECT Name, Capital, Region, SurfaceArea, Population
FROM world.country
WHERE Population BETWEEN 50000000 AND 100000000;
```

Screenshot placeholder: SELECT using BETWEEN output.

![Screenshot: SELECT with BETWEEN](screenshots/select-range-between.png)

4. I used the LIKE operator with wildcards and the SUM aggregate to calculate the total population for the Region values that contained the string "Europe":

```sql
SELECT SUM(Population)
FROM world.country
WHERE Region LIKE "%Europe%";
```

5. I added a column alias to the result for clarity using AS:

```sql
SELECT SUM(Population) AS "Europe Population Total"
FROM world.country
WHERE Region LIKE "%Europe%";
```

Screenshot placeholder: SUM population for Europe with alias.

![Screenshot: SUM Europe Population result](screenshots/sum-europe.png)

6. To handle case sensitivity issues in string matching, I used the LOWER function in the WHERE clause to search for regions containing the text "central" (case-insensitive):

```sql
SELECT Name, Capital, Region, SurfaceArea, Population
FROM world.country
WHERE LOWER(Region) LIKE "%central%";
```

Screenshot placeholder: SELECT using LOWER(...) and LIKE output.

![Screenshot: LOWER and LIKE result](screenshots/lower-region-like-central.png)

Notes: I observed that SQL keywords were not case sensitive, but string comparisons could be depending on collation; using functions such as LOWER made comparisons reliable regardless of case.

---

## Challenge — Aggregation for North America

I wrote a query to return the sum of the surface area and the sum of the population for North America to practice aggregation with a WHERE condition. First, I examined the `Region` values in the table, then executed:

```sql
SELECT SUM(SurfaceArea) AS "N. America Surface Area",
       SUM(Population) AS "N. America Population"
FROM world.country
WHERE Region = "North America";
```

Screenshot placeholder: Challenge query result showing aggregated surface area and population for North America.

![Screenshot: Challenge result - North America aggregates](screenshots/challenge-result.png)

---

## Lessons learned and notes

- The lab reinforced conditional searches using WHERE, BETWEEN, and LIKE and the use of aggregate functions such as SUM.
- I learned to use column aliases to make results more readable and to use functions (LOWER) to perform reliable case-insensitive searches.
- I validated that careful inspection of the data and schema helped me choose the correct columns and operators for each query.

---

## Attachments and screenshot checklist

Please add screenshots to the following files/paths in the repository (or update these links after you uploaded screenshots):

- screenshots/lab-provisioning-overview.png — EC2/Console view showing the lab.
- screenshots/command-host-session.png — Session Manager connect screen.
- screenshots/mysql-connected.png — MySQL prompt after connecting.
- screenshots/show-databases.png — SHOW DATABASES output showing `world`.
- screenshots/select-all-country.png — Initial SELECT * output for the country table.
- screenshots/select-range-between.png — Output for the BETWEEN query.
- screenshots/sum-europe.png — SUM(Population) for Europe with alias.
- screenshots/lower-region-like-central.png — Output for LOWER(...) LIKE "%central%".
- screenshots/challenge-result.png — Aggregation result for North America.

---

## Conclusion

I completed the lab by connecting to the Command Host and executing multiple conditional searches on the `world.country` table. I used range queries, BETWEEN, LIKE with wildcards, column aliases, and functions in SELECT and WHERE clauses to filter and aggregate records. The exercise improved my ability to construct conditional queries to extract meaningful subsets of data from a relational database.
