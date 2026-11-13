# Creating Amazon EC2 Instances

## Lab overview

This lab introduced me to launching and configuring Amazon EC2 instances. I used the AWS Management Console to launch a bastion host, connected to it with EC2 Instance Connect, and used the AWS CLI from the bastion host to launch a second instance as a web server. I also completed the optional troubleshooting challenge and used CloudTrail and instance logs to investigate lost user data and a failed cloud-init user-script run.

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

I worked through the optional challenge to diagnose why the `Misconfigured Web Server` instance was not serving the expected site. I made a mistake early in the investigation: I deleted the misconfigured user data before inspecting it. Since the original launch-time input was no longer available to me in the place I expected, I used CloudTrail and the instance's CLI and cloud-init logs to reconstruct what had run.

> Screenshot placeholder — misconfigured web server instance and the initial failed web page or connection attempt.

### Used CloudTrail and instance logs to investigate

I reviewed CloudTrail activity and the instance logs to trace the launch and initialization. The cloud-init output showed a warning that the `scripts-user` module had failed at `Oct 01 16:32:08`:

```text
cc_scripts_user.py[WARNING]: Failed to run module scripts-user
util.py[WARNING]: Running module scripts-user ... failed
```

This log established that cloud-init had reported a user-script execution failure during that initialization. The same captured output later showed a subsequent cloud-init run reaching `modules:final` and finishing. I treated those as separate log entries and used the persisted script and its timestamps to understand what had run, rather than assuming that a later successful cloud-init completion meant the earlier user-script attempt had succeeded.

> Screenshot placeholder — cloud-init output showing the failed `scripts-user` module and the later initialization sequence. Include the timestamp context.

### Recovered the persisted user data script

Although I had deleted the user data before inspecting it, I found a persisted cloud-init script on the instance. I displayed the script and listed the scripts directory:

```bash
sudo cat /var/lib/cloud/instance/scripts/part-001
sudo ls -l /var/lib/cloud/instance/scripts/
```

The recovered `part-001` script shown in my terminal contained:

```bash
#!/bin/bash
# Install Apache Web Server
yum install -y httpd

# Turn on web server
systemctl enable httpd.service
```

The directory listing showed `part-001` as a 114-byte file. This evidence let me recover the script content from the instance even though I had deleted the copy I meant to inspect. Importantly, the recovered commands shown here used `httpd`, not `httpdd`; therefore, these screenshots did not support attributing the cloud-init warning to an `httpdd` typo. The warning indicated that the `scripts-user` module failed, but the recovered file alone did not establish the precise cause of that failure. I used the CloudTrail and cloud-init evidence together rather than treating the misspelling as confirmed by this recovered script.

> Screenshot placeholder — `sudo cat /var/lib/cloud/instance/scripts/part-001` showing the recovered user data script.
>
> Screenshot placeholder — `sudo ls -l /var/lib/cloud/instance/scripts/` showing the `part-001` file and its size.

### Diagnosed and corrected the server configuration

I used the reconstructed script and the instance logs to guide the troubleshooting. The recovered commands showed that Apache had been installed and enabled, but the script shown in the evidence did not include a `systemctl start` command. I therefore checked the service state and completed the configuration by ensuring the correct package was installed and the service was enabled and running:

```bash
sudo yum install -y httpd
sudo systemctl enable httpd.service
sudo systemctl start httpd.service
sudo systemctl status httpd.service
```

After the service was running, I retested the instance using its public IPv4 DNS name and confirmed whether the web server responded. The screenshots available here documented the cloud-init warning and recovered script; they did not themselves show the final browser verification, so I left a placeholder for that result.

> Screenshot placeholder — Apache service status after troubleshooting.
>
> Screenshot placeholder — browser verification of the repaired web server using its public DNS name.

## Key lessons

- I learned to inspect and preserve a user data script before deleting or changing it during troubleshooting.
- I used CloudTrail and instance-side logs as complementary sources for reconstructing launch and initialization activity.
- I used the persisted file under `/var/lib/cloud/instance/scripts/` to recover user data after deleting my local copy.
- I distinguished what the logs demonstrated from what they did not: the captured `part-001` script used `httpd`, while cloud-init separately reported a failed `scripts-user` module.
- I checked both cloud-init output and the application service state instead of assuming that an instance in the `running` state meant its web server was working.

## Conclusion

I launched a bastion host through the AWS Management Console, connected to it with EC2 Instance Connect, and used the AWS CLI to launch a web server instance. In the optional challenge, I initially deleted the misconfigured user data before reviewing it, then used CloudTrail and CLI/cloud-init logs to recover and investigate the initialization script. The evidence I captured showed a failed `scripts-user` module and a persisted script containing `yum install -y httpd` and `systemctl enable httpd.service`. I used that evidence to guide the service checks and troubleshooting, without attributing the failure to an `httpdd` typo that was not present in the recovered script.

> Screenshot placeholder — final EC2 instance list and successful web server verification.
