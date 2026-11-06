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

<img width="1156" height="607" alt="Screenshot 2026-08-03 at 12 19 08" src="https://github.com/user-attachments/assets/397d55d9-0574-430d-968f-3fc852f7153c" />

<img width="1003" height="562" alt="Screenshot 2026-08-03 at 12 19 28" src="https://github.com/user-attachments/assets/4b77c9d5-cd0e-41fa-bacc-c3036790d61d" />



---

## Task 1 — Connected to the Command Host and database

I connected to the Command Host using the AWS Console and Session Manager to access the MySQL client. The steps I followed were:

1. In the AWS Management Console, I opened Services → Compute → EC2 and selected Instances.
2. I located the instance labelled "Command Host", selected it, and clicked Connect.
3. I chose the Session Manager tab and clicked Connect to open a terminal session.

Screenshot placeholder: Command Host selected in the EC2 console and Session Manager button.

<img width="796" height="198" alt="Screenshot 2026-08-03 at 12 24 21" src="https://github.com/user-attachments/assets/c42d8137-7e87-40a8-9243-ec9ba9d54e71" />

<img width="801" height="697" alt="Screenshot 2026-08-03 at 12 24 32" src="https://github.com/user-attachments/assets/b0cde1b3-a502-41f2-a8e7-3c375544cfbd" />

<img width="419" height="86" alt="Screenshot 2026-08-03 at 12 25 01" src="https://github.com/user-attachments/assets/76f75ffd-3509-4d4c-9b51-368322d35d8b" />



4. In the terminal, I prepared the environment by switching to the root user and moving to the ec2-user home directory:

```bash
sudo su
cd /home/ec2-user/
```

5. I connected to the database instance using the MySQL client with the provided credentials:

```bash
mysql -u root --password='....'
```

Screenshot placeholder: Active MySQL prompt after successful connection.

<img width="841" height="219" alt="Screenshot 2026-08-03 at 12 29 31" src="https://github.com/user-attachments/assets/168cab32-7c89-41df-b1f9-b6b018f0b540" />

6. I verified available databases with:

```sql
SHOW DATABASES;
```

Screenshot placeholder: SHOW DATABASES output highlighting the `world` database.

<img width="384" height="293" alt="Screenshot 2026-08-03 at 12 30 03" src="https://github.com/user-attachments/assets/75fb6ca7-15d8-40dc-99ad-ca2d68c4d94d" />

---

## Task 2 — Queried and grouped records

I inspected the `country` table and ran grouping and windowing queries to organize data for analysis.

1. I reviewed the table content and schema to understand available fields:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: Initial SELECT * output for `world.country`.

<img width="844" height="432" alt="Screenshot 2026-08-03 at 12 32 40" src="https://github.com/user-attachments/assets/af71adfa-a69b-462c-bfbe-43921d6a6526" />

<img width="836" height="438" alt="Screenshot 2026-08-03 at 12 32 57" src="https://github.com/user-attachments/assets/02d74420-e80d-416b-b657-f4f5632daf4a" />


2. I returned records for the Region "Australia and New Zealand" ordered by population (descending) to observe the distribution:

```sql
SELECT Region, Name, Population
FROM world.country
WHERE Region = 'Australia and New Zealand'
ORDER BY Population DESC;
```

Screenshot placeholder: SELECT for Australia and New Zealand ordered by population.

<img width="823" height="57" alt="Screenshot 2026-08-03 at 12 35 39" src="https://github.com/user-attachments/assets/13fbf310-1e5f-47fd-ad3c-9fc21a2e8e8f" />

<img width="851" height="320" alt="Screenshot 2026-08-03 at 12 43 34" src="https://github.com/user-attachments/assets/d6b272a8-f8f6-4ffa-9a66-7408018e246e" />

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

<img width="827" height="545" alt="Screenshot 2026-08-03 at 12 51 34" src="https://github.com/user-attachments/assets/4f068231-ae3b-4dbb-be17-3b5562ad3326" />


<img width="820" height="78" alt="Screenshot 2026-08-03 at 12 46 00" src="https://github.com/user-attachments/assets/4a176012-6542-4acb-babf-45aa1d715268" />

<img width="838" height="266" alt="Screenshot 2026-08-03 at 12 48 47" src="https://github.com/user-attachments/assets/7d3a2f64-8ee3-47e0-8aa5-87f610f550dd" />


4. I used a windowed SUM() with OVER() and PARTITION BY to generate a running total of population within the region. The running total showed cumulative population as rows were ordered by Population:

```sql
SELECT Region, Name, Population,
       SUM(Population) OVER (PARTITION BY Region ORDER BY Population) AS "Running Total"
FROM world.country
WHERE Region = 'Australia and New Zealand';
```

Screenshot placeholder: Running total using SUM() OVER(PARTITION BY ...).

<img width="827" height="545" alt="Screenshot 2026-08-03 at 12 51 34" src="https://github.com/user-attachments/assets/0d3b4c79-1379-4743-96c3-506d7f5fd6c2" />

5. I combined the running total with the RANK() window function to produce a rank for each country within the region based on population:

```sql
SELECT Region, Name, Population,
       SUM(Population) OVER (PARTITION BY Region ORDER BY Population) AS "Running Total",
       RANK() OVER (PARTITION BY Region ORDER BY Population DESC) AS "Ranked"
FROM world.country
WHERE Region = 'Australia and New Zealand';
```

Screenshot placeholder: Combined SUM() OVER and RANK() OVER result.

<img width="834" height="567" alt="Screenshot 2026-08-03 at 12 53 02" src="https://github.com/user-attachments/assets/8d12ca1e-0738-4c6e-a2bd-f25c3327d49e" />

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

<img width="832" height="601" alt="Screenshot 2026-08-03 at 13 09 58" src="https://github.com/user-attachments/assets/3033ada4-7721-48e0-b207-9f7d1ce66414" />

<img width="836" height="707" alt="Screenshot 2026-08-03 at 13 09 35" src="https://github.com/user-attachments/assets/ad2825c2-c4bc-4b98-bf84-2ed7cf4e8a57" />

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
