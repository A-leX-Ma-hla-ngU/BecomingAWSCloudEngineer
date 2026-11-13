# Creating Amazon EC2 Instances

## Lab overview

This lab introduced me to the process of launching and configuring Amazon EC2 instances in AWS. I used the AWS Management Console to launch a bastion host and then used the AWS CLI from that instance to launch a second EC2 instance that acted as a web server. I also worked through the optional troubleshooting challenge, which required me to investigate a misconfigured instance after the user data script had been deleted and then repaired.

The final architecture consisted of a bastion host and a web server instance running in a VPC, with the web server configured to serve web content over HTTP.

> Screenshot placeholder — final architecture diagram for the EC2 bastion host and web server environment.

## Objectives

By the end of this lab, I had completed the following tasks:

- I launched an EC2 instance by using the AWS Management Console.
- I connected to the EC2 instance by using EC2 Instance Connect.
- I launched a second EC2 instance by using the AWS CLI.
- I configured user data to automate web server installation.
- I validated that the web server was reachable from the internet.
- I investigated and resolved a misconfigured user data script in the optional challenge.

## Duration

This lab took approximately 45 minutes to complete, with additional time required to resolve the optional troubleshooting scenario.

## Task 1: Launched the bastion host instance

I began this lab by opening the AWS Management Console and navigating to Amazon EC2. I selected the option to launch a new instance and configured the first EC2 instance, which served as a bastion host.

### Step 1: Named the instance

I entered the name `Bastion host` in the Name and tags section. This action helped me identify the instance clearly in the EC2 console.

> Screenshot placeholder — EC2 launch wizard showing the Name and tags configuration for the bastion host.

### Step 2: Selected the AMI

I kept the default Amazon Linux selection in the quick start list. This provided the Amazon Linux 2 AMI that was required for the bastion host.

> Screenshot placeholder — AMI selection screen showing Amazon Linux 2 selected.

### Step 3: Selected the instance type

I selected `t3.micro` as the instance type for the bastion host. This instance type was suitable for the lab workload and kept resource usage low.

> Screenshot placeholder — Instance type selection for the bastion host with `t3.micro` chosen.

### Step 4: Configured key pair options

Because I used EC2 Instance Connect for this lab, I selected the option to proceed without a key pair. This was acceptable for the lab environment and reduced setup complexity.

> Screenshot placeholder — Key pair configuration screen showing the instance launch without a key pair.

### Step 5: Configured the network settings

I opened the network settings and selected the Lab VPC. I kept the public subnet and enabled auto-assign public IP so that the bastion host could be accessed from the internet through the appropriate network path.

I also created a security group named `Bastion security group` with the description `Permit SSH connections`. This security group allowed the SSH traffic needed for the bastion host.

> Screenshot placeholder — Network settings showing Lab VPC, public subnet, and bastion security group configuration.

### Step 6: Kept the default storage configuration

I accepted the default root volume settings for the bastion host. The default 8 GiB root volume was sufficient for the lab.

> Screenshot placeholder — Storage configuration page showing the default 8 GiB EBS volume.

### Step 7: Added the required IAM role

I expanded the Advanced details section and attached the `Bastion-Role` IAM instance profile. This role granted the instance permission to call AWS services later in the lab when I used the AWS CLI.

> Screenshot placeholder — Advanced details showing the Bastion-Role instance profile attached to the bastion host.

### Step 8: Launched the bastion host

I reviewed the launch summary and selected Launch instance. After a short period, I confirmed that the bastion host had launched successfully and appeared in the EC2 instance list.

> Screenshot placeholder — EC2 instance list showing the newly launched bastion host.

## Task 2: Connected to the bastion host

After the bastion host became available, I opened the EC2 console and selected the instance. I chose Connect and then used EC2 Instance Connect to establish a session. Once connected, I was able to interact with the instance and run AWS CLI commands.

> Screenshot placeholder — EC2 Instance Connect connection screen for the bastion host.

## Task 3: Launched the web server instance by using the AWS CLI

This part of the lab required me to use the command line to automate the EC2 launch process. I used the bastion host as a trusted environment from which I could run AWS CLI commands and configure a web server instance.

### Step 1: Retrieved the latest AMI ID

I ran a script to retrieve the availability zone metadata, derive the AWS Region, and query the latest Amazon Linux 2 AMI ID from AWS Systems Manager Parameter Store. I saved the result in the `AMI` environment variable.

```bash
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
export AWS_DEFAULT_REGION=${AZ::-1}
AMI=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text)
echo $AMI
```

> Screenshot placeholder — EC2 Instance Connect session showing the retrieved AMI ID for Amazon Linux 2.

### Step 2: Retrieved the subnet ID

I queried the Lab VPC for the public subnet and saved the subnet ID to the `SUBNET` variable.

```bash
SUBNET=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=Public Subnet' --query Subnets[].SubnetId --output text)
echo $SUBNET
```

> Screenshot placeholder — AWS CLI command output showing the public subnet ID.

### Step 3: Retrieved the web security group ID

I retrieved the web security group ID using the AWS CLI and saved it to `SG`.

```bash
SG=$(aws ec2 describe-security-groups --filters Name=group-name,Values=WebSecurityGroup --query SecurityGroups[].GroupId --output text)
echo $SG
```

> Screenshot placeholder — AWS CLI command output showing the security group ID for the web server.

### Step 4: Downloaded the user data script

I downloaded a user data script from the lab-provided source and reviewed its contents before launching the web server instance.

```bash
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RSJAWS-1-23732/171-lab-JAWS-create-ec2/s3/UserData.txt
cat UserData.txt
```

The script installed Apache, downloaded the application package, and configured the web application automatically when the instance launched.

> Screenshot placeholder — Terminal output showing the downloaded `UserData.txt` file and contents.

### Step 5: Launched the web server instance

I used a single `aws ec2 run-instances` command to launch the web server instance with the required AMI, subnet, security group, instance type, and user data script.

```bash
INSTANCE=$(\
aws ec2 run-instances \
--image-id $AMI \
--subnet-id $SUBNET \
--security-group-ids $SG \
--user-data file:///home/ec2-user/UserData.txt \
--instance-type t3.micro \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Web Server}]' \
--query 'Instances[*].InstanceId' \
--output text \
)
echo $INSTANCE
```

This command launched the new EC2 instance and tagged it as `Web Server`.

> Screenshot placeholder — AWS CLI output showing the new web server instance ID.

### Step 6: Waited for the instance to become ready

I monitored the instance state until it moved to a `running` state. I used the AWS CLI to check the instance's lifecycle and confirm readiness before testing the website.

```bash
aws ec2 describe-instances --instance-ids $INSTANCE --query 'Reservations[].Instances[].State.Name' --output text
```

> Screenshot placeholder — CLI output showing the EC2 instance state changing to `running`.

### Step 7: Tested the web server

Once the instance was running, I retrieved the public DNS name and opened it in a browser. The website responded successfully, confirming that the instance had been configured properly.

```bash
aws ec2 describe-instances --instance-ids $INSTANCE --query Reservations[].Instances[].PublicDnsName --output text
```

The browser displayed the configured web application, which confirmed that the EC2 instance had been launched and configured correctly.

> Screenshot placeholder — Browser output showing the working web server page.

> Screenshot placeholder — EC2 console showing the newly launched `Web Server` instance in the instance list.

## Optional challenge: investigated a misconfigured web server

I also completed the optional challenge, which focused on troubleshooting an EC2 instance that had been configured incorrectly. This part of the lab was more complex because I had accidentally deleted the user data file before I inspected it. I then used CloudTrail and AWS CLI logs to reconstruct the original script and identify the root cause.

### What went wrong

I had already launched the instance and then discovered that its configuration was broken. When I reviewed the instance, the web server was not working as expected. I then realized that I had deleted the misconfigured user data file too early, without first reviewing what it contained.

This mistake forced me to reverse engineer the original configuration from system logs and CloudTrail records. I had to reconstruct what the script had originally intended to do and then compare it with the live state of the system.

> Screenshot placeholder — misconfigured EC2 instance details showing the failed web server configuration.

### Investigated the issue with CloudTrail and CLI logs

I used AWS CloudTrail and the CLI logs captured from the environment to investigate what had happened. The logs showed the sequence of actions that had run during instance launch and identified the commands that had been used to configure the EC2 instance.

I was able to trace the lifecycle of the instance and confirm that the user data script had been applied during the launch process. The evidence in the logs helped me reconstruct the script, even though the original file had already been removed.

> Screenshot placeholder — CloudTrail log output used to investigate the EC2 instance launch events.

> Screenshot placeholder — CLI log output showing the user data commands and configuration actions.

### Reconstructed the original user data script

After reviewing the CloudTrail and CLI logs, I reconstructed the original launch script by identifying the commands that had been executed when the instance was provisioned. I then compared the script contents with the current state of the instance to identify the misconfiguration.

The key discovery was that the user data script had used `httpdd` instead of `httpd` during the initial launch. This caused the web server package to be invoked incorrectly and left the instance in a broken state.

I confirmed that the correct command should have been:

```bash
yum install -y httpd
systemctl enable httpd
systemctl start httpd
```

Instead, the original script had used the incorrect service name `httpdd`, which prevented Apache from being installed or enabled correctly.

> Screenshot placeholder — reconstructed user data script showing the incorrect `httpdd` command and the corrected `httpd` command.

### Corrected the misconfiguration

After identifying the root cause, I corrected the broken installation by installing the proper package and enabling the Apache service. I then verified that the web server started successfully and responded correctly in the browser.

```bash
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
```

> Screenshot placeholder — final successful web server status after the fix was applied.

## Lesson learned

This lab reinforced the importance of reviewing user data scripts before deleting them, especially when an instance has been created by automation. The optional challenge taught me that CloudTrail and CLI logs can be valuable forensic tools when a configuration file has been lost or altered. In this case, those logs allowed me to reconstruct the original user data script and successfully identify the `httpdd` typo that had caused the instance to fail.

## Conclusion

I completed the EC2 lab successfully by launching a bastion host, connecting to it through EC2 Instance Connect, and then using the AWS CLI to launch and test a web server. I also completed the troubleshooting challenge, where I had to trace the misconfigured user data script by using CloudTrail and the CLI logs after I had inadvertently removed the file too soon. The final fix confirmed that the root cause was an incorrect `httpdd` command in the original user data script, which had prevented Apache from starting correctly.

> Screenshot placeholder — final summary showing the completed EC2 instance and working web server status.
