# Organizing data — Documentation Journey

This document described the hands‑on journey I had completed for the "Organizing data" lab. It was written in past tense and included placeholders for screenshots of the most important steps.

---

## Overview

The lab demonstrated how I had grouped and analyzed records in the `world` database using GROUP BY and windowing (OVER) clauses. The objectives that were achieved during the lab included:

- Using the GROUP BY clause with the aggregate function SUM().
- Using the OVER clause with the RANK() window function.
- Using the OVER clause with the aggregate function SUM() and the RANK() window function.

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

## Task 2 — Queried and grouped records

I inspected the `country` table and ran grouping and windowing queries to organize data for analysis.

1. I reviewed the table content and schema to understand available fields:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: Initial SELECT * output for `world.country`.

![Screenshot: SELECT * FROM world.country](screenshots/select-all-country.png)

2. I returned records for the Region "Australia and New Zealand" ordered by population (descending) to observe the distribution:

```sql
SELECT Region, Name, Population
FROM world.country
WHERE Region = 'Australia and New Zealand'
ORDER BY Population DESC;
```

Screenshot placeholder: SELECT for Australia and New Zealand ordered by population.

![Screenshot: SELECT region australia and new zealand](screenshots/select-region-australia.png)

3. I used GROUP BY with SUM() to compute the total population for the Australia and New Zealand region:

```sql
SELECT Region, SUM(Population) AS "Total Population"
FROM world.country
WHERE Region = 'Australia and New Zealand'
GROUP BY Region
ORDER BY SUM(Population) DESC;
```

I observed that the WHERE clause limited aggregation to only the specified region.

Screenshot placeholder: GROUP BY + SUM() result.

![Screenshot: GROUP BY SUM result](screenshots/group-by-sum.png)

4. I used a windowed SUM() with OVER() and PARTITION BY to generate a running total of population within the region. The running total showed cumulative population as rows were ordered by Population:

```sql
SELECT Region, Name, Population,
       SUM(Population) OVER (PARTITION BY Region ORDER BY Population) AS "Running Total"
FROM world.country
WHERE Region = 'Australia and New Zealand';
```

Screenshot placeholder: Running total using SUM() OVER(PARTITION BY ...).

![Screenshot: Running total OVER result](screenshots/running-total-over.png)

5. I combined the running total with the RANK() window function to produce a rank for each country within the region based on population:

```sql
SELECT Region, Name, Population,
       SUM(Population) OVER (PARTITION BY Region ORDER BY Population) AS "Running Total",
       RANK() OVER (PARTITION BY Region ORDER BY Population DESC) AS "Ranked"
FROM world.country
WHERE Region = 'Australia and New Zealand';
```

Screenshot placeholder: Combined SUM() OVER and RANK() OVER result.

![Screenshot: RANK and OVER result](screenshots/rank-over.png)

Notes: I changed the RANK() ordering to DESC to rank countries from largest to smallest population, which matched the challenge intent.

---

## Challenge — Rank countries in each region by population (largest to smallest)

I wrote a query to rank countries within every region by their population from largest to smallest using RANK() over a partition by Region and ordering by Population descending:

```sql
SELECT Region, Name, Population,
       RANK() OVER (PARTITION BY Region ORDER BY Population DESC) AS "RegionRank"
FROM world.country
ORDER BY Region, RegionRank;
```

Screenshot placeholder: Challenge query output showing region ranks.

![Screenshot: Challenge rank by region](screenshots/challenge-rank-by-region.png)

---

## Lessons learned and notes

- The lab reinforced how GROUP BY aggregated data into summary rows, while OVER() provided windowed calculations across row sets without collapsing rows.
- I learned that PARTITION BY limited window calculations to a logical group (for example, a region) and that ORDER BY inside OVER() defined the sequence for cumulative functions and ranking.
- I confirmed that using RANK() with ORDER BY DESC produced rankings from largest to smallest, which was useful for comparative analysis.

---

## Attachments and screenshot checklist

Please add screenshots to the following paths (or update the links after you uploaded screenshots):

- screenshots/lab-provisioning-overview.png — EC2/Console view showing the lab.
- screenshots/command-host-session.png — Session Manager connect screen.
- screenshots/mysql-connected.png — MySQL prompt after connecting.
- screenshots/show-databases.png — SHOW DATABASES output showing `world`.
- screenshots/select-all-country.png — Initial SELECT * output for the country table.
- screenshots/select-region-australia.png — SELECT results for Australia and New Zealand ordered by population.
- screenshots/group-by-sum.png — GROUP BY + SUM() result.
- screenshots/running-total-over.png — SUM() OVER running total result.
- screenshots/rank-over.png — Combined RANK() and SUM() OVER result.
- screenshots/challenge-rank-by-region.png — Challenge result ranking countries by region.

---

## Conclusion

I completed the lab by connecting to the Command Host and running queries that used GROUP BY and OVER clauses to organize and analyze population data in the `world` database. The exercise improved my ability to produce both aggregated summaries and windowed analyses that preserved row-level detail while adding useful metrics.
