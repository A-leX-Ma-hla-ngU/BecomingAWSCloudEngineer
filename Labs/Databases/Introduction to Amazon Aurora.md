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
>
> **Screenshot placeholder — Aurora database created:** Add a screenshot showing the successful creation message or database status.

## Task 2: Connected to the Amazon EC2 Linux instance

I opened **EC2** > **Instances**, selected the instance named **Command Host**, and chose **Connect**. Under **Connect to instance**, I selected **Session Manager** and opened a terminal with **Connect**. If the instance or connection option was not immediately available, I waited for provisioning to finish and confirmed that I was in the lab's AWS Region.

> **Screenshot placeholder — Command Host in EC2:** Add a screenshot showing the Command Host instance, with account identifiers redacted if needed.
>
> **Screenshot placeholder — Session Manager terminal:** Add a screenshot of the connected terminal.

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
>
> **Screenshot placeholder — Successful database connection:** Add a screenshot showing the database client prompt. Do not include the password.

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
>
> **Screenshot placeholder — Records inserted:** Add a screenshot showing the successful insert results.
>
> **Screenshot placeholder — Query results:** Add a screenshot showing the two returned rows for Australia and Thailand.

## Conclusion

I completed the lab by creating an Aurora cluster, connecting to it from the Command Host EC2 instance, creating and populating a table, and querying the records. I ended the lab using **End Lab** and confirmed the action when prompted.

> **Cleanup reminder:** Lab resources could incur charges while they remained active. I ended the lab when I had finished, and I avoided reusing lab credentials outside the exercise.
