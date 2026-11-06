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

<img width="806" height="536" alt="Screenshot 2026-07-31 at 17 37 02" src="https://github.com/user-attachments/assets/57efa055-e3f6-4738-8e47-35b6b9c07784" />

<img width="808" height="538" alt="Screenshot 2026-07-31 at 17 37 13" src="https://github.com/user-attachments/assets/a6f5bb1a-6431-4d14-9cc9-6993e5166f05" />


---

## Task 1 — Connected to the Command Host and Database

I connected to the Command Host using the AWS Console and Session Manager to access the MySQL client. The steps I followed were:

1. In the AWS Management Console, I opened Services → Compute → EC2 and selected Instances.
2. I located the instance labelled "Command Host", selected it, and clicked Connect.
3. I chose the Session Manager tab and clicked Connect to open a terminal session.

Screenshot placeholder: Command Host selected in the EC2 console and Session Manager button.

<img width="826" height="438" alt="Screenshot 2026-07-31 at 17 43 40" src="https://github.com/user-attachments/assets/27fa43e4-5d96-4638-8ef5-6655b0770ff8" />

<img width="823" height="721" alt="Screenshot 2026-07-31 at 17 43 55" src="https://github.com/user-attachments/assets/2372e495-3632-43ed-84ec-50dc26e1aa4f" />

<img width="835" height="445" alt="Screenshot 2026-07-31 at 17 44 12" src="https://github.com/user-attachments/assets/d1953c89-7d40-409c-89d6-edf7999f6e46" />



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

<img width="842" height="238" alt="Screenshot 2026-07-31 at 17 45 44" src="https://github.com/user-attachments/assets/6ddfddcb-6510-480d-8eab-cd8ca8381991" />

6. I verified available databases with:

```sql
SHOW DATABASES;
```

Screenshot placeholder: SHOW DATABASES output highlighting the `world` database.
<img width="752" height="268" alt="Screenshot 2026-07-31 at 17 47 08" src="https://github.com/user-attachments/assets/0f845538-f6cd-4a88-996a-0c4e98145900" />

---

## Task 2 — Queried the world database with conditional searches

I explored the `country` table and used various conditional queries to filter results.

1. I reviewed the table schema and data to understand the available columns:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: Initial SELECT * output for `world.country`.

<img width="856" height="547" alt="Screenshot 2026-07-31 at 17 49 50" src="https://github.com/user-attachments/assets/fb4edbb3-9397-41ee-b9ed-47023f34aeb4" />

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

<img width="1068" height="881" alt="Screenshot 2026-07-31 at 17 52 39" src="https://github.com/user-attachments/assets/d04896af-441a-49ff-8dd1-ca04a8b13a1e" />

<img width="1068" height="881" alt="Screenshot 2026-07-31 at 17 52 39" src="https://github.com/user-attachments/assets/231dccd6-5227-4698-9a05-9173112d2f8d" />



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

<img width="834" height="244" alt="Screenshot 2026-07-31 at 17 58 46" src="https://github.com/user-attachments/assets/a3d002d7-c87a-4012-8511-0a2de1f5649e" />

<img width="834" height="244" alt="Screenshot 2026-07-31 at 17 58 46" src="https://github.com/user-attachments/assets/41642e43-8e9c-4a0c-b63c-5c80c3a11b5f" />

<img width="834" height="244" alt="Screenshot 2026-07-31 at 17 58 46" src="https://github.com/user-attachments/assets/0627b2a3-16ae-405f-a74a-4ff1da1e0bc1" />

6. To handle case sensitivity issues in string matching, I used the LOWER function in the WHERE clause to search for regions containing the text "central" (case-insensitive):

```sql
SELECT Name, Capital, Region, SurfaceArea, Population
FROM world.country
WHERE LOWER(Region) LIKE "%central%";
```

Screenshot placeholder: SELECT using LOWER(...) and LIKE output.

<img width="828" height="60" alt="Screenshot 2026-07-31 at 18 18 22" src="https://github.com/user-attachments/assets/387d319c-125e-492b-b119-5acd715efaeb" />

<img width="836" height="236" alt="Screenshot 2026-07-31 at 18 18 31" src="https://github.com/user-attachments/assets/7816d733-ea5c-43d2-8dc5-9474da548b68" />

<img width="826" height="62" alt="Screenshot 2026-07-31 at 18 21 30" src="https://github.com/user-attachments/assets/16e229d1-db1f-403d-851f-40fb7f49ab17" />

<img width="1054" height="888" alt="Screenshot 2026-07-31 at 18 21 49" src="https://github.com/user-attachments/assets/06e51f2a-41d6-4af3-a2fb-50ff7c25e2fb" />

<img width="1019" height="480" alt="Screenshot 2026-07-31 at 18 22 00" src="https://github.com/user-attachments/assets/623eb4ee-2022-4bbb-ad8f-4b1706efe1ed" />


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

<img width="832" height="74" alt="Screenshot 2026-07-31 at 18 30 40" src="https://github.com/user-attachments/assets/1ab82198-6adf-4955-9302-d709edf4d89f" />

<img width="837" height="250" alt="Screenshot 2026-07-31 at 18 37 19" src="https://github.com/user-attachments/assets/93964f42-043e-4f0c-9877-83ea9d843fb2" />


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
