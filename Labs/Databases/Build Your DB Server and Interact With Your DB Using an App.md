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

> **Screenshot placeholder — Starting architecture:**
<img width="1260" height="465" alt="Screenshot 2026-08-03 at 13 53 05" src="https://github.com/user-attachments/assets/f72ce4fc-fd4e-4efe-b617-ac20fc7a41a1" />

> **Screenshot placeholder — Completed architecture:**
<img width="1106" height="516" alt="Screenshot 2026-08-03 at 13 53 15" src="https://github.com/user-attachments/assets/f71786b6-6765-4aec-85c5-4883ed407002" />


## Task 1: Created a security group for the RDS DB instance

I created a security group that allowed the web server to reach the RDS database. I opened **VPC** in the AWS Management Console, chose **Security groups**, and selected **Create security group**. I configured it as follows:

| Setting | Value |
| --- | --- |
| Security group name | `DB Security Group` |
| Description | `Permit access from Web Security Group` |
| VPC | `Lab VPC` |

In **Inbound rules**, I added a rule with **Type** set to **MySQL/Aurora (3306)**, **Source type** set to **Custom**, and **Source** set to **Web Security Group**. This allowed inbound database traffic on port 3306 from resources associated with that web security group. I then created the security group.

> **Screenshot placeholder — DB Security Group and inbound rule:**

<img width="816" height="508" alt="Screenshot 2026-08-03 at 15 50 53" src="https://github.com/user-attachments/assets/1a5a8250-4c7f-4740-b891-952dae661822" />

<img width="819" height="532" alt="Screenshot 2026-08-03 at 16 11 50" src="https://github.com/user-attachments/assets/af715dc0-6941-416e-92fc-44aaa6a7e302" />

<img width="834" height="620" alt="Screenshot 2026-08-03 at 16 12 28" src="https://github.com/user-attachments/assets/3c440ef0-f1df-4015-8ab9-b1373a603a52" />


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

> **Screenshot placeholder — DB Subnet Group:**

<img width="814" height="644" alt="Screenshot 2026-08-03 at 16 26 29" src="https://github.com/user-attachments/assets/52c7fdeb-cd8f-45bb-8173-808a2ac9a8d5" />

<img width="828" height="329" alt="Screenshot 2026-08-03 at 16 48 59" src="https://github.com/user-attachments/assets/039ce228-9185-4de9-9192-b81995733fca" />

<img width="775" height="488" alt="Screenshot 2026-08-03 at 16 53 44" src="https://github.com/user-attachments/assets/cc3a0f2f-81b8-4c9a-ae82-885d26fc0317" />

<img width="833" height="459" alt="Screenshot 2026-08-03 at 16 55 47" src="https://github.com/user-attachments/assets/1283838d-70bb-4001-87a5-7d158409baff" />


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

For this lab, I cleared **Auto generate a password**, entered the lab's master password, and confirmed it. I left the engine version at its default, disabled Enhanced monitoring and Performance Insights, and disabled automated backups to reduce deployment time. Disabling backups was specific to this lab and was not a recommended production setting.

I created the database and waited for its status to change to **Modifying** or **Available**. The Multi-AZ deployment provisioned a primary DB instance and a standby in a different Availability Zone. After opening `lab-db`, I copied the endpoint from **Connectivity & security** and saved it for the application configuration.

**Database endpoint:** <img width="418" height="348" alt="Screenshot 2026-08-03 at 17 43 40" src="https://github.com/user-attachments/assets/3aacc9cf-a05c-490e-b101-0545a94ad3a6" />

> **Screenshot placeholder — RDS database configuration:**

<img width="815" height="494" alt="Screenshot 2026-08-03 at 17 41 56" src="https://github.com/user-attachments/assets/e31c577a-302b-42b7-a711-36b5dc2b728c" />

## Task 4: Connected the web application to the database

I copied the WebServer IP address from **AWS Details**, opened it in a browser, and selected **RDS** in the web application. I entered the database connection settings and submitted the form:

| Application field | Value |
| --- | --- |
| Endpoint | The endpoint copied from the RDS instance |
| Database | `lab` |
| Username | `main` |
| Password | The lab master password |

After submission, the application reported that it was copying information to the database. A few seconds later, the Address Book appeared. I tested it by adding, editing, and removing contacts. The application stored the data in RDS, and the Multi-AZ deployment replicated it to the standby instance.

> **Screenshot placeholder — Web application RDS configuration:**

<img width="468" height="57" alt="Screenshot 2026-08-03 at 17 46 46" src="https://github.com/user-attachments/assets/e9ff08a3-522d-4002-8370-350704b58529" />

<img width="318" height="67" alt="Screenshot 2026-08-03 at 17 48 20" src="https://github.com/user-attachments/assets/84d010a4-d4ca-44d5-a55f-35a40400dd96" />

<img width="894" height="651" alt="Screenshot 2026-08-03 at 17 51 09" src="https://github.com/user-attachments/assets/484d9d7b-896d-43be-abe9-93ee099fea31" />

<img width="854" height="437" alt="Screenshot 2026-08-03 at 17 54 32" src="https://github.com/user-attachments/assets/d78b24e5-1be9-4041-8ffb-21a71a900fe1" />

> **Screenshot placeholder — Address Book:**
<img width="834" height="333" alt="Screenshot 2026-08-03 at 17 54 54" src="https://github.com/user-attachments/assets/fbffe086-ef0e-47c2-9958-ce46e72c0dd0" />

> **Screenshot placeholder — Contact testing:**
<img width="705" height="421" alt="Screenshot 2026-08-03 at 17 56 28" src="https://github.com/user-attachments/assets/bbac8074-5daf-46b5-9156-366cdd024582" />

<img width="814" height="350" alt="Screenshot 2026-08-03 at 17 56 42" src="https://github.com/user-attachments/assets/1536ccc5-ca1e-4cfe-b027-8ed63759ddad" />

<img width="847" height="267" alt="Screenshot 2026-08-03 at 18 00 42" src="https://github.com/user-attachments/assets/de891b9a-e59a-4455-ab2b-06fd2f23ccb0" />


## Lab completion

I completed the lab by configuring a private Multi-AZ MySQL DB instance, allowing database access from the web server's security group, and verifying that the web application could use the database.

> **Cleanup reminder:** After the lab, I should remove lab resources if they were no longer needed, to avoid ongoing AWS charges. I should not reuse the example lab password outside this temporary exercise.
