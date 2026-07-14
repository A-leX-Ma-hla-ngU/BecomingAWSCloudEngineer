# User and Group Management on Linux - Documentation Journey

## Executive Summary

This documentation captures the journey of completing a comprehensive Linux user and group management lab that focused on user creation, group organization, and access control mechanisms. Over approximately 45-60 minutes, the lab provided practical hands-on experience with Linux user administration, group management, and the sudo permission system. This lab reinforced foundational Linux concepts while introducing critical system administration skills for managing multiple users and their associated permissions within a Linux environment.

---

## Introduction to Linux User and Group Management

### Context and Objectives

The lab was structured to develop practical system administration skills essential for managing users and permissions on Linux systems. The primary objectives were to gain proficiency in:

- **User Creation:** Adding new user accounts to the system
- **User Authentication:** Setting and managing user passwords
- **Group Creation:** Organizing users into logical groups
- **Group Membership:** Assigning users to appropriate groups
- **Access Control:** Understanding user permissions and restrictions
- **Sudoers System:** Understanding privileged access and sudo permissions
- **Security Logging:** Reviewing system logs for security events
- **Permission Enforcement:** Testing and validating access restrictions

**[Screenshot: Terminal Window - Initial Connection]**
> *Place screenshot of initial SSH connection to EC2 instance here*

### Lab Environment

The lab environment was accessed through an EC2 instance running Amazon Linux, providing a t3.micro instance with 1 virtual CPU and 1 GiB of memory. SSH connectivity was established using public key authentication with the provided PEM file.

**[Screenshot: AWS EC2 Dashboard - Instance Details]**
> *Place screenshot showing the t3.micro EC2 instance information here*

---

## Pre-Lab: SSH Connection Establishment

### macOS and Linux User Setup

The following steps were executed to establish secure SSH connectivity to the EC2 instance:

#### Step 1: Credentials Retrieval

The lab credentials were accessed through the Details dropdown menu:

1. Selected the Details dropdown menu above the lab instructions
2. Selected "Show" to present the Credentials window
3. Located the "Download PEM" button to retrieve the labsuser.pem file
4. Made a note of the PublicIP address for SSH connection
5. Exited the Details panel by selecting the X

**[Screenshot: Details Dropdown - Credentials Window]**
> *Place screenshot showing the credentials dropdown with PublicIP and Download PEM button here*

#### Step 2: Terminal Navigation and PEM Configuration

The terminal was opened and navigation to the PEM file location was performed:

```bash
cd ~/Downloads
```

This command changed the working directory to the Downloads folder where the labsuser.pem file was saved.

The PEM file permissions were secured using the chmod command:

```bash
chmod 400 labsuser.pem
```

This command set the file permissions to read-only for the owner, which was required for secure SSH authentication.

**[Screenshot: Terminal - Directory Navigation and chmod Command]**
> *Place screenshot showing cd and chmod command execution here*

#### Step 3: SSH Connection Establishment

The SSH connection to the EC2 instance was established:

```bash
ssh -i labsuser.pem ec2-user@<public-ip>
```

When prompted to allow the first connection, "yes" was typed to confirm.

**[Screenshot: SSH Connection Prompt]**
> *Place screenshot showing SSH host verification prompt here*

**[Screenshot: Successful SSH Connection]**
> *Place screenshot showing successful connection with ec2-user terminal prompt here*

---

## Task 1: Initial Verification

### Directory Verification

Before beginning user creation, the current working directory was verified:

```bash
pwd
```

**Output:**
```
/home/ec2-user
```

This confirmed that the user was in the correct home directory from which user management operations would be performed.

**[Screenshot: pwd Command - Home Directory Verified]**
> *Place screenshot showing the /home/ec2-user directory confirmation here*

---

## Task 2: Creating Users

### Overview and User List

This task involved creating 10 new user accounts with specific identities, roles, and initial passwords. The users were created to represent various organizational departments and roles.

#### User Creation Table

| First Name | Last Name | User ID | Job Role | Starting Password |
|-----------|----------|---------|----------|------------------|
| Alejandro | Rosalez | arosalez | Sales Manager | P@ssword1234! |
| Efua | Owusu | eowusu | Shipping | P@ssword1234! |
| Jane | Doe | jdoe | Shipping | P@ssword1234! |
| Li | Juan | ljuan | HR Manager | P@ssword1234! |
| Mary | Major | mmajor | Finance Manager | P@ssword1234! |
| Mateo | Jackson | mjackson | CEO | P@ssword1234! |
| Nikki | Wolf | nwolf | Sales Representative | P@ssword1234! |
| Paulo | Santos | psantos | Shipping | P@ssword1234! |
| Sofia | Martinez | smartinez | HR Specialist | P@ssword1234! |
| Saanvi | Sarkar | ssarkar | Finance Specialist | P@ssword1234! |

### Step 1: Creating the First User - Alejandro Rosalez

The first user, Alejandro Rosalez, was created using the useradd command:

```bash
sudo useradd arosalez
```

This command created a new user account with the username "arosalez".

**[Screenshot: sudo useradd arosalez Command]**
> *Place screenshot showing the user creation command here*

### Step 2: Setting Password for the First User

A password was set for the newly created user:

```bash
sudo passwd arosalez
```

When prompted, the password "P@ssword1234!" was entered twice (no output was displayed while typing).

**[Screenshot: sudo passwd Command - Password Entry]**
> *Place screenshot showing the password prompt here*

### Step 3: Verifying User Creation

The created users were verified by examining the /etc/passwd file:

```bash
sudo cat /etc/passwd | cut -d: -f1
```

**Output (showing created users):**
```
........
ec2-user
arosalez
```

This command displayed a list of all user accounts, with the newly created "arosalez" user visible in the output.

**[Screenshot: User Verification - arosalez Created]**
> *Place screenshot showing the verified user in the /etc/passwd output here*

### Step 4: Creating Remaining Users

The remaining 9 users were created using the same process. For each user, the following commands were executed in sequence:

```bash
sudo useradd eowusu
sudo passwd eowusu
# Repeat for: jdoe, ljuan, mmajor, mjackson, nwolf, psantos, smartinez, ssarkar
```

Each user was assigned their respective starting password: P@ssword1234!

**[Screenshot: Multiple Users Being Created]**
> *Place screenshot showing several useradd and passwd commands here*

### Step 5: Complete User List Verification

After all users were created, the complete list was verified:

```bash
sudo cat /etc/passwd | cut -d: -f1
```

**Output (showing all created users):**
```
........
ec2-user
arosalez
eowusu
jdoe
ljuan
mjackson
mmajor
nwolf
psantos
smartinez
ssarkar
```

All 10 users were confirmed to be successfully created in the system.

**[Screenshot: Complete User List Verification]**
> *Place screenshot showing all users in the /etc/passwd output here*

### Key Concepts Learned in Task 2

- **useradd:** Creating new user accounts
- **passwd:** Setting and managing user passwords
- **sudo:** Executing commands with administrative privileges
- **/etc/passwd:** System file containing user account information
- **cut command:** Extracting specific fields from text output
- **Pipe operator (|):** Directing output from one command to another

---

## Task 3: Creating and Managing Groups

### Overview and Group Structure

This task involved creating organizational groups and assigning users to these groups based on their job roles and responsibilities. Groups provided a way to manage permissions for multiple users simultaneously.

#### Groups to Create

1. Sales
2. HR
3. Finance
4. Shipping
5. Managers
6. CEO
7. Personnel

### Step 1: Verifying Starting Directory

Directory verification was performed:

```bash
pwd
```

**Output:**
```
/home/ec2-user
```

**[Screenshot: pwd - Group Management Directory Verified]**
> *Place screenshot showing directory confirmation here*

### Step 2: Creating the Sales Group

The Sales group was created as the first group:

```bash
sudo groupadd Sales
```

This command created a new group named "Sales".

**[Screenshot: sudo groupadd Sales Command]**
> *Place screenshot showing the group creation command here*

### Step 3: Verifying Group Creation

The /etc/group file was examined to verify group creation:

```bash
cat /etc/group
```

**Output (showing Sales group):**
```
...
ec2-user:x:1000:
......
Sales:x:1014
....
```

The Sales group was confirmed in the system with group ID 1014.

**[Screenshot: /etc/group File - Sales Group Verification]**
> *Place screenshot showing the group in /etc/group here*

### Step 4: Creating Remaining Groups

The remaining 6 groups were created using the same command pattern:

```bash
sudo groupadd HR
sudo groupadd Finance
sudo groupadd Shipping
sudo groupadd Managers
sudo groupadd CEO
sudo groupadd Personnel
```

**[Screenshot: Creating Multiple Groups]**
> *Place screenshot showing the group creation sequence here*

### Step 5: Verifying All Groups

All groups were verified in the /etc/group file:

```bash
cat /etc/group
```

**Output (showing all created groups):**
```
Sales:x:1014
HR:x:1015
Finance:x:1016
Shipping:x:1017
Managers:x:1018
CEO:x:1019
Personnel:x:1020
```

All 7 groups were confirmed to be successfully created.

**[Screenshot: Complete Group List Verification]**
> *Place screenshot showing all groups in /etc/group output here*

### Step 6: Adding Users to Groups - Starting with Sales

The first user, Alejandro Rosalez (arosalez), was added to the Sales group:

```bash
sudo usermod -a -G Sales arosalez
```

The `-a` flag appended the group to the user's group list, and the `-G` flag specified the group name.

**[Screenshot: sudo usermod Command - First User to Sales Group]**
> *Place screenshot showing the usermod command here*

### Step 7: Verifying User in Group

Group membership was verified by checking the /etc/group file:

```bash
cat /etc/group
```

**Output (showing arosalez in Sales):**
```
....
Sales:x:1014:arosalez
....
```

The user arosalez was confirmed as a member of the Sales group.

**[Screenshot: /etc/group - User Added to Sales Group]**
> *Place screenshot showing group membership verification here*

### Step 8: Adding All Users to Appropriate Groups

All remaining users were added to their respective groups according to the organizational structure:

#### Group Assignments:

| Group | User IDs |
|-------|----------|
| Sales | arosalez, nwolf, ec2-user |
| HR | ljuan, smartinez, ec2-user |
| Finance | mmajor, ssarkar, ec2-user |
| Shipping | eowusu, jdoe, psantos, ec2-user |
| Managers | arosalez, ljuan, mmajor, ec2-user |
| CEO | mjackson, ec2-user |
| Personnel | (all users) |

For each user-group combination, the command was executed:

```bash
sudo usermod -a -G Sales arosalez
sudo usermod -a -G Sales nwolf
sudo usermod -a -G HR ljuan
sudo usermod -a -G HR smartinez
# ... and so on for all users and groups
```

**[Screenshot: Adding Multiple Users to Groups]**
> *Place screenshot showing the sequence of usermod commands here*

### Step 9: Verifying Complete Group Structure

The final group structure was verified:

```bash
sudo cat /etc/group
```

**Output (showing all users in groups):**
```
Sales:x:1014:arosalez,nwolf,ec2-user
HR:x:1015:ljuan,smartinez,ec2-user
Finance:x:1016:mmajor,ssarkar,ec2-user
Shipping:x:1017:eowusu,jdoe,psantos,ec2-user
Managers:x:1018:arosalez,ljuan,mmajor,ec2-user
CEO:x:1019:mjackson,ec2-user
Personnel:x:1020:(all users)
```

The complete organizational structure was verified with all users properly assigned to their respective groups. Note that some users belonged to multiple groups (e.g., arosalez in both Sales and Managers groups).

**[Screenshot: Complete Group Membership Structure]**
> *Place screenshot showing all users in their groups here*

### Key Concepts Learned in Task 3

- **groupadd:** Creating new groups
- **usermod:** Modifying user properties and group membership
- **-a flag:** Appending to existing group list
- **-G flag:** Specifying groups for usermod
- **/etc/group:** System file containing group information
- **Multiple Group Membership:** Users can belong to multiple groups
- **Group Organization:** Logical grouping for permission management

---

## Task 4: User Login and Permission Testing

### Overview

This task involved logging in as a newly created user to test permissions, understand access restrictions, and observe how the sudo system works. The task demonstrated the difference between regular user permissions and administrative (sudoer) permissions.

### Step 1: Switching to User arosalez

The user arosalez was accessed using the `su` (switch user) command:

```bash
su arosalez
```

When prompted for the password, "P@ssword1234!" was entered.

**Output:**
```
[arosalez@ec2-user]$
```

The prompt changed to indicate the user was now logged in as arosalez, while still in the ec2-user home directory.

**[Screenshot: su arosalez Command - User Switch]**
> *Place screenshot showing the user switch and new prompt here*

### Step 2: Verifying Current Directory

The current working directory was confirmed:

```bash
pwd
```

**Output:**
```
/home/ec2-user
```

This confirmed that despite switching users, the session remained in the ec2-user home directory.

**[Screenshot: pwd - Current Directory in arosalez Session]**
> *Place screenshot showing directory verification here*

### Step 3: Testing File Creation - Permission Denied

An attempt was made to create a file in the ec2-user home directory:

```bash
touch myFile.txt
```

**Output:**
```
touch: cannot touch 'myFile.txt': Permission denied
```

The user arosalez did not have write permissions in the ec2-user home directory, resulting in a permission denied error. This demonstrated access control in action.

**[Screenshot: touch Command - Permission Denied Error]**
> *Place screenshot showing the permission denied message here*

### Step 4: Attempting Sudo Command - Not in Sudoers File

An attempt was made to create the file using sudo:

```bash
sudo touch myFile.txt
```

When prompted for the password, "P@ssword1234!" was entered.

**Output:**
```
arosalez is not in the sudoers file.  This incident will be reported.
```

The user arosalez was not on the sudoers list, meaning they did not have administrative privileges to execute commands with sudo. The system logged this unauthorized sudo attempt.

**[Screenshot: sudo Touch Command - Not in Sudoers Error]**
> *Place screenshot showing the sudoers file error here*

### Step 5: Returning to ec2-user

The session was returned to the ec2-user account:

```bash
exit
```

This command exited the arosalez session and returned to the ec2-user prompt.

**[Screenshot: exit Command - Return to ec2-user]**
> *Place screenshot showing the exit command and returned prompt here*

### Step 6: Reviewing Security Logs

The system's security log was examined to view logged security events:

```bash
sudo cat /var/log/secure
```

The output was scrolled to the bottom using the down arrow to view the most recent events.

**Output (showing unauthorized sudo attempt):**
```
Aug  9 14:45:55 ip-10-0-10-217 sudo: arosalez : user NOT in sudoers ; TTY=pts/1 ; PWD=/home/ec2-user ; USER=root ; COMMAND=/bin/touch myFile.txt
```

This log entry documented:
- **Timestamp:** Aug 9 14:45:55
- **System:** ip-10-0-10-217
- **User:** arosalez
- **Status:** User NOT in sudoers
- **Terminal:** pts/1
- **Working Directory:** /home/ec2-user
- **Target User:** root
- **Command Attempted:** /bin/touch myFile.txt

The log demonstrated that all sudo attempts, even unauthorized ones, were recorded for security auditing purposes.

**[Screenshot: /var/log/secure - Unauthorized Sudo Attempt Logged]**
> *Place screenshot showing the security log entry here*

### Key Concepts Learned in Task 4

- **su (switch user):** Changing to a different user account
- **Permission Restrictions:** User limitations in file operations
- **Sudoers File:** System file controlling who can use sudo
- **sudo Limitations:** Users not in sudoers cannot execute privileged commands
- **/var/log/secure:** Security log file for authentication and authorization events
- **Security Logging:** All unauthorized attempts are recorded
- **Access Control:** Linux file and directory permission enforcement

---

## Key Learnings and Best Practices

### User Account Management

The lab demonstrated essential user administration concepts:

- **User Creation:** The useradd command creates new user accounts
- **Password Management:** The passwd command sets and manages user passwords
- **Password Security:** Passwords should be strong and unique per user
- **Initial Setup:** Default passwords should be changed by users on first login

### Group Management and Organization

Important group management principles were reinforced:

- **Logical Grouping:** Groups organize users by department, role, or function
- **Multiple Memberships:** Users can belong to multiple groups for flexibility
- **Permission Delegation:** Groups simplify permission management for multiple users
- **Scalability:** Groups make it easier to manage permissions as the organization grows

### Access Control and Permissions

Critical access control concepts were demonstrated:

- **User Isolation:** Users cannot access files or directories without proper permissions
- **Home Directories:** Users have write access to their own home directories only
- **Directory Ownership:** Directory owners control who can write to their directories
- **Permission Hierarchy:** Linux enforces a strict permission model

### Sudoers and Privileged Access

The sudo system was thoroughly explored:

- **Limited Privileges:** Not all users should have sudo access
- **Administrative Functions:** Only authorized users should perform system administration
- **Principle of Least Privilege:** Users should have only the minimum permissions needed
- **Security Logging:** Unauthorized sudo attempts are always logged

### Security and Auditing

Security best practices were demonstrated:

- **/var/log/secure:** All security events are logged to this file
- **Audit Trail:** Logging enables identification of unauthorized access attempts
- **Incident Investigation:** Security logs help investigate security incidents
- **Compliance:** Logging supports regulatory compliance requirements

---

## Conclusion

The completion of this lab provided comprehensive hands-on experience with Linux user and group management. The journey covered:

1. **User creation** through the useradd and passwd commands
2. **Group organization** using groupadd for logical user grouping
3. **Group membership** through usermod for assigning users to groups
4. **User authentication** by logging in as different users
5. **Permission testing** by observing access restrictions
6. **Sudoers system** understanding who can execute privileged commands
7. **Security logging** reviewing system logs for security events

These skills are foundational for Linux system administration, enabling proper management of users, groups, and access control in multi-user environments.

**Lab Duration:** Approximately 45-60 minutes  
**Status:** Successfully Completed  
**Key Achievement:** Demonstrated proficiency in user and group management, access control implementation, and understanding of the Linux security model through hands-on user administration tasks.

---

## Appendix: Essential User and Group Management Commands

### User Management Commands

```bash
# Create a new user
sudo useradd username

# Set password for a user
sudo passwd username

# Display user information
sudo cat /etc/passwd | cut -d: -f1

# Switch to a different user
su username

# Return to previous user
exit

# Display user ID and group information
id username

# Modify user properties
sudo usermod [options] username

# Delete a user
sudo userdel username
```

### Group Management Commands

```bash
# Create a new group
sudo groupadd groupname

# Display all groups
cat /etc/group

# Add user to a group
sudo usermod -a -G groupname username

# Add user to multiple groups
sudo usermod -a -G group1,group2,group3 username

# Display group membership for a user
groups username

# Delete a group
sudo groupdel groupname
```

### File and Directory Permissions

```bash
# Change file permissions
chmod permissions filename

# Change file ownership
chown owner:group filename

# View detailed file listing with permissions
ls -l

# Create a file
touch filename
```

### System Files Related to Users and Groups

```bash
# User account information
/etc/passwd

# User passwords (encrypted)
/etc/shadow

# Group information
/etc/group

# Users allowed to use sudo
/etc/sudoers

# Security log file
/var/log/secure

# System log file
/var/log/messages
```

### Viewing System Logs

```bash
# View security log
sudo cat /var/log/secure

# View with pagination
sudo less /var/log/secure

# View last 10 lines
sudo tail /var/log/secure

# Search for specific entries
sudo grep "sudo" /var/log/secure
```

### File Permissions Notation

| Permission | Numeric | Meaning |
|-----------|---------|---------|
| r (read) | 4 | View file contents |
| w (write) | 2 | Modify file contents |
| x (execute) | 1 | Run file as program |
| --- (none) | 0 | No permissions |

---

## Appendix: User and Group Organizational Structure

### User Directory

| User ID | Full Name | Job Role | Groups |
|---------|-----------|----------|--------|
| arosalez | Alejandro Rosalez | Sales Manager | Sales, Managers |
| eowusu | Efua Owusu | Shipping | Shipping |
| jdoe | Jane Doe | Shipping | Shipping |
| ljuan | Li Juan | HR Manager | HR, Managers |
| mmajor | Mary Major | Finance Manager | Finance, Managers |
| mjackson | Mateo Jackson | CEO | CEO |
| nwolf | Nikki Wolf | Sales Representative | Sales |
| psantos | Paulo Santos | Shipping | Shipping |
| smartinez | Sofia Martinez | HR Specialist | HR |
| ssarkar | Saanvi Sarkar | Finance Specialist | Finance |
| ec2-user | AWS Default User | System User | All Groups |

### Group Structure

| Group Name | Members | Purpose |
|-----------|---------|---------|
| Sales | arosalez, nwolf, ec2-user | Sales department |
| HR | ljuan, smartinez, ec2-user | Human Resources department |
| Finance | mmajor, ssarkar, ec2-user | Finance department |
| Shipping | eowusu, jdoe, psantos, ec2-user | Shipping/Logistics department |
| Managers | arosalez, ljuan, mmajor, ec2-user | Management team members |
| CEO | mjackson, ec2-user | Executive leadership |
| Personnel | All users | All organizational personnel |

