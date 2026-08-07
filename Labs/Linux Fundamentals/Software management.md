# Software management (Linux Fundamentals)

This document described the journey through the "Software management" lab. It was written in past tense and it documented the steps that had been completed during the lab. It left explicit placeholders for screenshots of the most important aspects of the lab so they could be added later in the repository's images folder.

## Summary

I had updated an Amazon Linux / Red Hat-based EC2 instance using the yum package manager, reviewed and rolled back a package update using yum history, installed the AWS CLI from the AWS distribution, and configured the AWS CLI with the temporary credentials provided by the lab.

## Objectives

The lab objectives were:
- I updated the Linux machine using the package manager.
- I rolled back (downgraded) a previously updated package using the package manager history/undo features.
- I installed and configured the AWS Command Line Interface (AWS CLI).

## Duration

This lab required approximately 35 minutes to complete.

## macOS and Linux users — SSH access

These instructions were specifically for macOS/Linux users. If someone was using Windows they were instructed to follow the Windows-specific steps elsewhere.

I connected to the EC2 instance as follows:

1. I opened the Details drop-down in the lab interface, selected Show, and downloaded the PEM key (labsuser.pem).
2. I noted the instance Public IP from the lab details.
3. In a terminal I changed to the directory where labsuser.pem had been saved, for example:

```bash
cd ~/Downloads
```

4. I set secure permissions on the key:

```bash
chmod 400 labsuser.pem
```

5. I connected to the instance (replacing <public-ip> with the instance Public IP):

```bash
ssh -i labsuser.pem ec2-user@<public-ip>
```

6. I accepted the host fingerprint by answering "yes" on the first connection. Because I used a key pair for authentication, I was not prompted for a password.

> Screenshot placeholder: SSH connection terminal
>
> ![SSH Terminal placeholder](images/software_ssh.png)
>
> Caption: Insert the SSH connection screenshot here.

---

## Task: Update your Linux machine with yum

I used yum to check for updates, apply security updates, and perform a full upgrade.

1. I verified I was in the appropriate directory (companyA home folder in the lab):

```bash
pwd
# If needed: cd companyA
```

2. I queried available updates:

```bash
sudo yum -y check-update
```

3. I applied security-related updates:

```bash
sudo yum update --security
```

4. I upgraded packages to the latest available versions:

```bash
sudo yum -y upgrade
```

- Expected outcome: yum listed the packages to be updated and then completed the upgrade.

> Screenshot placeholder: yum upgrade output
>
> ![yum upgrade placeholder](images/yum_upgrade.png)
>
> Caption: Insert the terminal screenshot showing the results of `sudo yum -y upgrade`.

> Note: The instance might already have been up to date; running these commands was still valid for practice.

5. I installed httpd to demonstrate package installation and to view the yum history (optional):

```bash
sudo yum install httpd -y
```

> Screenshot placeholder: yum install httpd and history summary
>
> ![yum install placeholder](images/yum_install_httpd.png)
>
> Caption: Insert the terminal screenshot showing `yum install httpd` and history output.

---

## Task: Roll back (undo) a package transaction using yum history

I inspected yum's transaction history and rolled back a specific transaction.

1. I viewed the yum history list to identify transaction IDs:

```bash
sudo yum history list
```

- I noted the transaction ID (the number in the ID column) for the transaction I wanted to undo.

> Screenshot placeholder: yum history list
>
> ![history list placeholder](images/history_list.png)
>
> Caption: Insert the terminal screenshot showing `sudo yum history list` output with transaction IDs.

Example snippet of the list:

```
[ec2-user@ companyA]$ sudo yum history list
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
ID  | Login user            | Date and time     | Action(s) | Altered
------------------------------------------------------------
2   | EC2 ... <ec2-user>    | <date and time>   | Install   | 9
1   | System <unset>        | <date and time>   | I, O, U   | 18
```

2. I inspected a specific transaction in detail to confirm what it had changed:

```bash
sudo yum history info <ID>
```

> Screenshot placeholder: yum history info output
>
> ![history info placeholder](images/history_info.png)
>
> Caption: Insert the terminal screenshot showing `sudo yum history info <ID>` output.

Example output fields that were shown:

```
Transaction ID  : <ID>
Begin time      : <date and time>
Begin rpmdb     :
End time        : <time>
End rpmdb       :
User            : EC2 Default User <ec2-user>
Return-Code     : Success
Command Line    : install httpd -y
```

3. I undid the transaction (rolled back the changes) by running:

```bash
sudo yum -y history undo <ID>
```

- Expected outcome: yum listed the packages that would be removed or restored as dependency operations (Dep-Install / Dep-Remove) and completed the undo.

> Screenshot placeholder: yum history undo output
>
> ![history undo placeholder](images/history_undo.png)
>
> Caption: Insert the terminal screenshot showing the output of `sudo yum -y history undo <ID>`.

Example undo output excerpt:

```
[ec2-user@ companyA]$ sudo yum -y history undo <ID>
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
Undoing transaction <ID>, from <date>
<list of actions now shown as Dep-Install>
```

---

## Task: Install the AWS CLI on Linux

I installed the AWS CLI v2 using the official AWS zip distribution and verified it was functioning.

1. I checked the installed Python version (AWS CLI v2 bundles its own runtime for the official installers, but the lab checked Python and pip):

```bash
python3 --version
pip3 --version  # or pip3 if pip is available
```

> Screenshot placeholder: python and pip version checks
>
> ![python pip placeholder](images/python_pip.png)
>
> Caption: Insert the terminal screenshot showing python3 and pip3 versions (or pip not found).

2. I downloaded the AWS CLI v2 bundle with curl:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

> Screenshot placeholder: curl download awscliv2.zip
>
> ![awscli download placeholder](images/awscli_download.png)
>
> Caption: Insert the terminal screenshot showing the wget/curl download progress.

3. I unzipped the installer:

```bash
unzip awscliv2.zip
```

> Screenshot placeholder: unzip awscliv2.zip
>
> ![awscli unzip placeholder](images/awscli_unzip.png)
>
> Caption: Insert the terminal screenshot showing the unzip output.

4. I ran the installer with sudo (the default install path was /usr/local/aws-cli and /usr/local/bin was linked):

```bash
sudo ./aws/install
```

> Screenshot placeholder: aws cli install output
>
> ![awscli install placeholder](images/awscli_install.png)
>
> Caption: Insert the terminal screenshot showing the installer output.

5. I verified that the AWS CLI was working:

```bash
aws help
# press q to exit the help pager
```

> Screenshot placeholder: aws help output
>
> ![awscli help placeholder](images/awscli_help.png)
>
> Caption: Insert the terminal screenshot showing the `aws help` output.

---

## Task: Configure the AWS CLI with lab credentials

I configured the AWS CLI so it could perform API calls using the temporary credentials supplied by the lab.

1. I opened the Details panel in the lab interface and copied the AWS CLI credentials (aws_access_key_id, aws_secret_access_key, aws_session_token) shown in the Credentials window.

> Screenshot placeholder: credentials from details panel
>
> ![credentials placeholder](images/credentials_show.png)
>
> Caption: Insert the screenshot of the lab Details panel showing the AWS CLI credentials.

2. I ran the interactive `aws configure` command to set defaults:

```bash
aws configure
# For Access Key ID: left blank (or enter the provided ID)
# For Secret Access Key: left blank (or enter the provided secret)
# For Default region name: us-west-2
# For Default output format: json
```

3. I edited the `~/.aws/credentials` file (using sudo or the current user as appropriate) and pasted the full credentials block including the session token. Example credentials file contents:

```ini
[default]
aws_access_key_id=<your access key ID>
aws_secret_access_key=<your secret access key>
aws_session_token=<your session token>
```

> Screenshot placeholder: ~/.aws/credentials with pasted credentials
>
> ![aws credentials placeholder](images/aws_credentials.png)
>
> Caption: Insert the terminal or editor screenshot showing the credentials file.

4. I saved the file and exited the editor.

---

## Task: Verify AWS CLI connectivity — describe an instance attribute

I retrieved my instance ID from the AWS Console (or stored it earlier) and then verified the AWS CLI could describe the instance attribute.

1. I opened the AWS Management Console (AWS button at the top of the lab UI), navigated to EC2 -> Instances, and copied the Instance ID for the Command Host.

> Screenshot placeholder: EC2 Instances page showing the instance ID
>
> ![ec2 instance placeholder](images/ec2_instance.png)
>
> Caption: Insert the screenshot of the EC2 Instances list with the instance ID.

2. I ran the following AWS CLI command, replacing the instance ID with the value I had copied:

```bash
aws ec2 describe-instance-attribute --instance-id i-1234567890abcdefg --attribute instanceType
```

- Expected JSON output returned the instance ID and its instanceType.Value field, for example:

```json
{
  "InstanceId": "i-1234567890abcdefg",
  "InstanceType": {
    "Value": "t3.micro"
  }
}
```

> Screenshot placeholder: aws ec2 describe-instance-attribute output
>
> ![describe instance placeholder](images/describe_instance.png)
>
> Caption: Insert the terminal screenshot showing the JSON output from the `aws ec2 describe-instance-attribute` command.

---

## Notes and tips

- The yum `history` commands were powerful for auditing and reverting package changes, but they should be used with caution in production environments. I noted the transaction ID carefully before running `yum history undo`.
- The AWS CLI installer that I used created a symlink in `/usr/local/bin` by default; ensure `/usr/local/bin` was in your PATH.
- The lab-provided credentials were temporary session credentials (included a session token). I made sure to paste the full block into `~/.aws/credentials` so commands operated in the lab account.

## Screenshots and images

I left explicit image placeholders and recommended filenames in the `Labs/Linux Fundamentals/images/` folder so maintainers could add screenshots to render inline. Recommended filenames:

- images/software_ssh.png
- images/yum_upgrade.png
- images/yum_install_httpd.png
- images/history_list.png
- images/history_info.png
- images/history_undo.png
- images/python_pip.png
- images/awscli_download.png
- images/awscli_unzip.png
- images/awscli_install.png
- images/awscli_help.png
- images/credentials_show.png
- images/aws_credentials.png
- images/ec2_instance.png
- images/describe_instance.png

Place these files in `Labs/Linux Fundamentals/images/` to have them render inline in this document.

---

What I added to the repository

I saved this document as `Labs/Linux Fundamentals/Software management.md` so the lab documentation lived with the other Linux Fundamentals labs. The file was written in past tense, included clear instructions and expected outputs, and left placeholders for screenshots.

If you wanted, I could also:
- Upload screenshots you provide into Labs/Linux Fundamentals/images/ and update the markdown to render them.
- Add a sample `backup` or `hello` script or other sample files to the repo used in the lab.
- Split this into a printable quick-reference and a longer lab guide.
