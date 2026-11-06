# Introduction to Amazon Aurora

## Overview

This lab introduced Amazon Aurora and provided hands-on practice creating an Aurora database cluster, connecting to it from a pre-created Amazon EC2 Linux instance, and running SQL queries.

Aurora was a fully managed, MySQL-compatible relational database engine. Amazon RDS simplified database setup and administration, while Amazon EC2 provided resizable compute capacity for the command host used in this lab.

## Topics completed

- I created an Aurora instance.
- I connected to the pre-created Amazon EC2 instance.
- I configured the EC2 instance to connect to Aurora.
- I created a table, inserted records, and queried the Aurora database.

## Task 1: Created an Aurora instance

In the AWS Management Console, I opened **RDS** > **Databases**, selected **Create database**, and chose **Standard create**. I configured the database with these settings and left unlisted settings at their defaults:

| Setting | Value |
| --- | --- |
| Engine type | Aurora (MySQL Compatible) |
| Engine version | Default version for major version 8.0 |
| Template | Dev/Test |
| DB cluster identifier | `aurora` |
| Master username | `admin` |
| Master password | The lab password |
| DB instance class | Burstable classes, `db.t3.medium` |
| Multi-AZ deployment | Don't create an Aurora Replica |
| VPC | `LabVPC` |
| Subnet group | `dbsubnetgroup` |
| Public access | No |
| VPC security group | Existing `DBSecurityGroup` (after removing `default`) |
| Enhanced monitoring | Disabled |
| Initial database name | `world` |
| Encryption | Disabled for this lab |
| Automatic minor version upgrade | Disabled |

I created the database and waited for the cluster to finish provisioning. The lab did not require an Aurora replica or Multi-AZ deployment. I noted that production environments generally require careful availability and encryption decisions; the lab settings were not production recommendations. When the suggested add-ons dialog appeared, I closed it.

> **Screenshot placeholder — Aurora creation settings:** Add a screenshot of the configured database options. Do not show credentials.

<img width="391" height="113" alt="Screenshot 2026-08-03 at 19 12 11" src="https://github.com/user-attachments/assets/698369e3-3c50-4d97-b471-41101537282c" />

<img width="371" height="255" alt="Screenshot 2026-08-03 at 19 14 13" src="https://github.com/user-attachments/assets/0391a3b6-55b1-45f3-b30f-e6940169d910" />

<img width="422" height="332" alt="Screenshot 2026-08-03 at 19 15 03" src="https://github.com/user-attachments/assets/ef5b88b8-5e42-41d7-ad6a-6dca9b6d4e8f" />

<img width="685" height="375" alt="Screenshot 2026-08-03 at 19 18 31" src="https://github.com/user-attachments/assets/26b30caa-228c-4cf8-a02d-a9ef3158c7e8" />

<img width="734" height="547" alt="Screenshot 2026-08-03 at 19 21 52" src="https://github.com/user-attachments/assets/61f6f8e2-dcdb-47dd-bff2-c653aeb9d08d" />

<img width="710" height="534" alt="Screenshot 2026-08-03 at 19 22 22" src="https://github.com/user-attachments/assets/fb587272-be8d-48eb-9a74-7fd8fca1067c" />

<img width="713" height="252" alt="Screenshot 2026-08-03 at 19 23 02" src="https://github.com/user-attachments/assets/836a5fbc-eb82-47d0-ba29-d1a4ecb28685" />

<img width="699" height="483" alt="Screenshot 2026-08-03 at 19 23 44" src="https://github.com/user-attachments/assets/1cbe85e6-42ec-4066-a0d9-af6e6fe80139" />

<img width="700" height="296" alt="Screenshot 2026-08-03 at 19 24 04" src="https://github.com/user-attachments/assets/2fa77a5c-7c3e-46d7-ae91-bad6b7fc330e" />

<img width="671" height="275" alt="Screenshot 2026-08-03 at 19 50 59" src="https://github.com/user-attachments/assets/7d61bf31-82df-4cf1-a781-27da95372791" />

<img width="702" height="252" alt="Screenshot 2026-08-03 at 19 51 30" src="https://github.com/user-attachments/assets/ddedf89f-c58e-4c71-8c85-26ae9b49c5a5" />

<img width="686" height="408" alt="Screenshot 2026-08-03 at 19 59 06" src="https://github.com/user-attachments/assets/7d0a2efc-c8ee-4901-b15e-122868d6e91e" />

<img width="718" height="697" alt="Screenshot 2026-08-03 at 20 05 43" src="https://github.com/user-attachments/assets/f719e96f-4f6a-40aa-ba7c-72bf7e1b676a" />


> **Screenshot placeholder — Aurora database created:** Add a screenshot showing the successful creation message or database status.

<img width="707" height="601" alt="Screenshot 2026-08-03 at 20 06 51" src="https://github.com/user-attachments/assets/7e41396e-229b-4473-86bc-0b2a13f3d22d" />

<img width="725" height="612" alt="Screenshot 2026-08-03 at 20 07 30" src="https://github.com/user-attachments/assets/7387668e-9271-4e2d-8e7f-daea2be603d8" />

<img width="1297" height="368" alt="Screenshot 2026-08-03 at 20 10 25" src="https://github.com/user-attachments/assets/35dc73e9-8e21-409c-bbfb-bb2c871671ef" />

<img width="1279" height="375" alt="Screenshot 2026-08-03 at 20 10 33" src="https://github.com/user-attachments/assets/1cb260bf-1629-4c0d-9896-260d28bca7ea" />


## Task 2: Connected to the Amazon EC2 Linux instance

I opened **EC2** > **Instances**, selected the instance named **Command Host**, and chose **Connect**. Under **Connect to instance**, I selected **Session Manager** and opened a terminal with **Connect**. If the instance or connection option was not immediately available, I waited for provisioning to finish and confirmed that I was in the lab's AWS Region.

> **Screenshot placeholder — Command Host in EC2:** Add a screenshot showing the Command Host instance, with account identifiers redacted.

<img width="735" height="434" alt="Screenshot 2026-08-03 at 20 18 12" src="https://github.com/user-attachments/assets/c7937448-c736-4f79-9656-5703f69a9858" />

> **Screenshot placeholder — Session Manager terminal:** Add a screenshot of the connected terminal.

<img width="732" height="739" alt="Screenshot 2026-08-03 at 20 19 06" src="https://github.com/user-attachments/assets/3a77d5f3-400a-431e-a6c4-2b6f5105512e" />

<img width="732" height="196" alt="Screenshot 2026-08-03 at 20 19 32" src="https://github.com/user-attachments/assets/4681eccc-be25-43d9-ab0f-c65d6a5066f9" />


## Task 3: Configured the EC2 instance to connect to Aurora

In the Session Manager terminal, I installed the MariaDB client, which I used to connect to the MySQL-compatible Aurora cluster:

```bash
sudo yum install mariadb -y
```

I then opened **RDS** > **Databases**, selected `aurora`, and copied the writer cluster endpoint from **Connectivity & security**. The endpoint resembled `aurora.cluster-cabcdefghijklm.us-west-2.rds.amazonaws.com`.

Aurora's **cluster endpoint** connected to the current primary DB instance and supported read and write operations. The **reader endpoint**, when available, routed read-only connections to Aurora replicas. Because this lab created no Aurora replica, I used the writer endpoint.

I connected from the Command Host using the endpoint I had copied. I entered the lab password when prompted rather than putting it directly in the command:

```bash
mysql -u admin -p -h <writer-cluster-endpoint>
```

After entering the password, I saw the MySQL-compatible client prompt, which confirmed the connection.

> **Screenshot placeholder — Aurora writer endpoint:** Add a screenshot of the endpoint details. Keep credentials and sensitive account information out of the image.

<img width="754" height="538" alt="Screenshot 2026-08-03 at 20 25 25" src="https://github.com/user-attachments/assets/86b9aaae-05ab-4297-8c4b-1640eee4bd6e" />

<img width="723" height="355" alt="Screenshot 2026-08-03 at 20 26 37" src="https://github.com/user-attachments/assets/4afd0d86-3010-4f9f-89c2-3dd13f46d867" />

<img width="702" height="263" alt="Screenshot 2026-08-03 at 20 26 54" src="https://github.com/user-attachments/assets/e3a755a9-7bb2-4886-919d-afdd7d9c2007" />


> **Screenshot placeholder — Successful database connection:** Add a screenshot showing the database client prompt. Not included password.

<img width="781" height="73" alt="Screenshot 2026-08-03 at 20 31 17" src="https://github.com/user-attachments/assets/95f0b44d-593b-4bba-a8d4-1a2693bf9137" />

<img width="792" height="231" alt="Screenshot 2026-08-03 at 20 31 58" src="https://github.com/user-attachments/assets/a2ac94db-812b-49b9-85d3-371df4bc557b" />


## Task 4: Created a table, inserted records, and queried data

After connecting, I listed the available databases and selected `world`:

```sql
SHOW DATABASES;
USE world;
```

I created the `country` table with the following schema:

```sql
CREATE TABLE `country` (
  `Code` CHAR(3) NOT NULL DEFAULT '',
  `Name` CHAR(52) NOT NULL DEFAULT '',
  `Continent` ENUM('Asia','Europe','North America','Africa','Oceania','Antarctica','South America') NOT NULL DEFAULT 'Asia',
  `Region` CHAR(26) NOT NULL DEFAULT '',
  `SurfaceArea` FLOAT(10,2) NOT NULL DEFAULT '0.00',
  `IndepYear` SMALLINT(6) DEFAULT NULL,
  `Population` INT(11) NOT NULL DEFAULT '0',
  `LifeExpectancy` FLOAT(3,1) DEFAULT NULL,
  `GNP` FLOAT(10,2) DEFAULT NULL,
  `GNPOld` FLOAT(10,2) DEFAULT NULL,
  `LocalName` CHAR(45) NOT NULL DEFAULT '',
  `GovernmentForm` CHAR(45) NOT NULL DEFAULT '',
  `Capital` INT(11) DEFAULT NULL,
  `Code2` CHAR(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`Code`)
);
```

I inserted five country records:

```sql
INSERT INTO `country` VALUES ('GAB','Gabon','Africa','Central Africa',267668.00,1960,1226000,50.1,5493.00,5279.00,'Le Gabon','Republic',902,'GA');
INSERT INTO `country` VALUES ('IRL','Ireland','Europe','British Islands',70273.00,1921,3775100,76.8,75921.00,73132.00,'Ireland/Éire','Republic',1447,'IE');
INSERT INTO `country` VALUES ('THA','Thailand','Asia','Southeast Asia',513115.00,1350,61399000,68.6,116416.00,153907.00,'Prathet Thai','Constitutional Monarchy',3320,'TH');
INSERT INTO `country` VALUES ('CRI','Costa Rica','North America','Central America',51100.00,1821,4023000,75.8,10226.00,9757.00,'Costa Rica','Republic',584,'CR');
INSERT INTO `country` VALUES ('AUS','Australia','Oceania','Australia and New Zealand',7741220.00,1901,18886000,79.8,351182.00,392911.00,'Australia','Constitutional Monarchy, Federation',135,'AU');
```

I queried for countries whose GNP exceeded 35,000 and whose population exceeded 10,000,000:

```sql
SELECT *
FROM country
WHERE GNP > 35000 AND Population > 10000000;
```

The query returned two records: Australia and Thailand.

> **Screenshot placeholder — `country` table created:** Add a screenshot showing the successful `CREATE TABLE` result.

<img width="777" height="66" alt="Screenshot 2026-08-03 at 20 39 25" src="https://github.com/user-attachments/assets/d75a20d7-9cc5-4584-834b-b9115d1d0435" />

> **Screenshot placeholder — Records inserted:** Add a screenshot showing the successful insert results.

<img width="785" height="684" alt="Screenshot 2026-08-03 at 20 38 51" src="https://github.com/user-attachments/assets/35785486-f33c-4096-a568-1cc385927cce" />

> **Screenshot placeholder — Query results:** Add a screenshot showing the two returned rows for Australia and Thailand.

<img width="791" height="673" alt="Screenshot 2026-08-03 at 20 39 36" src="https://github.com/user-attachments/assets/1630bb4c-df1d-49d6-9859-e7408b00087f" />

## Conclusion

I completed the lab by creating an Aurora cluster, connecting to it from the Command Host EC2 instance, creating and populating a table, and querying the records. I ended the lab using **End Lab** and confirmed the action when prompted.

> **Cleanup reminder:** Lab resources could incur charges while they remained active. I ended the lab when I had finished, and I avoided reusing lab credentials outside the exercise.
