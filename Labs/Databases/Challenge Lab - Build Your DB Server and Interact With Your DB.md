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

> **Screenshot placeholder — RDS instance configuration:**
<img width="837" height="732" alt="Screenshot 2026-08-04 at 15 26 54" src="https://github.com/user-attachments/assets/042f69ef-da47-400f-a6f8-26f28bf54b79" />

<img width="822" height="646" alt="Screenshot 2026-08-04 at 15 27 18" src="https://github.com/user-attachments/assets/5ae39bfc-939c-49ce-8994-ef58f0006257" />

<img width="730" height="405" alt="Screenshot 2026-08-04 at 15 33 20" src="https://github.com/user-attachments/assets/a406f354-3556-47ba-9818-649a61f9ebd6" />

<img width="814" height="642" alt="Screenshot 2026-08-04 at 15 37 37" src="https://github.com/user-attachments/assets/e72da1eb-5270-49d7-9eee-9514d33f0322" />

<img width="771" height="633" alt="Screenshot 2026-08-04 at 15 41 34" src="https://github.com/user-attachments/assets/2a573046-34ea-4c21-b6ef-36744abe65fb" />

<img width="814" height="381" alt="Screenshot 2026-08-04 at 15 44 51" src="https://github.com/user-attachments/assets/40d78413-57ce-4996-9d1c-24b5b34588da" />

<img width="820" height="458" alt="Screenshot 2026-08-04 at 15 45 10" src="https://github.com/user-attachments/assets/427fccc8-84c3-4d29-9681-a54c47d2d096" />

<img width="821" height="458" alt="Screenshot 2026-08-04 at 15 48 34" src="https://github.com/user-attachments/assets/32dee5cf-da19-4799-a0f7-fae2b2151adf" />

<img width="832" height="693" alt="Screenshot 2026-08-04 at 15 49 01" src="https://github.com/user-attachments/assets/45039cd1-52c9-47ee-bd60-4682f8a6fb45" />

<img width="818" height="575" alt="Screenshot 2026-08-04 at 15 53 20" src="https://github.com/user-attachments/assets/4f48c2a3-9237-4988-b8c6-2c16ddebcfd5" />

<img width="822" height="540" alt="Screenshot 2026-08-04 at 15 56 54" src="https://github.com/user-attachments/assets/8e3c004b-b604-485b-8d23-86273dcc0955" />



> **Screenshot placeholder — RDS instance available:**
<img width="827" height="564" alt="Screenshot 2026-08-05 at 13 15 11" src="https://github.com/user-attachments/assets/1adf7e69-2742-4930-9f5b-93dc7307c810" />

<img width="824" height="609" alt="Screenshot 2026-08-05 at 14 52 38" src="https://github.com/user-attachments/assets/c5030a36-d937-43a0-a004-c4fab284e205" />

<img width="1669" height="744" alt="Screenshot 2026-08-05 at 15 21 42" src="https://github.com/user-attachments/assets/ec6a7c40-dc12-4984-8892-74490239e57b" />

>
> **Screenshot placeholder — Lab connection details:** <img width="421" height="83" alt="Screenshot 2026-08-04 at 17 06 20" src="https://github.com/user-attachments/assets/aa9352d9-c585-42e0-a58c-e8a6c962a3d0" />
## Task 2: Connected to the database

After connecting to the LinuxServer, I installed a MySQL-compatible client if one was not already available. I used the database endpoint, username, and password from the lab to connect to the RDS database. I kept the password out of shell history and screenshots where possible.

> **Screenshot placeholder — Client installation and database connection:**

<img width="739" height="401" alt="Screenshot 2026-11-09 at 16 51 40" src="https://github.com/user-attachments/assets/c0a8f0ed-0bec-41fc-9e69-e65ef7d9c074" />

<img width="736" height="460" alt="Screenshot 2026-11-09 at 16 57 14" src="https://github.com/user-attachments/assets/3fb99954-4f77-4efd-8198-f83bbb9ecf7a" />

<img width="735" height="73" alt="Screenshot 2026-11-09 at 16 57 33" src="https://github.com/user-attachments/assets/63977b34-bed3-46cf-ab75-52e05a453979" />

<img width="736" height="235" alt="Screenshot 2026-11-09 at 17 05 16" src="https://github.com/user-attachments/assets/cfb15231-5ceb-4dd2-b54a-8a677d0d3c53" />


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

> **Screenshot placeholder — `RESTART` table creation:**
<img width="714" height="244" alt="Screenshot 2026-11-09 at 17 08 39" src="https://github.com/user-attachments/assets/af4f2dfa-b001-42fa-b123-7c93d9bfa0fe" />
<img width="789" height="264" alt="Screenshot 2026-08-05 at 15 51 15" src="https://github.com/user-attachments/assets/35c74b3f-7f8e-4ffe-92db-483df1fb71b1" />


> **Screenshot placeholder — `RESTART` sample data:**
<img width="734" height="169" alt="Screenshot 2026-11-09 at 17 12 52" src="https://github.com/user-attachments/assets/0a9baeaf-cf4f-46e2-995d-5e103289db26" />
>
> **Screenshot placeholder — `RESTART` query:**
<img width="706" height="269" alt="Screenshot 2026-11-09 at 17 13 10" src="https://github.com/user-attachments/assets/3f47fe0e-518f-4a5d-9cb9-2bddfafd0d50" />

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

> **Screenshot placeholder — `CLOUD_PRACTITIONER` table creation:**
<img width="714" height="95" alt="Screenshot 2026-11-09 at 17 11 24" src="https://github.com/user-attachments/assets/5846d6c2-6387-4ac2-bfe2-2e43211d53bb" />

<img width="640" height="207" alt="Screenshot 2026-11-09 at 17 11 45" src="https://github.com/user-attachments/assets/e589aab2-48e1-4161-823a-fbaa1544d3ae" />

> **Screenshot placeholder — `CLOUD_PRACTITIONER`
<img width="734" height="169" alt="Screenshot 2026-11-09 at 17 12 52" src="https://github.com/user-attachments/assets/9eb15d2d-34c9-4436-8883-b039d1a0d31a" />

> **Screenshot placeholder — `CLOUD_PRACTITIONER` query:**
<img width="706" height="269" alt="Screenshot 2026-11-09 at 17 13 10" src="https://github.com/user-attachments/assets/9b861710-25b8-42a5-a834-4105129da360" />

## Task 5: Joined the tables

I performed an inner join on `student_id` and displayed the student ID, student name, and certification date:

```sql
SELECT
    RESTART.student_id,
    RESTART.student_name,
    CLOUD_PRACTITIONER.certification_date
FROM RESTART
INNER JOIN CLOUD_PRACTITIONER 
    ON RESTART.student_id = CLOUD_PRACTIONER.student_id;
```

The result contained the students who had matching records in both tables.

> **Screenshot placeholder — Inner join results:**
<img width="645" height="382" alt="Screenshot 2026-11-09 at 17 14 20" src="https://github.com/user-attachments/assets/6647ae4c-9498-4a1d-9588-19a04ca355be" />

## Lab completion

I completed the challenge by provisioning an RDS database, connecting from the LinuxServer, creating and populating both tables, verifying their contents, and joining the records. I captured the requested screenshots and kept credentials and private keys out of the documentation.

> **Cleanup reminder:** After completing the activity, I ended the lab as instructed and removed or stopped lab resources when applicable to avoid unnecessary charges.
