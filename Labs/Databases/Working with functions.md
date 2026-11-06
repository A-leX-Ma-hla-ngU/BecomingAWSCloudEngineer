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

<img width="821" height="498" alt="Screenshot 2026-07-31 at 19 00 02" src="https://github.com/user-attachments/assets/f31beb59-cb67-484c-980b-5002c9ea12e3" />

<img width="812" height="484" alt="Screenshot 2026-07-31 at 19 00 16" src="https://github.com/user-attachments/assets/f950803b-ed6c-410f-b230-59eeaff246de" />


---

## Task 1 — Connected to the Command Host and database

I connected to the Command Host using the AWS Console and Session Manager to access the MySQL client. The steps I followed were:

1. In the AWS Management Console, I opened Services → Compute → EC2 and selected Instances.
2. I located the instance labelled "Command Host", selected it, and clicked Connect.
3. I chose the Session Manager tab and clicked Connect to open a terminal session.

Screenshot placeholder: Command Host selected in the EC2 console and Session Manager button.

<img width="826" height="438" alt="Screenshot 2026-07-31 at 17 43 40" src="https://github.com/user-attachments/assets/a8cdec4d-f1f1-4357-8c55-4008113e5d81" />

<img width="823" height="721" alt="Screenshot 2026-07-31 at 17 43 55" src="https://github.com/user-attachments/assets/99b130f5-6ba0-4d21-93ba-6568aeef0eb8" />



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
<img width="830" height="445" alt="Screenshot 2026-07-31 at 19 07 47" src="https://github.com/user-attachments/assets/a0eac4b3-d69f-4d38-8a86-157ade22b86d" />

<img width="825" height="733" alt="Screenshot 2026-07-31 at 19 07 58" src="https://github.com/user-attachments/assets/2ad15dad-2972-42aa-a5ff-af44ab9a12f4" />

6. I verified available databases with:

```sql
SHOW DATABASES;
```

Screenshot placeholder: SHOW DATABASES output highlighting the `world` database.

<img width="656" height="23" alt="Screenshot 2026-07-31 at 19 09 06" src="https://github.com/user-attachments/assets/c424553c-b835-42b8-9dd8-9497173de57a" />


---

## Task 2 — Queried the world database using functions

I explored the `country` table and used various SQL functions to summarize and manipulate data.

1. I reviewed the table contents:

```sql
SELECT * FROM world.country;
```

Screenshot placeholder: Initial SELECT * output for `world.country`.

<img width="838" height="703" alt="Screenshot 2026-07-31 at 19 10 02" src="https://github.com/user-attachments/assets/f2d68e55-dfea-444d-a266-be9d68dfd986" />

<img width="841" height="373" alt="Screenshot 2026-07-31 at 19 10 17" src="https://github.com/user-attachments/assets/e7d53436-553f-4936-8544-17085a1421c2" />




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

<img width="880" height="353" alt="Screenshot 2026-07-31 at 19 11 21" src="https://github.com/user-attachments/assets/2c217d0b-006f-44c8-a486-ef77f256a3d3" />

3. I split the Region string using SUBSTRING_INDEX() to extract the first token (before a space) and observed the results:

```sql
SELECT Region, SUBSTRING_INDEX(Region, ' ', 1)
FROM world.country;
```

Screenshot placeholder: SUBSTRING_INDEX output showing split region names.

<img width="866" height="673" alt="Screenshot 2026-07-31 at 19 15 32" src="https://github.com/user-attachments/assets/db617422-a126-4186-a56a-45c767d3dc37" />

<img width="866" height="673" alt="Screenshot 2026-07-31 at 19 15 32" src="https://github.com/user-attachments/assets/d19d72a8-c050-411f-9844-7895f3dad329" />

<img width="825" height="468" alt="Screenshot 2026-07-31 at 19 15 42" src="https://github.com/user-attachments/assets/6d873e47-5094-4ef1-be3b-92e336eb15de" />



4. I used SUBSTRING_INDEX() in a WHERE clause to filter records whose first region token equaled "Southern":

```sql
SELECT Name, Region
FROM world.country
WHERE SUBSTRING_INDEX(Region, ' ', 1) = 'Southern';
```

Screenshot placeholder: SELECT filtered by SUBSTRING_INDEX in WHERE.

<img width="869" height="264" alt="Screenshot 2026-07-31 at 19 17 24" src="https://github.com/user-attachments/assets/5c61bb0f-c4f4-4467-a4be-23283e8251fd" />

<img width="839" height="335" alt="Screenshot 2026-07-31 at 19 17 32" src="https://github.com/user-attachments/assets/882bf883-9243-4db4-b34c-578edd5c46c8" />


5. I measured string lengths after trimming whitespace using LENGTH() and TRIM(), returning regions with fewer than 10 characters:

```sql
SELECT Region
FROM world.country
WHERE LENGTH(TRIM(Region)) < 10;
```

Screenshot placeholder: LENGTH(TRIM(...)) output showing short region names.

<img width="863" height="46" alt="Screenshot 2026-07-31 at 19 18 17" src="https://github.com/user-attachments/assets/bb077e61-5edc-46e1-9022-04d90fd23749" />

<img width="739" height="698" alt="Screenshot 2026-07-31 at 19 18 29" src="https://github.com/user-attachments/assets/e30daf31-f54c-40cb-9610-9e54e052edbd" />


6. I removed duplicate region names by using DISTINCT:

```sql
SELECT DISTINCT(Region)
FROM world.country
WHERE LENGTH(TRIM(Region)) < 10;
```

Screenshot placeholder: DISTINCT output for short region names.

<img width="871" height="71" alt="Screenshot 2026-07-31 at 19 18 51" src="https://github.com/user-attachments/assets/ae32fc2f-531f-41fd-868c-77c5df6cf1bc" />

<img width="882" height="291" alt="Screenshot 2026-07-31 at 19 19 00" src="https://github.com/user-attachments/assets/6286c46c-ac1b-4433-ab17-9bb8677b91f1" />


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

<img width="870" height="83" alt="Screenshot 2026-07-31 at 19 19 25" src="https://github.com/user-attachments/assets/692f7a28-cd12-4117-ba1a-cf7b4e7afe9b" />

<img width="882" height="255" alt="Screenshot 2026-07-31 at 19 19 32" src="https://github.com/user-attachments/assets/922754f4-af92-49bb-8102-9c8ac55e6b16" />

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
