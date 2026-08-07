# Database Table operations — Documentation Journey

This document described the hands-on journey I had completed for the "Database Table operations" lab. It was written in past tense and included placeholders for screenshots of the most important steps.

---

## Overview

The lab demonstrated how to perform common relational database and table operations on a provisioned relational database instance. The objectives that were achieved during the lab included:

- Using the CREATE statement to create databases and tables.
- Using the SHOW statement to view available databases and tables.
- Using the ALTER statement to alter the structure of a table.
- Using the DROP statement to delete databases and tables.

Sample data used in the exercises was taken from Statistics Finland (general regional statistics, 2022-02-04). The lab duration was approximately 45 minutes.

---

## Preconditions and Resources

Before I began, the following resources had been provided:

- An EC2 instance (the Command Host) with a database client (MySQL client) installed.
- A relational database instance accessible from the Command Host.
- A configured root password for the MySQL instance for lab access.

Placeholder screenshot: 

![Screenshot: Lab Provisioning Overview](screenshots/lab-provisioning-overview.png)

---

## Task 1 — Connecting to the Command Host

I connected to the Command Host using the AWS Console and Session Manager. The steps I followed were:

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

5. I connected to the relational database instance using the MySQL client. The command used was:

```bash
mysql -u root --password='re:St@rt!9'
```

Note: If the Session Manager window had become unresponsive I had closed the window and reconnected, then repeated the environment setup commands above.

Screenshot placeholder: Active MySQL prompt after successful connection.

![Screenshot: MySQL prompt connected](screenshots/mysql-connected.png)

---

## Task 2 — Create a database and a table

I performed the following steps to create a database and define a table schema.

1. I listed existing databases to confirm my working instance:

```sql
SHOW DATABASES;
```

2. I created a new database named `world`:

```sql
CREATE DATABASE world;
```

3. I verified the creation by running `SHOW DATABASES;` again.

4. I created a table named `country` in the `world` database using a defined schema:

```sql
CREATE TABLE world.country (
  `Code` CHAR(3) NOT NULL DEFAULT '',
  `Name` CHAR(52) NOT NULL DEFAULT '',
  `Conitinent` enum('Asia','Europe','North America','Africa','Oceania','Antarctica','South  America') NOT NULL DEFAULT 'Asia',
  `Region` CHAR(26) NOT NULL DEFAULT '',
  `SurfaceArea` FLOAT(10,2) NOT NULL DEFAULT '0.00',
  `IndepYear` SMALLINT(6) DEFAULT NULL,
  `Population` INT(11) NOT NULL DEFAULT '0',
  `LifeExpectancy` FLOAT(3,1) DEFAULT NULL,
  `GNP` FLOAT(10,2) DEFAULT NULL,
  `GNPOld` FLOAT(10,2) DEFAULT NULL,
  `LocalName` CHAR(45) NOT NULL DEFAULT '',
  `GovernmentForm` CHAR(45) NOT NULL DEFAULT '',
  `HeadOfState` CHAR(60) DEFAULT NULL,
  `Capital` INT(11) DEFAULT NULL,
  `Code2` CHAR(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`Code`)
);
```

5. I switched into the `world` database and confirmed the table existed:

```sql
USE world;
SHOW TABLES;
```

6. I inspected the table columns and properties with:

```sql
SHOW COLUMNS FROM world.country;
```

During inspection, I observed that the `Continent` column name had been misspelled as `Conitinent` in the original CREATE statement.

Screenshot placeholder: SHOW COLUMNS output highlighting the misspelled column.

![Screenshot: SHOW COLUMNS output](screenshots/show-columns-misspelled.png)

7. I corrected the column name using ALTER TABLE:

```sql
ALTER TABLE world.country RENAME COLUMN Conitinent TO Continent;
```

8. I verified the correction by running `SHOW COLUMNS FROM world.country;` again.

Screenshot placeholder: SHOW COLUMNS output after renaming the column.

![Screenshot: SHOW COLUMNS corrected](screenshots/show-columns-corrected.png)

Challenge note: I also added a simple `city` table as a challenge exercise using the following statement:

```sql
CREATE TABLE world.city (`Name` CHAR(52), `Region` CHAR(26));
```

---

## Task 3 — Delete a database and tables

I practiced removing objects from the database as follows:

1. I removed the `city` table with:

```sql
DROP TABLE world.city;
```

2. I verified that the tables had been removed by running `SHOW TABLES;` while using the `world` database.

3. I removed the `country` table during the challenge using:

```sql
DROP TABLE world.country;
```

4. I then dropped the `world` database itself:

```sql
DROP DATABASE world;
```

5. Finally, I confirmed the database had been removed using `SHOW DATABASES;`.

Screenshot placeholder: Terminal showing DROP TABLE and DROP DATABASE commands and subsequent SHOW results.

![Screenshot: DROP operations verification](screenshots/drop-operations.png)

---

## Lessons learned and notes

- The lab reinforced common SQL DDL commands: CREATE, SHOW, ALTER, and DROP.
- I learned to always inspect the table schema immediately after creation (`SHOW COLUMNS`) so that any typographical errors in column names could be fixed early.
- I verified destructive operations carefully: once a table or database was dropped it could not be recovered unless a backup had been taken.

---

## Attachments and screenshot checklist

Please add screenshots to the following files/paths in the repository (or update these links after you uploaded screenshots):

- screenshots/lab-provisioning-overview.png — EC2/Console view showing the lab.
- screenshots/command-host-session.png — Session Manager connect screen.
- screenshots/mysql-connected.png — MySQL prompt after connecting.
- screenshots/show-columns-misspelled.png — Output of SHOW COLUMNS showing the misspelling.
- screenshots/show-columns-corrected.png — Output after the ALTER TABLE rename.
- screenshots/drop-operations.png — Verification of DROP TABLE and DROP DATABASE results.

---

## Conclusion

I completed the lab by creating a database and tables, inspecting and altering the schema, and then cleaning up by dropping the created tables and database. The exercise had improved my confidence with basic SQL DDL operations and with connecting to and managing a remote MySQL instance from an EC2 Command Host.
