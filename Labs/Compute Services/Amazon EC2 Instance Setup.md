# Amazon EC2 Instance Setup - Documentation Journey

## Executive Summary

This documentation captures the journey of completing an introductory Amazon EC2 lab that covered the fundamental operations of launching, configuring, monitoring, and managing an EC2 instance on AWS. Over approximately 45 minutes, the lab provided hands-on experience with core AWS compute services and instance lifecycle management.

---

## Introduction to Amazon EC2

### Overview

The lab was structured to provide a foundational understanding of Amazon Elastic Compute Cloud (Amazon EC2), which was explored as a web service providing resizable compute capacity in the cloud. The primary objective was to demonstrate how developers could leverage EC2's simple web service interface to obtain and configure computing resources with minimal friction.

#### Key Concepts Covered:

- **Amazon EC2** was learned as the core service that reduces the time required to obtain and boot new server instances to minutes
- **Elastic Scalability** was demonstrated as the ability to quickly scale capacity up or down based on computing requirements
- **Cost Efficiency** was highlighted as the pay-as-you-go model that charged only for capacity actually used
- **Resilience** was emphasized as the capability to build failure-resistant applications

**[Screenshot: AWS Management Console EC2 Dashboard Overview]**
> <img width="428" height="333" alt="Screenshot 2026-06-22 at 20 07 37" src="https://github.com/user-attachments/assets/af5f4756-2509-458e-a137-89df76dacde9" />

---

## Lab Objectives Achieved

By the conclusion of this lab, the following objectives were successfully accomplished:

1. **Launched** a web server instance with termination protection enabled
2. **Monitored** the EC2 instance using CloudWatch metrics and status checks
3. **Modified** security group rules to allow HTTP access
4. **Enhanced** the web server interface with professional styling and branding
5. **Resized** the instance by changing instance type and EBS volume size
6. **Tested** termination protection functionality
7. **Terminated** the EC2 instance gracefully

---

## Task 1: Launching the EC2 Instance

### Initial Setup Phase

The journey began by accessing the AWS Management Console and navigating to the EC2 service. The instance was configured through a comprehensive multi-step launch wizard that addressed naming, image selection, instance type, networking, storage, and advanced settings.

#### Step 1: Instance Naming

The instance was named "Web Server" through the Name and tags pane. This action created a key-value pair in AWS that allowed for easy identification and management of the resource.

**[Screenshot: EC2 Launch Wizard - Naming Step]**
> <img width="813" height="212" alt="Screenshot 2026-06-22 at 20 41 00" src="https://github.com/user-attachments/assets/dfd6fe07-5fbc-4009-a193-d9d1933938b1" />


#### Step 2: Amazon Machine Image (AMI) Selection

The Amazon Linux 2023 AMI was selected from the Quick Start list. This image was chosen as it provided a pre-configured operating system template suitable for web server deployment.

**[Screenshot: AMI Selection Screen]**
>  <img width="788" height="566" alt="Screenshot 2026-06-22 at 20 48 33" src="https://github.com/user-attachments/assets/ade9197c-6563-4e69-ab6c-95372c72d781" />

#### Step 3: Instance Type Configuration

A **t3.micro** instance type was selected for this lab. This instance type was noted to include:
- 2 virtual CPUs
- 1 GiB of memory
- Suitable for low-traffic applications and testing scenarios

**[Screenshot: Instance Type Selection - t3.micro]**
> <img width="713" height="463" alt="Screenshot 2026-06-22 at 20 51 24" src="https://github.com/user-attachments/assets/64e27e56-6a93-4b55-b4bb-b141a857e86b" />


#### Step 4: Key Pair Configuration

For this lab environment, the instance was configured to proceed without a key pair, as SSH access was not required for the demonstrations.

#### Step 5: Network and Security Configuration

The network settings were configured as follows:

- **VPC Selected:** Lab VPC
- **Security Group Name:** Web Server security group
- **Description:** Security group for my web server
- **Initial Inbound Rules:** The default SSH rule was removed to improve security posture

**[Screenshot: Network Settings Configuration]**
> <img width="1066" height="785" alt="Screenshot 2026-06-22 at 21 05 02" src="https://github.com/user-attachments/assets/a05590af-b250-4efb-a789-d8d6c4dbf89e" />


#### Step 6: Storage Configuration

The default storage configuration was maintained:
- **Root Volume Size:** 8 GiB
- **Volume Type:** Default EBS configuration

#### Step 7: Advanced Details and User Data

Termination protection was **enabled** in the Advanced details pane to prevent accidental instance termination.

The following User Data script was deployed to configure the web server automatically upon instance launch:

```bash
#!/bin/bash
yum -y install httpd
systemctl enable httpd
systemctl start httpd
echo '<html><h1>Hello From Your Web Server!</h1></html>' > /var/www/html/index.html
```

**Purpose of the script:**
- Installed Apache HTTP Server (httpd)
- Enabled httpd to start automatically on system boot
- Started the httpd service immediately
- Created a simple HTML test page

**[Screenshot: Advanced Details - User Data Script Entry]**
> <img width="498" height="480" alt="Screenshot 2026-06-22 at 21 11 52" src="https://github.com/user-attachments/assets/ff7bd7fc-8edd-4ac0-9484-412755d569f7" />


#### Step 8: Instance Launch

The instance was launched successfully and transitioned through the following states:

1. **Pending** → Instance was being provisioned
2. **Running** → Instance had started booting

The instance was assigned a public DNS name and public IPv4 address for external connectivity.

**[Screenshot: EC2 Instances Dashboard - Web Server Running]**
> <img width="869" height="230" alt="Screenshot 2026-06-22 at 21 17 50" src="https://github.com/user-attachments/assets/24fdf4d6-dbba-40c0-9d32-a002e59eed53" />

---

## Task 2: Instance Monitoring

### Status Checks and CloudWatch Metrics

Once the instance was fully operational, the monitoring capabilities were explored. The instance was observed to have successfully passed both automated status checks:

- **System Reachability Check:** Verified that the underlying hardware was functioning properly
- **Instance Reachability Check:** Confirmed that the instance's operating system was operational

**[Screenshot: Status Checks Tab]**
> <img width="1083" height="179" alt="Screenshot 2026-06-22 at 21 22 17" src="https://github.com/user-attachments/assets/8581fb7a-83b4-43bf-ae91-67104bc58f09" />


### Monitoring Tab Review

The Monitoring tab was accessed to view CloudWatch metrics being collected for the instance. Although minimal data was present due to the recent launch, the tab demonstrated the following metrics collection:

- CPU utilization
- Network traffic (in/out)
- Instance status
- Detailed (one-minute) monitoring availability

**[Screenshot: CloudWatch Metrics for EC2 Instance]**
> <img width="1405" height="422" alt="Screenshot 2026-06-22 at 21 24 56" src="https://github.com/user-attachments/assets/fe9792bd-74a7-4c27-aee1-08c467c1beac" />


### Instance Screenshot Feature

The instance screenshot capability was tested through the Actions menu (Monitor and troubleshoot → Get Instance Screenshot). This feature was noted as valuable for troubleshooting when SSH or RDP connections were unavailable, as it displayed the actual console output of the instance.

**[Screenshot: Instance Console Screenshot]**
> <img width="800" height="600" alt="i-0e837d3c4b80c4c3d" src="https://github.com/user-attachments/assets/fff896c2-2936-4be6-8630-5d6b9c4612de" />


---

## Task 3: Security Group Configuration and Web Server Access

### Initial Access Attempt

An attempt was made to access the web server using the instance's public IPv4 address in a web browser. This attempt failed, as the security group had not yet been configured to allow inbound HTTP traffic.

**Key Learning:** Security groups functioned as virtual firewalls, controlling all ingress and egress traffic to instances.

### Security Group Modification

The security group was updated to permit HTTP traffic:

1. Navigated to Security Groups in the EC2 console
2. Selected the "Web Server security group"
3. Added a new inbound rule with the following configuration:
   - **Type:** HTTP
   - **Protocol:** TCP
   - **Port Range:** 80
   - **Source:** Anywhere-IPv4 (0.0.0.0/0)

**[Screenshot: Inbound Rules Configuration - HTTP Rule Addition]**
> <img width="887" height="552" alt="Screenshot 2026-06-22 at 21 32 16" src="https://github.com/user-attachments/assets/e2593449-8699-4d9c-817a-06016f5a1ac2" />


### Successful Web Server Access

After applying the security group changes, the web browser was refreshed and successfully displayed:

```
Hello From Your Web Server!
```

**[Screenshot: Web Server Successfully Accessed]**
> <img width="826" height="294" alt="Screenshot 2026-06-22 at 21 34 02" src="https://github.com/user-attachments/assets/24f5d804-1b27-4406-93d9-eb205523b8ae" />


### Enhanced Web Server with Professional Styling

To further enhance the web server's appearance and demonstrate advanced User Data script capabilities, the instance was updated with a more professional and visually appealing web page. The enhanced User Data script was redeployed to replace the basic HTML with a styled, branded interface.

The following enhanced User Data script was configured:

```bash
#!/bin/bash

# Update package metadata
yum update -y

# Install Apache
yum install -y httpd

# Enable and start Apache
systemctl enable httpd
systemctl start httpd

# Create a more professional webpage
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS Web Server</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #232F3E, #FF9900);
            color: white;
            text-align: center;
            margin-top: 15%;
        }

        .container {
            background: rgba(0,0,0,0.3);
            padding: 30px;
            border-radius: 10px;
            width: 60%;
            margin: auto;
        }

        h1 {
            font-size: 3rem;
        }

        p {
            font-size: 1.2rem;
        }

        .badge {
            display: inline-block;
            background: white;
            color: #232F3E;
            padding: 10px 20px;
            border-radius: 20px;
            font-weight: bold;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 AWS EC2 Web Server</h1>
        <p>Successfully deployed using EC2 User Data.</p>
        <div class="badge">Free Tier Friendly</div>
    </div>
</body>
</html>
EOF
```

**Key Enhancements in the Script:**

- **Package Updates:** The script was expanded to include `yum update -y` for system package freshness
- **Professional Styling:** CSS was applied to create a visually appealing interface with:
  - AWS brand colors (AWS Dark Blue #232F3E and AWS Orange #FF9900) in a gradient background
  - Centered, responsive layout with a semi-transparent container
  - Modern typography with scaled heading sizes
  - Styled badge component for visual emphasis
- **Branding:** The page title and heading were updated to reflect "AWS EC2 Web Server" with an emoji rocket icon
- **User Feedback:** A "Free Tier Friendly" badge was added to highlight cost efficiency
- **HTML5 Standards:** The page was structured with proper HTML5 semantic markup and meta tags for character encoding and viewport settings

After updating the User Data script and relaunching the instance, the enhanced web page was displayed when accessing the public IPv4 address, showcasing a professional AWS-branded interface.

**[Screenshot: Enhanced Web Server with Professional Styling]**
> <img width="1680" height="1050" alt="Screenshot 2026-06-22 at 22 23 04" src="https://github.com/user-attachments/assets/172bc855-4b2f-4167-be23-a2e0d9d92cac" />


**[Screenshot: Enhanced User Data Script in Advanced Details Pane]**
> <img width="873" height="471" alt="Screenshot 2026-06-22 at 22 17 00" src="https://github.com/user-attachments/assets/485a76b6-a3b0-4eea-9ffc-cac5ea72d89a" />
><img width="598" height="373" alt="Screenshot 2026-06-22 at 22 18 01" src="https://github.com/user-attachments/assets/c3eae5c8-7ce8-4d20-b802-0a6a0db07d64" />

---

## Task 4: Instance Resizing

### Stopping the Instance

The instance was stopped through the Instance state menu before resizing operations could be performed. The instance transitioned to a **stopped** state, during which:
- No compute charges were incurred
- Storage charges for EBS volumes remained active

**[Screenshot: Instance State - Stopped]**
> <img width="1018" height="138" alt="Screenshot 2026-06-22 at 21 36 22" src="https://github.com/user-attachments/assets/5fa4aaba-0eea-47be-8fb4-8fb89e89f641" />


### Instance Type Upgrade

The instance type was upgraded from **t3.micro** to **t3.small** using the Instance Settings menu:

- **Change:** t3.micro (2 vCPU, 1 GiB RAM) → t3.small (2 vCPU, 2 GiB RAM)
- **Benefit:** Doubled available memory for improved application performance

**[Screenshot: Instance Type Change Dialog]**
> <img width="1667" height="869" alt="Screenshot 2026-06-22 at 21 38 43" src="https://github.com/user-attachments/assets/f0b64b7c-0909-475b-95e3-4448ea867f23" />


### EBS Volume Resizing

The root EBS volume was resized through the Volumes interface:

- **Original Size:** 8 GiB
- **New Size:** 10 GiB
- **Storage Increase:** 2 GiB additional capacity

**[Screenshot: EBS Volume Modification]**
> <img width="1652" height="664" alt="Screenshot 2026-06-22 at 21 41 36" src="https://github.com/user-attachments/assets/9772b34d-b8ad-47a2-a4dc-93335a7372d1" />


### Instance Restart

The resized instance was restarted, bringing it back to a **Running** state with the upgraded configuration:
- Increased memory (2 GiB)
- Larger root volume (10 GiB)

**[Screenshot: Instance Restarted with New Configuration]**
> <img width="1028" height="94" alt="Screenshot 2026-06-22 at 21 47 33" src="https://github.com/user-attachments/assets/486795ed-ae26-4531-ad2f-41610f7b2aef" />
> <img width="887" height="162" alt="Screenshot 2026-06-22 at 21 47 12" src="https://github.com/user-attachments/assets/ecc0b8d0-11a2-442c-bb61-72d9b888e244" />


---

## Task 5: Termination Protection Testing

### Testing Protection Mechanism

An attempt was made to terminate the instance through the Instance state menu. The termination operation failed with an error message:

```
Failed to terminate an instance: The instance may not be terminated.
```

This failure occurred because termination protection was enabled during the initial instance configuration.

**[Screenshot: Termination Protection Error]**
> <img width="656" height="171" alt="Screenshot 2026-06-22 at 21 53 20" src="https://github.com/user-attachments/assets/37678ac9-7822-42fd-bd5b-257ebea06ab2" />


### Disabling Protection

Termination protection was disabled through the Instance settings menu:

1. Accessed Actions → Instance settings → Change termination protection
2. Unchecked the "Enable" option
3. Saved the changes

**[Screenshot: Termination Protection Disabled]**
> <img width="596" height="377" alt="Screenshot 2026-06-22 at 21 54 45" src="https://github.com/user-attachments/assets/db6d44b7-4713-47db-9834-3a3829d9ed37" />


### Instance Termination

With termination protection disabled, the instance was successfully terminated:

1. Selected Instance state → Terminate instance
2. Confirmed the termination action
3. Instance transitioned through **shutting-down** state and reached **terminated** state

**[Screenshot: Instance Terminated]**
> <img width="825" height="162" alt="Screenshot 2026-06-22 at 21 56 40" src="https://github.com/user-attachments/assets/b63397e2-3e6f-49ab-9e9c-0b1d547a792b" />


---

## Key Learnings and Best Practices

### User Data Scripts for Web Server Customization

The lab demonstrated the power of User Data scripts in EC2 instance initialization:
- **Automation:** Complete web server setup without manual configuration
- **Scalability:** Same configuration deployed instantly across multiple instances
- **Customization:** HTML, CSS, and branding fully customizable in User Data
- **Efficiency:** Professional interfaces achievable with proper script structure

### Security Group Management

The lab demonstrated that security groups served as critical components of AWS security architecture:
- Default-deny posture required explicit rules for traffic allowance
- Rules could be modified without instance restart
- Changes applied immediately to all associated instances

### Instance Lifecycle Management

The complete instance lifecycle was explored:
- **Launch:** Configuration through the wizard interface
- **Monitor:** CloudWatch metrics and status checks
- **Customize:** Enhanced User Data scripts for branding and styling
- **Modify:** Instance type and storage resizing
- **Terminate:** Graceful shutdown with protection mechanisms

### Cost Optimization

Key cost considerations were highlighted:
- Stopped instances incurred no compute charges
- Storage charges persisted for stopped instances
- Right-sizing instances reduced unnecessary spending

### Monitoring and Troubleshooting

Multiple monitoring capabilities were demonstrated:
- Real-time status checks for instance health
- CloudWatch metrics for performance analysis
- Console screenshots for deep troubleshooting

---

## Conclusion

The completion of this lab provided a comprehensive introduction to Amazon EC2 operations. The journey covered the entire instance lifecycle from creation through termination, with emphasis on practical AWS management skills including security configuration, web server customization through User Data scripts, performance optimization, and operational monitoring. These foundational skills were established as essential for any AWS practitioner working with compute services.

**Lab Duration:** Approximately 60 minutes (includes enhanced web server styling)  
**Status:** Successfully Completed  
**Key Achievement:** Demonstrated proficiency in EC2 instance management across all core operational areas, including advanced User Data script deployment for professional web server interfaces.

---

## Appendix: Important AWS Resources

- **EC2 Dashboard:** Central hub for instance management and monitoring
- **Security Groups:** Virtual firewalls for network access control
- **CloudWatch:** Comprehensive monitoring and logging service
- **EBS Volumes:** Persistent block storage for instances
- **Instance Types:** Various configurations optimized for different workloads
- **User Data Scripts:** Automated instance configuration and initialization
