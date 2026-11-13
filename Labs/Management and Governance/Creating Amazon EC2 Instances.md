# Creating Amazon EC2 Instances

## Lab overview

This lab introduced me to launching and configuring Amazon EC2 instances. I used the AWS Management Console to launch a bastion host, connected to it with EC2 Instance Connect, and used the AWS CLI from the bastion host to launch a second instance as a web server. I also completed the optional troubleshooting challenge and used CloudTrail and instance logs to investigate a failed cloud-init user-script run after a locally deleted user data copy.

The final architecture consisted of a bastion host and a web server instance in a VPC.

> Screenshot placeholder — final architecture diagram showing the bastion host and web server.

## Objectives completed

- I launched an EC2 instance using the AWS Management Console.
- I connected to the bastion host using EC2 Instance Connect.
- I launched another EC2 instance using the AWS CLI.
- I used user data to automate instance configuration.
- I investigated a misconfigured web server instance using CloudTrail and cloud-init logs.

## Duration

The lab was expected to take approximately 45 minutes. The optional troubleshooting investigation took additional time.

## Task 1: Launched the bastion host

I opened the EC2 console and launched an instance named `Bastion host`. I selected the Amazon Linux 2 AMI and the `t3.micro` instance type. Because I used EC2 Instance Connect, I proceeded without a key pair.

I selected the Lab VPC and its public subnet, left auto-assign public IP enabled, and created a security group named `Bastion security group` with the description `Permit SSH connections`. I retained the default 8 GiB root volume and attached the `Bastion-Role` instance profile so that the host could make the required AWS service calls through the CLI.

> Screenshot placeholder — bastion host launch settings, including the AMI, instance type, network, security group, and IAM instance profile.

I reviewed the launch summary, launched the instance, and confirmed that it appeared in the EC2 instance list.

> Screenshot placeholder — EC2 console showing the running bastion host.

## Task 2: Connected to the bastion host

After the bastion host was running, I selected it in the EC2 console, chose **Connect**, and opened an EC2 Instance Connect session. I used this session to run the AWS CLI commands for the next task.

> Screenshot placeholder — EC2 Instance Connect terminal session on the bastion host.

## Task 3: Launched a web server using the AWS CLI

### Retrieved the AMI, subnet, and security group

I used the instance metadata service to determine the bastion host's Availability Zone and Region, and queried Systems Manager Parameter Store for the latest Amazon Linux 2 AMI ID:

```bash
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
export AWS_DEFAULT_REGION=${AZ::-1}
AMI=$(aws ssm get-parameters \
  --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
  --query 'Parameters[0].[Value]' --output text)
echo "$AMI"
```

I retrieved the public subnet and web security group IDs and stored them in shell variables:

```bash
SUBNET=$(aws ec2 describe-subnets \
  --filters 'Name=tag:Name,Values=Public Subnet' \
  --query 'Subnets[].SubnetId' --output text)
echo "$SUBNET"

SG=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=WebSecurityGroup \
  --query 'SecurityGroups[].GroupId' --output text)
echo "$SG"
```

> Screenshot placeholder — terminal showing the AMI, public subnet, and web security group values. Redact account-specific information if present.

### Downloaded the user data script and launched the instance

I downloaded and inspected the lab-provided user data script:

```bash
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RSJAWS-1-23732/171-lab-JAWS-create-ec2/s3/UserData.txt
cat UserData.txt
```

The script was intended to install and configure the web server and application during instance initialization. I then launched a `t3.micro` instance named `Web Server`, passing the downloaded script as user data:

```bash
INSTANCE=$(aws ec2 run-instances \
  --image-id "$AMI" \
  --subnet-id "$SUBNET" \
  --security-group-ids "$SG" \
  --user-data file:///home/ec2-user/UserData.txt \
  --instance-type t3.micro \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Web Server}]' \
  --query 'Instances[*].InstanceId' \
  --output text)
echo "$INSTANCE"
```

> Screenshot placeholder — downloaded user data script and AWS CLI output showing the web server instance ID.

### Checked the instance and tested the site

I checked the instance state until it reported `running`:

```bash
aws ec2 describe-instances --instance-ids "$INSTANCE" \
  --query 'Reservations[].Instances[].State.Name' --output text
```

I retrieved the public DNS name and opened it in a browser to test the web server:

```bash
aws ec2 describe-instances --instance-ids "$INSTANCE" \
  --query 'Reservations[].Instances[].PublicDnsName' --output text
```

> Screenshot placeholder — running web server instance in the EC2 console and the resulting web page in a browser.

## Optional challenge: investigated the misconfigured web server

I worked through the optional challenge to diagnose why the `Misconfigured Web Server` instance was not serving the expected site. I made a mistake early in the investigation: I deleted the local copy of the user data that I had downloaded before inspecting it. Because the original launch-time script was no longer available in the working directory, I used CloudTrail and the instance's cloud-init logs to reconstruct it.

> Screenshot placeholder — misconfigured web server instance and the initial failed web page or connection attempt.

### Used CloudTrail and instance logs to investigate

I reviewed CloudTrail activity and the instance logs to trace the launch and initialization. The cloud-init output showed a warning that the `scripts-user` module had failed at approximately `16:32:08`:

```text
cc_scripts_user.py[WARNING]: Failed to run module scripts-user
util.py[WARNING]: Running module scripts-user ... failed
```

This log established that cloud-init had reported a user-script execution failure during initialization. The same captured output later showed a subsequent cloud-init run reaching `modules:final` and finishing. I treated those as separate log entries and used the script artifacts and timestamps to understand what had run, rather than assuming that a later successful cloud-init completion meant the earlier user-script attempt had succeeded.

> Screenshot placeholder — cloud-init output showing the failed `scripts-user` module and the later initialization sequence. Include the timestamp context.

### Recovered the instance-side cloud-init artifacts

I used `find` to locate the user data and cloud-init metadata that persisted on the instance, even after I had deleted my local copy:

```bash
sudo find /var/lib/cloud -type f | sort
```

This command revealed important files such as:

- `/var/lib/cloud/instance/scripts/part-001`
- `/var/lib/cloud/instance/user-data.txt`
- `/var/lib/cloud/instance/semaphore/config_scripts_user`

The presence of these files confirmed that cloud-init had stored user data and script state on the instance itself. That was important because it meant I still had a path to recover the original launch behavior without relying on the deleted local copy.

> Screenshot placeholder — `sudo find /var/lib/cloud -type f | sort` output listing the cloud-init artifacts.

### Reviewed the recovered script files

I listed the scripts directory and inspected the persisted script file:

```bash
sudo ls -l /var/lib/cloud/instance/scripts/
sudo cat /var/lib/cloud/instance/scripts/part-001
sudo cat /var/lib/cloud/instance/user-data.txt
```

The recovered script content showed the expected Apache installation commands, including:

```bash
#!/bin/bash
# Install Apache Web Server
yum install -y httpd

# Turn on web server
systemctl enable httpd.service
```

The user-data file under `/var/lib/cloud/instance/user-data.txt` showed the same launch-time configuration that had been passed at instance creation. This evidence was critical because it confirmed that the launch script had been stored in cloud-init state and could still be recovered even after the local copy had been removed. It also showed that the failed `scripts-user` module was not necessarily a sign that the instance had no Apache configuration at all; it meant the launch-time script had encountered a failure during its run.

> Screenshot placeholder — `sudo cat /var/lib/cloud/instance/scripts/part-001` showing the recovered script.
>
> Screenshot placeholder — `sudo cat /var/lib/cloud/instance/user-data.txt` showing the persisted user data.

### Diagnosed and corrected the server configuration

I used the recovered script and the instance logs to guide the troubleshooting. I checked whether Apache was installed and whether the service was enabled and running:

```bash
sudo yum install -y httpd
sudo systemctl enable httpd.service
sudo systemctl start httpd.service
sudo systemctl status httpd.service
```

After the service was started correctly, I retested the instance using its public DNS name and confirmed that the web server responded as expected.

> Screenshot placeholder — Apache service state after the fix.
>
> Screenshot placeholder — browser verification of the repaired web server using its public DNS name.

## Key lessons

- I learned to inspect and preserve a user data script before deleting or changing it during troubleshooting.
- I used CloudTrail and instance-side logs as complementary sources for reconstructing launch and initialization activity.
- I located the persisted cloud-init artifacts under `/var/lib/cloud` and recovered the script rather than relying on a deleted local file.
- I confirmed that the failed initialization was tied to the `scripts-user` module, but the recovered files showed that the intended Apache installation was still valid and could be restored.
- I checked both cloud-init output and the application service state instead of assuming that an instance in the `running` state meant its web server was working.

## Conclusion

I launched a bastion host through the AWS Management Console, connected to it with EC2 Instance Connect, and used the AWS CLI to launch a web server instance. In the optional challenge, I initially deleted the local copy of the misconfigured user data before reviewing it, then used CloudTrail and the instance-side cloud-init artifacts to recover the script and investigate the failed initialization. The evidence I captured showed a failed `scripts-user` module and persisted script files under `/var/lib/cloud/instance/`, which allowed me to reconstruct the intended Apache installation and restore the service correctly.

> Screenshot placeholder — final EC2 instance list and successful web server verification.
