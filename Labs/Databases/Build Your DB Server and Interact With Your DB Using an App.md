# Build Your DB Server and Interact With Your DB Using an App

## Lab overview

This lab reinforced how an AWS-managed relational database could support an application. I used Amazon Relational Database Service (Amazon RDS) to provision a MySQL database with a Multi-AZ deployment, restricted database access to the web server's security group, and connected the lab web application to the database.

Amazon RDS supported several familiar database engines, including Amazon Aurora, Oracle, Microsoft SQL Server, PostgreSQL, MySQL, and MariaDB. It managed many routine database administration tasks, which let teams focus on their applications and business needs.

## Objectives completed

- I launched a highly available Amazon RDS DB instance.
- I configured the DB instance to accept connections from the web server.
- I opened the web application and interacted with data stored in the database.

**Approximate duration:** 45 minutes

## Scenario

I started with the lab's initial infrastructure and completed the lab with a web server connected to a Multi-AZ RDS database.

> **Screenshot placeholder — Starting architecture:** Add `architecture-lab1.png` here.

> **Screenshot placeholder — Completed architecture:** Add `architecture-lab2.png` here.

## Task 1: Created a security group for the RDS DB instance

I created a security group that allowed the web server to reach the RDS database. I opened **VPC** in the AWS Management Console, chose **Security groups**, and selected **Create security group**. I configured it as follows:

| Setting | Value |
| --- | --- |
| Security group name | `DB Security Group` |
| Description | `Permit access from Web Security Group` |
| VPC | `Lab VPC` |

In **Inbound rules**, I added a rule with **Type** set to **MySQL/Aurora (3306)**, **Source type** set to **Custom**, and **Source** set to **Web Security Group**. This allowed inbound database traffic on port 3306 from resources associated with that web security group. I then created the security group.

> **Screenshot placeholder — DB Security Group and inbound rule:** Add a screenshot showing the group and its MySQL/Aurora source rule.

## Task 2: Created a DB subnet group

I created a DB subnet group to identify the subnets RDS could use. Because a DB subnet group needed subnets in at least two Availability Zones, I selected the first two Availability Zones and added both private subnets.

In **Aurora and RDS** > **Subnet groups**, I selected **Create DB Subnet Group** and entered:

| Setting | Value |
| --- | --- |
| Name | `DB Subnet Group` |
| Description | `DB Subnet Group` |
| VPC | `Lab VPC` |
| Subnets | `10.0.1.0/24` (Private Subnet 1) and `10.0.3.0/24` (Private Subnet 2) |

I created the subnet group after selecting the two Availability Zones and subnets.

> **Screenshot placeholder — DB Subnet Group:** Add a screenshot showing the VPC and both private subnets.

## Task 3: Created a Multi-AZ Amazon RDS DB instance

I opened **Databases**, selected **Create database** > **Full configuration**, and configured a MySQL database with the following settings:

| Section | Setting | Value |
| --- | --- | --- |
| Engine options | Engine type | MySQL |
| Templates | Template | Dev/Test |
| Availability and durability | Deployment | Multi-AZ DB instance deployment (2 instances) |
| Settings | DB instance identifier | `lab-db` |
| Settings | Master username | `main` |
| Credentials | Management | Self managed |
| Credentials | Password authentication | Selected |
| Instance configuration | Class family and size | Burstable classes; `db.t3.medium` |
| Storage | Type | General Purpose SSD (`gp3`) |
| Storage | Allocated storage | 20 GiB |
| Connectivity | Compute resource | Don't connect to an EC2 compute resource |
| Connectivity | VPC | `Lab VPC` |
| Connectivity | DB subnet group | `DB Subnet Group` |
| Connectivity | Public access | No |
| Connectivity | VPC security group | `DB Security Group` (after removing the default group) |
| Additional configuration | Initial database name | `lab` |

For this lab, I cleared **Auto generate a password**, entered the lab's master password, and confirmed it. The lab password was `lab-password`. I left the engine version at its default, disabled Enhanced monitoring and Performance Insights, and disabled automated backups to reduce deployment time. Disabling backups was specific to this lab and was not a recommended production setting.

I created the database and waited for its status to change to **Modifying** or **Available**. The Multi-AZ deployment provisioned a primary DB instance and a standby in a different Availability Zone. After opening `lab-db`, I copied the endpoint from **Connectivity & security** (or **View connection details**) and saved it for the application configuration.

**Database endpoint:** `<paste-the-lab-db-endpoint-here>`

> **Screenshot placeholder — RDS database configuration:** Add a screenshot of the `lab-db` configuration or database details. Redact sensitive values.
>
> **Screenshot placeholder — Database endpoint:** Add a screenshot of the endpoint in **Connectivity & security**. Do not include passwords or other secrets.

## Task 4: Connected the web application to the database

I copied the WebServer IP address from **AWS Details**, opened it in a browser, and selected **RDS** in the web application. I entered the database connection settings and submitted the form:

| Application field | Value |
| --- | --- |
| Endpoint | The endpoint copied from the RDS instance |
| Database | `lab` |
| Username | `main` |
| Password | The lab master password |

After submission, the application reported that it was copying information to the database. A few seconds later, the Address Book appeared. I tested it by adding, editing, and removing contacts. The application stored the data in RDS, and the Multi-AZ deployment replicated it to the standby instance.

> **Screenshot placeholder — Web application RDS configuration:** Add a screenshot of the submitted connection form, with the password hidden.
>
> **Screenshot placeholder — Address Book:** Add a screenshot showing the Address Book after it loaded.
>
> **Screenshot placeholder — Contact testing:** Add a screenshot showing a contact after adding or editing it. Avoid displaying personal data.

## Lab completion

I completed the lab by configuring a private Multi-AZ MySQL DB instance, allowing database access from the web server's security group, and verifying that the web application could use the database.

> **Cleanup reminder:** After the lab, I should remove lab resources if they were no longer needed, to avoid ongoing AWS charges. I should not reuse the example lab password outside this temporary exercise.
