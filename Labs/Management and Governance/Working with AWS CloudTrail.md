# Working with AWS CloudTrail

## Activity overview

This activity showed how AWS CloudTrail recorded account activity and how its event history could be used to investigate a website compromise. I created a trail, analyzed its logs with Linux command-line tools and the AWS CLI, queried the logs with Amazon Athena, and removed the compromised user's access from the AWS account and the Café Web Server.

The activity began with an EC2 instance named **Café Web Server**, which hosted the Café website. The website initially appeared normal. After I created the CloudTrail trail, the website was changed and the web server's security group was modified to allow SSH from any IPv4 address. I used the audit logs to investigate the activity, then secured the host, security group, and AWS account.

**Approximate duration:** 75 minutes

## Objectives completed

- I configured a CloudTrail trail.
- I analyzed CloudTrail logs using Linux tools and the AWS CLI.
- I created an Athena table for CloudTrail log data and queried it.
- I identified the user, time, source IP address, and access method associated with the suspicious security group change.
- I removed unauthorized access and restored the website.

## Business scenario

The Café leadership team had asked me to investigate who modified the website and to reduce the chance of another compromise. I acted as the investigator, using CloudTrail as an audit source to trace changes and identify the responsible user.

> **Screenshot placeholder — Activity architecture:**
<img width="734" height="389" alt="Screenshot 2026-11-07 at 19 56 43" src="https://github.com/user-attachments/assets/b8369641-7e37-4b39-82f4-faed9b3d5f3e" />

> **Screenshot placeholder — Café website before and after:**
<img width="851" height="867" alt="Screenshot 2026-11-07 at 20 36 07" src="https://github.com/user-attachments/assets/dcf39666-1d45-4922-b855-ab5f95a0d22c" />

## Task 1: Inspected the security group and website

In the EC2 console, I opened **Instances**, selected **Café Web Server**, and inspected its security group. The inbound rules initially included HTTP access over TCP port 80. I added a temporary SSH rule for TCP port 22, with the source set to **My IP**. I verified that the source used my individual address with a `/32` CIDR mask rather than `0.0.0.0/0`, and saved the rule.

I copied the instance's public IPv4 address and opened `http://<WebServerIP>/cafe/` in a browser. The Café website appeared normal at that point.

> **Screenshot placeholder — Initial security group rule:**

<img width="835" height="626" alt="Screenshot 2026-11-07 at 20 32 54" src="https://github.com/user-attachments/assets/7e2dd366-ba1c-49eb-bbbe-e9b816e1616c" />

<img width="813" height="565" alt="Screenshot 2026-11-07 at 20 33 19" src="https://github.com/user-attachments/assets/c103002f-50fa-4032-baa0-7c5548977c43" />

> **Screenshot placeholder — Website before the incident:** Add a screenshot showing the original Café website.

## Task 2: Created a CloudTrail trail and observed the incident

### Created the trail

In the CloudTrail console, I opened **Trails** and created a trail with these settings:

| Setting | Value |
| --- | --- |
| Trail name | `monitor` |
| S3 bucket | A new bucket named `monitoring####`, using four unique digits |
| AWS KMS alias | My initials followed by `-KMS` |

I continued through the log event and review pages and created the trail. I confirmed that `monitor` appeared on the Trails page. I ignored the lab's organization-trail and AWS Organizations notices because the lab account did not require an organization trail.

### Observed the modified website and security group

After allowing time for the lab event to occur, I refreshed the Café website, bypassing the browser cache when necessary. The site had been altered. I inspected the EC2 instance's security group and found an additional inbound rule that allowed SSH from `0.0.0.0/0`. That rule was distinct from my restricted SSH rule and exposed the instance to SSH attempts from any IPv4 address.

> **Screenshot placeholder — CloudTrail trail:**
<img width="838" height="682" alt="Screenshot 2026-11-07 at 20 40 38" src="https://github.com/user-attachments/assets/b78403c3-dde1-4eea-8481-bf9c51306cae" />
<img width="851" height="694" alt="Screenshot 2026-11-07 at 20 42 11" src="https://github.com/user-attachments/assets/a4cc577d-dbef-4535-97be-fbe92d8b6599" />

> **Screenshot placeholder — Altered website:**
<img width="857" height="805" alt="Screenshot 2026-11-07 at 20 44 34" src="https://github.com/user-attachments/assets/a4c0276f-b519-4b92-b0c5-dbca013c5190" />

> **Screenshot placeholder — Unexpected SSH rule:**
 <img width="836" height="470" alt="Screenshot 2026-11-07 at 20 48 44" src="https://github.com/user-attachments/assets/ddb5a89f-1458-423a-b623-50260d801eff" />

## Task 3: Investigated CloudTrail logs

### Connected to the web server and downloaded the logs

I connected to the Café Web Server using the lab-provided credentials and the appropriate key format for my operating system. For macOS or Linux, I set the PEM file permissions and connected over SSH; for Windows, I used the lab's PPK file with PuTTY. I kept the private key secure and did not add it to this documentation.

On the server, I created a working directory and listed the available S3 buckets:

```bash
mkdir ctraillogs
cd ctraillogs
aws s3 ls
```

I used the actual `monitoring####` bucket name returned by the command to copy the logs:

```bash
aws s3 cp s3://<monitoring-bucket-name>/ . --recursive
```

CloudTrail delivered log files to S3 periodically, so I waited and retried if no files had arrived yet. I navigated to the downloaded `AWSLogs/<account-id>/CloudTrail/<region>/<year>/<month>/<day>` directory, then extracted the compressed files:

```bash
gunzip *.gz
```

I inspected a JSON log and formatted it for readability:

```bash
cat <filename.json> | python -m json.tool
```

CloudTrail records included fields such as `awsRegion`, `eventName`, `eventSource`, `eventTime`, `requestParameters`, `sourceIPAddress`, and `userIdentity`.

> **Screenshot placeholder — Downloaded CloudTrail logs:**
<img width="901" height="71" alt="Screenshot 2026-11-07 at 21 25 50" src="https://github.com/user-attachments/assets/709f22ce-6c55-4835-876b-a4d57c69ed46" />
<img width="1680" height="1050" alt="Screenshot 2026-11-07 at 21 14 02" src="https://github.com/user-attachments/assets/4208bc40-f236-4823-a330-fa84d1384b38" />
<img width="871" height="124" alt="Screenshot 2026-11-07 at 21 22 35" src="https://github.com/user-attachments/assets/c85acaae-51d8-4e6c-a93d-2e15372f0369" />
<img width="881" height="252" alt="Screenshot 2026-11-07 at 21 23 34" src="https://github.com/user-attachments/assets/1a76090d-e60d-4b36-be1b-eaf61a99fa27" />

> **Screenshot placeholder — Formatted CloudTrail event:**
<img width="901" height="761" alt="Screenshot 2026-11-07 at 21 29 30" src="https://github.com/user-attachments/assets/9edb4009-0912-44cb-8d17-c5a6dccd2b57" />

### Searched the logs with grep

I used the web server's public IP as a search value and reviewed source IPs and event names in the log files:

```bash
ip=<WebServerIP>
for i in $(ls); do echo "$i" && cat "$i" | python -m json.tool | grep sourceIPAddress; done
for i in $(ls); do echo "$i" && cat "$i" | python -m json.tool | grep eventName; done
```

The search helped me narrow the records, but the JSON output contained many events. I used the AWS CLI and Athena for more targeted searches.

### Searched CloudTrail with the AWS CLI

I checked for console login events:

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=ConsoleLogin
```

I then searched events associated with EC2 security groups:

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=ResourceType,AttributeValue=AWS::EC2::SecurityGroup \
  --output text
```

To focus on the web server's security group, I determined the instance's Region and security group ID:

```bash
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | cut -d '"' -f4)
sgId=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=Cafe Web Server" \
  --query 'Reservations[*].Instances[*].SecurityGroups[*].[GroupId]' \
  --region "$region" --output text)
echo "$sgId"
```

I filtered the security group events for that group ID:

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=ResourceType,AttributeValue=AWS::EC2::SecurityGroup \
  --region "$region" --output text | grep "$sgId"
```

> **Screenshot placeholder — AWS CLI investigation:** Add a screenshot showing the filtered security group event. Redact account IDs and any unrelated sensitive details.

## Task 4: Queried CloudTrail logs with Athena

### Created the Athena table

From the CloudTrail **Event history** page, I selected **Create Athena table** and chose the `monitoring####` S3 bucket as the storage location. I reviewed the generated external table definition, which mapped CloudTrail JSON fields to Athena columns, and created the table.

I opened Athena, selected the generated `cloudtrail_logs_monitoring####` table, and configured the query result location as:

```text
s3://monitoring####/results/
```

I replaced `####` with the digits in my actual bucket name.

> **Screenshot placeholder — Athena table creation:** Add a screenshot showing the CloudTrail S3 location and generated table name.
>
> **Screenshot placeholder — Athena query result location:** Add a screenshot of the configured S3 results location. Redact account information if necessary.

### Queried the event data

I first previewed a small number of records:

```sql
SELECT *
FROM cloudtrail_logs_monitoring####
LIMIT 5;
```

I then selected fields that were useful for identifying changes and actors:

```sql
SELECT
    useridentity.userName,
    eventtime,
    eventsource,
    eventname,
    requestparameters
FROM cloudtrail_logs_monitoring####
LIMIT 30;
```

To focus the investigation, I filtered for EC2 events and security-related event names. I removed the `LIMIT` when I needed to search the full log set. For example:

```sql
SELECT
    useridentity.userName,
    eventtime,
    eventsource,
    eventname,
    sourceipaddress,
    requestparameters
FROM cloudtrail_logs_monitoring####
WHERE eventsource = 'ec2.amazonaws.com'
  AND eventname LIKE '%Security%'
ORDER BY eventtime DESC;
```

I examined the matching event details to identify the AWS user, exact event time, source IP address, and whether the action had been performed through the console or programmatic access. I saved the source IP address for the remediation work and kept it out of public screenshots if it was sensitive.

> **Screenshot placeholder — Athena investigation query:** Add a screenshot showing the query used to filter EC2 security events.
>
> **Screenshot placeholder — Identified CloudTrail event:** Add a screenshot showing the relevant actor, time, source IP, event name, and access method. Redact values that should not be shared publicly.

## Task 5: Removed unauthorized access and secured the environment

### Removed the unauthorized operating-system user

In the active SSH session, I reviewed recent authentication activity and current logins:

```bash
sudo aureport --auth
who
```

I found the unexpected `chaos-user` account. Because it was still logged in, I attempted to remove it and noted the process ID reported by the system:

```bash
sudo userdel -r chaos-user
```

I stopped the active session using the reported process ID, verified the account was no longer logged in, and removed the account:

```bash
sudo kill -9 <process-id>
who
sudo userdel -r chaos-user
```

I reviewed login-capable accounts and confirmed that the remaining standard Amazon Linux accounts were expected:

```bash
sudo cat /etc/passwd | grep -v nologin
```

> **Screenshot placeholder — OS account investigation:** Add a screenshot showing the unexpected account and its removal. Redact unrelated account details.

### Hardened SSH access

I checked the SSH daemon configuration file and found that it had recently been modified. I edited `/etc/ssh/sshd_config`, disabled password authentication, and enabled key-based authentication by setting:

```text
PasswordAuthentication no
```

I saved the file and restarted the SSH service:

```bash
sudo service sshd restart
```

If the restart interrupted the session, I reconnected using the authorized key. In the EC2 security group, I removed the unexpected SSH rule whose source was `0.0.0.0/0` and retained only the restricted SSH rule needed for the lab.

> **Screenshot placeholder — Hardened SSH configuration:** Add a screenshot showing `PasswordAuthentication no`, without exposing host details.
>
> **Screenshot placeholder — Corrected security group:** Add a screenshot showing that the unrestricted SSH ingress rule had been removed.

### Restored the website

I reviewed the Café image directory and found a backup of the original image. I restored it and refreshed the website while bypassing the browser cache:

```bash
cd /var/www/html/cafe/images/
ls -l
sudo mv Coffee-and-Pastries.backup Coffee-and-Pastries.jpg
```

I reloaded `http://<WebServerIP>/cafe/` and verified that the expected image appeared again.

> **Screenshot placeholder — Restored Café website:** Add a screenshot showing the corrected website.

### Removed the compromised IAM user

In the IAM console, I opened **Users**, selected the lab's `chaos` user, and deleted it after confirming the username. This removed that user's AWS account access.

> **Screenshot placeholder — IAM user removal:** Add a screenshot showing the user deletion confirmation or updated user list. Do not include unrelated user information.

## Activity completion

I used CloudTrail and Athena to trace the suspicious security group modification, identified the responsible user and source, removed unauthorized OS and IAM access, hardened SSH settings, removed public SSH access, and restored the Café website. The Café team recognized CloudTrail as an important tool for ongoing account auditing.

> **Cleanup reminder:** I ended the lab after completing the investigation and remediation. I kept private keys and credentials secure and removed lab resources when instructed.
