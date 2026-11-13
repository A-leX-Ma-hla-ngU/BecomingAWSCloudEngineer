# Build Your VPC and Launch a Web Server

## Lab overview

In this lab, I created a VPC and configured public and private subnets across two Availability Zones. I associated the subnets with route tables, created a security group for web traffic, and launched an EC2 instance configured as a web server.

**Approximate duration:** 45 minutes

## Objectives completed

- I created a VPC.
- I created public and private subnets.
- I configured a security group.
- I launched an EC2 web server into the VPC.

## Scenario

The customer requested a customized network with public and private subnets and an EC2 instance hosting a web server. I built the requested environment in the AWS Management Console and verified access to the web server.

> **Screenshot placeholder — Customer architecture:**
<img width="707" height="316" alt="Screenshot 2026-11-12 at 19 09 33" src="https://github.com/user-attachments/assets/6de6cdf6-e2cb-4599-b661-c23a4e7c1994" />

## Task 1: Created the VPC

In the VPC console, I chose **Create VPC** and configured **VPC and more** with these settings:

| Setting | Value |
| --- | --- |
| Name tag auto-generation | Disabled |
| VPC name | `Lab VPC` |
| IPv4 CIDR | `10.0.0.0/16` |
| IPv6 CIDR | No IPv6 CIDR block |
| Tenancy | Default |
| Availability Zones | 1 |
| Public subnets | 1 |
| Private subnets | 1 |
| Public subnet CIDR | `10.0.0.0/24` |
| Private subnet CIDR | `10.0.1.0/24` |
| NAT gateways | In 1 AZ |
| VPC endpoints | None |

I named the generated subnets and route tables as follows:

| Resource | Name |
| --- | --- |
| Public subnet | `Public Subnet 1` |
| Private subnet | `Private Subnet 1` |
| Public route table | `Public Route Table` |
| Private route table | `Private Route Table` |

I created the VPC and opened **View VPC** to verify its configuration. The wizard also created the networking components associated with the selected options, including the internet gateway and NAT gateway.

> **Screenshot placeholder — VPC wizard settings:** Add a screenshot showing the CIDR blocks, Availability Zone count, subnet count, and NAT gateway setting.
<img width="832" height="736" alt="Screenshot 2026-08-13 at 15 57 25" src="https://github.com/user-attachments/assets/aa2270b5-d724-4d72-8e74-5748a9f57651" />
<img width="698" height="592" alt="Screenshot 2026-08-13 at 16 01 55" src="https://github.com/user-attachments/assets/47637a0f-b545-420c-bbc4-adbad8771ce3" />
<img width="692" height="478" alt="Screenshot 2026-08-13 at 16 02 31" src="https://github.com/user-attachments/assets/5476fd2d-bffa-4809-b102-76d578b2c1a6" />

<img width="998" height="477" alt="Screenshot 2026-08-13 at 16 03 21" src="https://github.com/user-attachments/assets/7b83d95f-b275-4822-9757-ab55d98aca89" />
<img width="467" height="348" alt="Screenshot 2026-08-13 at 16 06 35" src="https://github.com/user-attachments/assets/72669d16-e665-48e2-a4f2-02db6093bc46" />
<img width="936" height="403" alt="Screenshot 2026-08-13 at 16 07 58" src="https://github.com/user-attachments/assets/187a3ab3-f287-42d3-8a67-303202191e4d" />


> **Screenshot placeholder — VPC created:**
<img width="844" height="792" alt="Screenshot 2026-08-13 at 16 11 47" src="https://github.com/user-attachments/assets/b5b6fbcc-e674-48f6-a0bd-9c783a670d4a" />

> **Screenshot placeholder — Initial route tables and gateways:**
<img width="1678" height="432" alt="Screenshot 2026-08-13 at 16 12 15" src="https://github.com/user-attachments/assets/fd98482f-9a38-4154-a33d-163f62108d0d" />

## Task 2: Created additional subnets

I opened **Subnets** and created two additional subnets in `Lab VPC`:

| Subnet name | Availability Zone | IPv4 CIDR |
| --- | --- | --- |
| `Public Subnet 2` | No preference | `10.0.2.0/24` |
| `Private Subnet 2` | No preference | `10.0.3.0/24` |

I selected the indicated second Availability Zone where the console presented a choice, so the subnets could support a multi-AZ layout.

> **Screenshot placeholder — Additional subnets:**
<img width="804" height="640" alt="Screenshot 2026-08-13 at 16 14 51" src="https://github.com/user-attachments/assets/19555bbe-1e07-4614-8d54-89b0a4aa902e" />
<img width="839" height="496" alt="Screenshot 2026-08-13 at 16 16 48" src="https://github.com/user-attachments/assets/61f8bb0e-3970-4374-8b8d-104c47df6013" />

<img width="826" height="699" alt="Screenshot 2026-08-13 at 16 17 49" src="https://github.com/user-attachments/assets/b6384c6d-37cd-434e-9b93-0d7828088d80" />
<img width="830" height="463" alt="Screenshot 2026-08-13 at 16 18 06" src="https://github.com/user-attachments/assets/4018a250-aab6-43ed-9428-e1194e7cfb9e" />

## Task 3: Associated the subnets with route tables

In **Route Tables**, I selected `Public Route Table`, opened **Subnet associations**, and associated `Public Subnet 2`. I then selected `Private Route Table` and associated `Private Subnet 2`.

The original public and private subnets had been created with their respective route table associations. After the additional associations, both public subnets used the public route table, and both private subnets used the private route table.

> **Screenshot placeholder — Public route table associations:**
<img width="834" height="403" alt="Screenshot 2026-08-13 at 16 23 03" src="https://github.com/user-attachments/assets/6b015342-58b4-4bf8-95f7-8b9d2607322f" />
<img width="835" height="685" alt="Screenshot 2026-08-13 at 16 23 35" src="https://github.com/user-attachments/assets/66691df8-ada6-4950-b16e-ca0a37ce8001" />


> **Screenshot placeholder — Private route table associations:**
<img width="832" height="520" alt="Screenshot 2026-08-13 at 16 26 34" src="https://github.com/user-attachments/assets/02df7deb-0ae8-49c2-b631-110f2e501192" />
<img width="841" height="706" alt="Screenshot 2026-08-13 at 16 26 15" src="https://github.com/user-attachments/assets/4a8701a1-6c2e-4045-9ce8-ff94bd3d6857" />

> **Screenshot placeholder — VPC network resources:**
<img width="712" height="340" alt="Screenshot 2026-11-12 at 12 19 30" src="https://github.com/user-attachments/assets/457c5052-51df-46f4-86ad-341319a650a9" />

## Task 4: Created a VPC security group

In **Security Groups**, I created a security group with these settings:

| Setting | Value |
| --- | --- |
| Security group name | `Web Security Group` |
| Description | `Enable HTTP access` |
| VPC | `Lab VPC` |
| Inbound type | HTTP |
| Source | Anywhere IPv4 |
| Description | `Permit web requests` |

I used this security group for the web server instance. The HTTP rule allowed web requests; for production, I would review whether the source should be restricted to a narrower range.

> **Screenshot placeholder — Web Security Group:**
<img width="833" height="443" alt="Screenshot 2026-08-13 at 16 29 53" src="https://github.com/user-attachments/assets/1bfc6564-5d7b-4147-b455-15ae5006ff8b" />
<img width="832" height="537" alt="Screenshot 2026-08-13 at 16 31 08" src="https://github.com/user-attachments/assets/6a908bea-47ef-46cb-af32-b3bebc485b73" />

## Task 5: Launched and verified the web server

In the EC2 console, I selected **Launch instances** and configured the instance as follows:

| Setting | Value |
| --- | --- |
| Name | `Web Server 1` |
| AMI | Amazon Linux 2 AMI (HVM) |
| Instance type | `t3.micro` |
| Key pair | `vockey` |
| VPC | `Lab VPC` |
| Subnet | `Public Subnet 2` |
| Auto-assign public IP | Enabled |
| Security group | `Web Security Group` |

In **Advanced details** > **User data**, I entered the lab-provided bootstrap script to install Apache, MySQL, and PHP, download and extract the lab application, and start Apache:

```bash
#!/bin/bash
# Install Apache Web Server and PHP
dnf install -y httpd mariadb 105 php unzip wget
# Download lab files
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RESTRT-1/267-lab-NF-build-vpc-web-server/s3/lab-app.zip
unzip lab-app.zip -d /var/www/html/
# Turn on web server
systemctl enable httpd
systemctl start httpd
```

I launched the instance and waited until its status checks showed **2/2 checks passed**. I copied its **Public IPv4 DNS** value and opened it in a browser. The web application success page confirmed that the server was reachable over HTTP.

> **Screenshot placeholder — EC2 launch settings:**
<img width="828" height="685" alt="Screenshot 2026-08-13 at 16 57 43" src="https://github.com/user-attachments/assets/02ef1d26-3270-46cb-8203-12316d572a2a" />

> **Screenshot placeholder — User data:**
<img width="810" height="596" alt="Screenshot 2026-08-13 at 17 58 58" src="https://github.com/user-attachments/assets/a89a62a2-e753-4c91-a8f6-8c7acb789608" />

> **Screenshot placeholder — Instance status checks:**
<img width="831" height="349" alt="Screenshot 2026-08-13 at 17 59 58" src="https://github.com/user-attachments/assets/91b550ff-3899-4c55-9cd0-2396176ed3f9" />

> **Screenshot placeholder — Web server success page:**
<img width="809" height="516" alt="Screenshot 2026-08-13 at 18 03 18" src="https://github.com/user-attachments/assets/3ca8a239-0fc0-4454-bbdd-7d0b3c68c167" />

> **Screenshot placeholder — Completed architecture:**
<img width="715" height="334" alt="Screenshot 2026-11-12 at 19 09 59" src="https://github.com/user-attachments/assets/27f0b394-3ded-45fe-bba3-1d35be011c03" />

## Lab completion

I completed the lab by creating the VPC and subnets, associating the route tables, configuring the web security group, launching the EC2 web server, and verifying that the web page loaded successfully.

> **Cleanup reminder:** The NAT gateway and running EC2 instance could incur charges. I removed or stopped lab resources when they were no longer needed, following the lab instructions.

## Additional resource

- [What is Amazon VPC?](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
