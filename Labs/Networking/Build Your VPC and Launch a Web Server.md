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

> **Screenshot placeholder — Customer architecture:** Add the lab diagram showing the VPC, public and private subnets, security group, and web server instance.

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
>
> **Screenshot placeholder — VPC created:** Add a screenshot of the success message or VPC details page.
>
> **Screenshot placeholder — Initial route tables and gateways:** Add a screenshot showing the VPC's generated route tables and gateways.

## Task 2: Created additional subnets

I opened **Subnets** and created two additional subnets in `Lab VPC`:

| Subnet name | Availability Zone | IPv4 CIDR |
| --- | --- | --- |
| `Public Subnet 2` | No preference | `10.0.2.0/24` |
| `Private Subnet 2` | No preference | `10.0.3.0/24` |

I selected the indicated second Availability Zone where the console presented a choice, so the subnets could support a multi-AZ layout.

> **Screenshot placeholder — Additional subnets:** Add a screenshot showing `Public Subnet 2` and `Private Subnet 2` with their CIDR blocks and Availability Zones.

## Task 3: Associated the subnets with route tables

In **Route Tables**, I selected `Public Route Table`, opened **Subnet associations**, and associated `Public Subnet 2`. I then selected `Private Route Table` and associated `Private Subnet 2`.

The original public and private subnets had been created with their respective route table associations. After the additional associations, both public subnets used the public route table, and both private subnets used the private route table.

> **Screenshot placeholder — Public route table associations:** Add a screenshot showing `Public Subnet 1` and `Public Subnet 2` associated with `Public Route Table`.
>
> **Screenshot placeholder — Private route table associations:** Add a screenshot showing `Private Subnet 1` and `Private Subnet 2` associated with `Private Route Table`.
>
> **Screenshot placeholder — VPC network resources:** Add the lab diagram showing the completed VPC, subnets, gateways, and route tables.

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

> **Screenshot placeholder — Web Security Group:** Add a screenshot showing its VPC and inbound HTTP rule.

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
yum install -y httpd mysql php
# Download lab files
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RESTRT-1/267-lab-NF-build-vpc-web-server/s3/lab-app.zip
unzip lab-app.zip -d /var/www/html/
# Turn on web server
chkconfig httpd on
service httpd start
```

I launched the instance and waited until its status checks showed **2/2 checks passed**. I copied its **Public IPv4 DNS** value and opened it in a browser. The web application success page confirmed that the server was reachable over HTTP.

> **Screenshot placeholder — EC2 launch settings:** Add a screenshot showing `Web Server 1`, the selected VPC, subnet, public IP setting, and security group.
>
> **Screenshot placeholder — User data:** Add a screenshot showing the bootstrap script. Do not include credentials or secrets.
>
> **Screenshot placeholder — Instance status checks:** Add a screenshot showing the instance with 2/2 checks passed.
>
> **Screenshot placeholder — Web server success page:** Add a screenshot showing the application page loaded from the instance's Public IPv4 DNS.
>
> **Screenshot placeholder — Completed architecture:** Add the final lab diagram showing the VPC, public and private subnets, route tables, gateways, security group, and web server.

## Lab completion

I completed the lab by creating the VPC and subnets, associating the route tables, configuring the web security group, launching the EC2 web server, and verifying that the web page loaded successfully.

> **Cleanup reminder:** The NAT gateway and running EC2 instance could incur charges. I removed or stopped lab resources when they were no longer needed, following the lab instructions.

## Additional resource

- [What is Amazon VPC?](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
