# Challenge Lab: Build Your DB Server and Interact With Your DB

## Lab overview

This challenge reinforced how an AWS-managed relational database could support application and data workloads. Amazon Relational Database Service (Amazon RDS) managed routine database administration tasks and supported engines including Amazon Aurora, Oracle, Microsoft SQL Server, PostgreSQL, MySQL, and MariaDB.

I created an RDS database, connected to it from the lab LinuxServer, created and populated two tables, queried their data, and joined the tables.

## Objectives completed

- I created an RDS DB instance.
- I used a MySQL client to connect to the database and query data.
- I created and populated the `RESTART` and `CLOUD_PRACTITIONER` tables.
- I queried both tables and performed an inner join.

**Approximate duration:** 45 minutes

## Challenge requirements and lab restrictions

I used either an Amazon Aurora provisioned DB or a MySQL DB instance. The lab restrictions were:

| Setting | Allowed configuration |
| --- | --- |
| Database engine | Amazon Aurora or MySQL; Aurora Serverless was unavailable |
| Template | Dev/Test or Free tier |
| Availability and durability | No standby instance |
| DB instance class | Burstable `db.t3` classes from micro through medium |
| Storage | General Purpose SSD (`gp2`), up to 100 GB; Provisioned IOPS was unavailable |
| VPC | `Lab VPC` |
| Security group | Allowed the LinuxServer to connect to the database |
| Enhanced monitoring | Disabled for MySQL |
| Purchasing option | On-Demand |

I recorded the database credentials securely for the connection steps. I did not include passwords, private keys, or other secrets in screenshots or this document.

## Task 1: Created the RDS database

I created an RDS DB instance using an allowed engine, template, instance class, storage configuration, and the `Lab VPC`. I associated a security group that permitted database traffic from the LinuxServer. I avoided creating a standby instance and, for MySQL, disabled Enhanced monitoring.

I opened the lab details, selected **Show**, downloaded the PEM key for Linux or macOS or the PPK key for Windows, and noted the LinuxServer address. I kept the key file private and used it to connect to the LinuxServer over SSH with the connection details supplied by the lab.

> **Screenshot placeholder — RDS instance configuration:** Add a screenshot showing the engine, instance class, VPC, storage, and availability choices. Redact account identifiers and credentials.
>
> **Screenshot placeholder — RDS instance available:** Add a screenshot showing the database instance status and its associated security group.
>
> **Screenshot placeholder — Lab connection details:** Add a screenshot showing the LinuxServer address only if appropriate. Never include a private key or password.

## Task 2: Connected to the database

After connecting to the LinuxServer, I installed a MySQL-compatible client if one was not already available. I used the database endpoint, username, and password from the lab to connect to the RDS database. I kept the password out of shell history and screenshots where possible.

> **Screenshot placeholder — Client installation and database connection:** Add a screenshot showing the successful client connection and database prompt, with credentials hidden.

## Task 3: Created and queried the `RESTART` table

I created a `RESTART` table with columns for the student ID, student name, restart city, and graduation date. The exact SQL types depended on the selected database engine; for MySQL, I used an integer for the student ID, text for names and city, and a date/time type for the graduation date.

```sql
CREATE TABLE RESTART (
    student_id INT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    restart_city VARCHAR(100),
    graduation_date DATETIME,
    PRIMARY KEY (student_id)
);
```

I inserted ten sample rows using lab-appropriate, non-sensitive data. For example:

```sql
INSERT INTO RESTART (student_id, student_name, restart_city, graduation_date) VALUES
(1001, 'Student One', 'Seattle', '2025-01-15 09:00:00'),
(1002, 'Student Two', 'Portland', '2025-02-15 09:00:00'),
(1003, 'Student Three', 'Austin', '2025-03-15 09:00:00'),
(1004, 'Student Four', 'Denver', '2025-04-15 09:00:00'),
(1005, 'Student Five', 'Boston', '2025-05-15 09:00:00'),
(1006, 'Student Six', 'Chicago', '2025-06-15 09:00:00'),
(1007, 'Student Seven', 'Miami', '2025-07-15 09:00:00'),
(1008, 'Student Eight', 'Phoenix', '2025-08-15 09:00:00'),
(1009, 'Student Nine', 'Atlanta', '2025-09-15 09:00:00'),
(1010, 'Student Ten', 'Raleigh', '2025-10-15 09:00:00');
```

I selected all rows to verify the table contents:

```sql
SELECT * FROM RESTART;
```

> **Screenshot placeholder — `RESTART` table creation:** Add a screenshot showing the successful table creation or schema.
>
> **Screenshot placeholder — `RESTART` sample data:** Add a screenshot showing the insert operation and ten sample rows.
>
> **Screenshot placeholder — `RESTART` query:** Add a screenshot showing the results of `SELECT * FROM RESTART;`.

## Task 4: Created and queried the `CLOUD_PRACTITIONER` table

I created the `CLOUD_PRACTITIONER` table with a student ID and certification date. I used the same student ID values as the corresponding `RESTART` records so the tables could be joined.

```sql
CREATE TABLE CLOUD_PRACTITIONER (
    student_id INT NOT NULL,
    certification_date DATETIME,
    PRIMARY KEY (student_id),
    CONSTRAINT fk_cloud_practitioner_restart
        FOREIGN KEY (student_id) REFERENCES RESTART (student_id)
);
```

I inserted five sample certification records:

```sql
INSERT INTO CLOUD_PRACTITIONER (student_id, certification_date) VALUES
(1001, '2025-02-01 10:00:00'),
(1002, '2025-03-01 10:00:00'),
(1003, '2025-04-01 10:00:00'),
(1004, '2025-05-01 10:00:00'),
(1005, '2025-06-01 10:00:00');
```

I selected all rows to verify the five records:

```sql
SELECT * FROM CLOUD_PRACTITIONER;
```

> **Screenshot placeholder — `CLOUD_PRACTITIONER` table creation:** Add a screenshot showing the successful table creation or schema.
>
> **Screenshot placeholder — `CLOUD_PRACTITIONER` sample data:** Add a screenshot showing the five inserted certification records.
>
> **Screenshot placeholder — `CLOUD_PRACTITIONER` query:** Add a screenshot showing the results of `SELECT * FROM CLOUD_PRACTITIONER;`.

## Task 5: Joined the tables

I performed an inner join on `student_id` and displayed the student ID, student name, and certification date:

```sql
SELECT
    r.student_id,
    r.student_name,
    c.certification_date
FROM RESTART AS r
INNER JOIN CLOUD_PRACTITIONER AS c
    ON r.student_id = c.student_id;
```

The result contained the students who had matching records in both tables.

> **Screenshot placeholder — Inner join results:** Add a screenshot showing `student_id`, `student_name`, and `certification_date` in the query output.

## Lab completion

I completed the challenge by provisioning an RDS database, connecting from the LinuxServer, creating and populating both tables, verifying their contents, and joining the records. I captured the requested screenshots and kept credentials and private keys out of the documentation.

> **Cleanup reminder:** After completing the activity, I ended the lab as instructed and removed or stopped lab resources when applicable to avoid unnecessary charges.
