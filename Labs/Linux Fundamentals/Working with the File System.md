# Working with the File System - Documentation Journey

## Executive Summary

This documentation captures the journey of completing a hands-on Linux file system lab that focused on practical file and directory management. Over approximately 30 minutes, the lab provided essential experience with creating folder structures, manipulating files and directories, and organizing data hierarchically using Linux command-line tools. This lab built upon previously acquired Linux fundamentals and SSH connectivity knowledge to reinforce file system management capabilities.

---

## Introduction to Linux File System Management

### Context and Objectives

The lab was structured as a minor adventure that combined foundational Linux knowledge with practical file system operations. The primary objective was to develop proficiency in the following core file system tasks:

- **Directory Creation:** Building multi-level folder hierarchies
- **File Creation:** Generating empty files with specific naming conventions
- **File Operations:** Copying, moving, and organizing files and directories
- **Destructive Operations:** Safely deleting files and directories
- **Verification:** Using command-line tools to validate file system structure

**[Screenshot: Terminal Window - Initial Connection]**
> *Place screenshot of initial SSH connection to EC2 instance here*

### Lab Environment Setup

The lab environment was accessed through the AWS Management Console, which provided credentials for SSH access to an EC2 instance running Amazon Linux. The connection was established using public key cryptography with the provided PEM file.

**[Screenshot: Lab Credentials Panel]**
> *Place screenshot of the credentials dropdown showing PublicIP and PEM file download here*

---

## Pre-Lab: SSH Connection Establishment

### Credentials Preparation (macOS/Linux Users)

The following steps were executed to establish secure SSH connectivity:

#### Step 1: Credential Retrieval

The lab credentials were accessed through the Details dropdown menu, which revealed:
- The EC2 instance's public IP address
- A downloadable PEM file (labsuser.pem) for authentication

**[Screenshot: Details Dropdown with Credentials]**
> *Place screenshot showing the credentials window with Download PEM button here*

#### Step 2: PEM File Configuration

The downloaded labsuser.pem file was configured for secure SSH authentication:

```bash
cd ~/Downloads
chmod 400 labsuser.pem
```

The `chmod 400` command was executed to:
- Restrict permissions to read-only for the owner
- Prevent unauthorized access to the private key
- Meet SSH's security requirement for key pair permissions

**[Screenshot: Terminal - PEM File Permission Change]**
> *Place screenshot showing chmod command execution here*

#### Step 3: SSH Connection

The SSH connection was established using the following command syntax:

```bash
ssh -i labsuser.pem ec2-user@<public-ip>
```

Upon first connection, a host verification prompt was presented. The connection was confirmed by typing "yes" when prompted to allow the first connection to the remote SSH server.

**[Screenshot: SSH Connection Prompt]**
> *Place screenshot showing SSH host verification prompt here*

**[Screenshot: Successful SSH Connection]**
> *Place screenshot showing successful ec2-user connection and terminal prompt here*

---

## Task 1: Initial Verification and Navigation

### Current Directory Assessment

Upon successful SSH connection, the current working directory was verified to confirm proper positioning in the file system:

```bash
pwd
```

The output confirmed that the user was located in `/home/ec2-user`, the home directory for the ec2-user account.

**[Screenshot: pwd Command Output]**
> *Place screenshot showing pwd output confirming /home/ec2-user directory here*

### Initial ls Command

The current directory contents were listed to verify the starting state of the file system:

```bash
ls
```

The directory was noted to contain existing files and folders from previous lab sessions, which served as reference material for the current lab tasks.

---

## Task 2: Creating a Folder Structure

### Objective and Structure Overview

The task was to recreate a specific organizational folder structure representing a fictional company's file organization system. The target structure was hierarchical and organized by business function:

```
/home/ec2-user/CompanyA/
├── Finance/
│   ├── ProfitAndLossStatements.csv
│   └── Salary.csv
├── HR/
│   ├── Assessments.csv
│   └── TrialPeriod.csv
└── Management/
    ├── Managers.csv
    └── Schedule.csv
```

**[Screenshot: Target Folder Structure Diagram]**
> *Place screenshot or diagram showing the complete folder hierarchy here*

### Step 1: Creating the Top-Level CompanyA Directory

The top-level directory was created using the `mkdir` (make directory) command:

```bash
mkdir CompanyA
```

This command created the root folder for the organizational structure.

**[Screenshot: mkdir CompanyA Command]**
> *Place screenshot of mkdir CompanyA execution here*

### Step 2: Navigating to CompanyA and Creating Subdirectories

Navigation into the newly created CompanyA directory was accomplished:

```bash
cd CompanyA
```

The three primary subdirectories were then created simultaneously:

```bash
mkdir Finance HR Management
```

This command created all three folders in a single operation, demonstrating efficiency in multi-directory creation.

**[Screenshot: cd CompanyA and mkdir Command]**
> *Place screenshot showing navigation and subdirectory creation here*

### Step 3: Verifying Subdirectory Creation

The folder creation was validated using the `ls` command:

```bash
ls
```

The output displayed:
```
Finance  HR  Management
```

This confirmed that all three subdirectories were successfully created in the CompanyA directory.

**[Screenshot: ls Output - Subdirectories Created]**
> *Place screenshot showing the three folders listed here*

### Step 4: Creating Files in the HR Directory

Navigation into the HR directory was performed:

```bash
cd HR
```

Two CSV files were created using the `touch` command:

```bash
touch Assessments.csv TrialPeriod.csv
```

The files were verified to confirm creation:

```bash
ls
```

Output displayed:
```
Assessments.csv  TrialPeriod.csv
```

**[Screenshot: HR Directory Files Created]**
> *Place screenshot showing the two CSV files in HR directory here*

### Step 5: Creating Files in the Finance Directory

Navigation to the Finance directory was accomplished using a relative path:

```bash
cd ../Finance
```

The two financial CSV files were created:

```bash
touch Salary.csv ProfitAndLossStatements.csv
```

Verification confirmed both files were created:

```bash
ls
```

Output displayed:
```
Salary.csv  ProfitAndLossStatements.csv
```

**[Screenshot: Finance Directory Files Created]**
> *Place screenshot showing the two Finance CSV files here*

### Step 6: Creating Files in the Management Directory

Navigation back to the CompanyA directory was performed:

```bash
cd ..
```

The Management directory files were created using a path-relative approach:

```bash
touch Management/Managers.csv Management/Schedule.csv
```

This command created files within the Management subdirectory without requiring navigation into that directory.

Verification was conducted:

```bash
ls Management
```

Output displayed:
```
Managers.csv  Schedule.csv
```

**[Screenshot: Management Directory Files Created]**
> *Place screenshot showing the two Management CSV files here*

### Step 7: Complete Folder Structure Validation

A comprehensive recursive listing was performed to validate the entire folder structure:

```bash
ls -laR
```

This command displayed all directories and files with detailed metadata (permissions, ownership, size, dates) in a recursive manner:

```
.:
total 0
drwxr-xr-x 5 ec2-user root     49 Aug 10 13:36 .
drwx------ 4 ec2-user ec2-user 90 Aug 10 13:25 ..
drwxrwxr-x 2 ec2-user ec2-user 59 Aug 10 13:39 Finance
drwxrwxr-x 2 ec2-user ec2-user 52 Aug 10 13:37 HR
drwxrwxr-x 2 ec2-user ec2-user 46 Aug 10 13:39 Management

./Finance:
total 0
drwxrwxr-x 2 ec2-user ec2-user 59 Aug 10 13:39 .
drwxr-xr-x 5 ec2-user root     49 Aug 10 13:36 ..
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:39 ProfitAndLossStatements.csv
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:39 Salary.csv

./HR:
total 0
drwxrwxr-x 2 ec2-user ec2-user 52 Aug 10 13:37 .
drwxr-xr-x 5 ec2-user root     49 Aug 10 13:36 ..
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:37 Assessments.cvs
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:37 TrialPeriod.csv

./Management:
total 0
drwxrwxr-x 2 ec2-user ec2-user 46 Aug 10 13:39 .
drwxr-xr-x 5 ec2-user root     49 Aug 10 13:36 ..
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:39 Managers.csv
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:39 Schedule.csv
```

**[Screenshot: ls -laR Complete Structure Output]**
> *Place screenshot showing the complete recursive directory listing here*

### Key Concepts Learned in Task 2

- **mkdir:** Creating single or multiple directories simultaneously
- **cd:** Navigating between directories using absolute and relative paths
- **touch:** Creating empty files
- **ls:** Verifying file and directory creation
- **ls -laR:** Comprehensive recursive directory structure validation
- **Relative Paths:** Using `../` to navigate to parent directories and reference files in other directories

---

## Task 3: Reorganizing and Restructuring the File System

### Context and New Requirements

A few weeks after the initial folder structure creation, reorganization requirements were received. The new structure reflected organizational changes where Finance and Management were consolidated under HR management, and a new Employee subfolder was created.

#### New Target Structure:

```
/home/ec2-user/CompanyA/
└── HR/
    ├── Finance/
    │   ├── ProfitAndLossStatements.csv
    │   └── Salary.csv
    ├── Employees/
    │   ├── Assessments.csv
    │   └── TrialPeriod.csv
    └── Management/
        ├── Managers.csv
        └── Schedule.csv
```

**[Screenshot: New Organizational Structure Diagram]**
> *Place screenshot showing the new hierarchy here*

### Step 1: Confirming Current Directory

Verification of the current working directory was performed:

```bash
pwd
```

The output confirmed `/home/ec2-user/CompanyA`, ensuring the correct context for the following operations.

**[Screenshot: pwd - CompanyA Directory Confirmed]**
> *Place screenshot showing pwd output here*

### Step 2: Copying Finance to HR Directory

The Finance folder and its entire contents were copied into the HR directory using the recursive copy command:

```bash
cp -r Finance HR
```

This command:
- Used the `-r` (recursive) flag to copy the directory and all its contents
- Placed the Finance folder inside the HR directory
- Preserved the original Finance folder in CompanyA

Verification of the copy operation was performed:

```bash
ls HR/Finance
```

Output displayed:
```
ProfitAndLossStatements.csv  Salary.csv
```

**[Screenshot: cp -r Command Execution]**
> *Place screenshot showing the recursive copy command here*

**[Screenshot: Verification - Files Copied to HR/Finance]**
> *Place screenshot showing ls HR/Finance output here*

### Step 3: Removing the Original Finance Directory

An attempt to remove the Finance directory using `rmdir` was made:

```bash
rmdir Finance
```

However, the command failed with an error message:

```
rmdir: failed to remove 'Finance/': Directory not empty
```

This error occurred because `rmdir` only works on empty directories. The Finance folder still contained files that needed to be deleted first.

**[Screenshot: rmdir Failure - Directory Not Empty]**
> *Place screenshot showing the rmdir error message here*

### Step 4: Deleting Files from the Finance Directory

The individual files within the Finance directory were deleted:

```bash
rm Finance/ProfitAndLossStatements.csv Finance/Salary.csv
```

The deletion was verified:

```bash
ls Finance
```

The output showed an empty directory (no files listed).

**[Screenshot: rm Command - Files Deleted]**
> *Place screenshot showing the rm command execution here*

**[Screenshot: Finance Directory Now Empty]**
> *Place screenshot showing ls Finance output (empty) here*

### Step 5: Removing the Empty Finance Directory

With the directory now empty, the `rmdir` command successfully removed it:

```bash
rmdir Finance
```

Final verification confirmed the removal:

```bash
ls
```

Output displayed:
```
HR  Management
```

The Finance folder was no longer present in the CompanyA directory.

**[Screenshot: rmdir Success - Finance Directory Removed]**
> *Place screenshot showing successful directory removal here*

### Step 6: Moving the Management Directory into HR

The Management directory was moved into the HR directory using the `mv` (move) command:

```bash
mv Management HR
```

This command:
- Moved the entire Management directory and its contents
- Removed the original Management folder from CompanyA
- Placed it inside the HR directory

Verification was performed:

```bash
ls . HR/Management
```

Output displayed:
```
.:
HR

HR/Management:
Managers.csv  Schedule.csv
```

**[Screenshot: mv Command - Management Moved to HR]**
> *Place screenshot showing the move command execution here*

**[Screenshot: Verification - Management Now Under HR]**
> *Place screenshot showing ls output confirming move here*

### Step 7: Creating Employees Directory and Reorganizing HR Files

Navigation into the HR directory was performed:

```bash
cd HR
```

A new Employees directory was created:

```bash
mkdir Employees
```

The HR-specific CSV files were moved into the Employees directory:

```bash
mv Assessments.csv TrialPeriod.csv Employees
```

This command moved both files from the HR directory into the newly created Employees subdirectory.

**[Screenshot: mkdir Employees]**
> *Place screenshot showing the Employees directory creation here*

### Step 8: Verifying Final Reorganization Structure

The final HR directory structure was verified:

```bash
ls . Employees
```

Output displayed:
```
.:
Employees  Finance  Management

Employees/:
Assessments.csv  TrialPeriod.csv
```

This confirmed the reorganization was successful:
- HR now contained three subdirectories: Employees, Finance, and Management
- Assessments.csv and TrialPeriod.csv were moved into the Employees folder
- Finance and Management directories were properly positioned under HR

**[Screenshot: Final HR Structure Verification]**
> *Place screenshot showing the reorganized structure here*

### Step 9: Complete Reorganized Structure Validation

A recursive listing from the CompanyA directory would have displayed the complete new structure:

```bash
cd ..
ls -laR
```

This would show the entire reorganized hierarchy with all files properly positioned according to the new organizational requirements.

**[Screenshot: Final Complete Structure - ls -laR Output]**
> *Place screenshot showing the complete final structure here*

### Key Concepts Learned in Task 3

- **cp -r:** Copying directories and their contents recursively
- **rmdir:** Removing empty directories
- **rm:** Deleting individual files
- **mv:** Moving directories and files to new locations
- **Error Handling:** Understanding why operations fail and troubleshooting appropriately
- **Organizational Restructuring:** Practical experience with moving and reorganizing file systems
- **Directory Navigation:** Working within nested directory structures

---

## Key Learnings and Best Practices

### File System Organization

The lab demonstrated important principles for organizing file systems:

- **Hierarchical Structure:** Creating logical parent-child directory relationships
- **Semantic Naming:** Using descriptive folder and file names that reflect content (Finance, HR, Management)
- **Scalability:** Designing folder structures that could accommodate future expansion
- **Maintainability:** Organizing data in ways that simplified later reorganization

### Command-Line Efficiency

Several efficiency techniques were demonstrated:

- **Multi-Directory Creation:** Creating multiple folders simultaneously with `mkdir`
- **Relative Paths:** Using `../` to efficiently navigate and reference files
- **Recursive Operations:** Using `-r` flags to operate on entire directory trees
- **Batch File Operations:** Moving multiple files in a single command

### Error Recovery and Troubleshooting

The lab illustrated proper error handling:

- **Understanding Constraints:** Learning why `rmdir` requires empty directories
- **Alternative Solutions:** Using `rm` with appropriate paths when `rmdir` failed
- **Verification at Each Step:** Using `ls` and `pwd` to confirm operations succeeded
- **Methodical Approach:** Addressing errors systematically rather than forcing failed commands

### Permission and Ownership Awareness

File permissions and ownership were observed throughout:

- **Permission Display:** Understanding `-rw-rw-r--` notation in ls output
- **Owner and Group:** Recognizing file ownership structure (ec2-user ownership)
- **Directory Permissions:** Understanding that directories require different permissions than files

---

## Conclusion

The completion of this lab provided comprehensive hands-on experience with Linux file system management. The journey covered the entire lifecycle of file system operations from creation through reorganization, with emphasis on:

1. **Creating folder hierarchies** that reflected business organizational structures
2. **Managing files** through creation, copying, and movement operations
3. **Organizing data** in logical, maintainable ways
4. **Troubleshooting errors** and implementing alternative solutions
5. **Verifying operations** at each step to ensure accuracy

These foundational file system management skills reinforced the Linux knowledge acquired in previous labs and demonstrated the practical application of command-line tools for system administration and data organization tasks.

**Lab Duration:** Approximately 30 minutes  
**Status:** Successfully Completed  
**Key Achievement:** Demonstrated proficiency in creating, manipulating, and reorganizing file systems using Linux command-line tools in an AWS EC2 environment.

---

## Appendix: Essential Linux File System Commands

### Directory Operations
- **`mkdir`** - Create directories
- **`cd`** - Change current directory
- **`pwd`** - Print working directory (current location)
- **`rmdir`** - Remove empty directories

### File Operations
- **`touch`** - Create empty files
- **`rm`** - Remove files
- **`cp -r`** - Copy directories and contents recursively
- **`mv`** - Move or rename files and directories

### Listing and Viewing
- **`ls`** - List directory contents
- **`ls -laR`** - List all files recursively with detailed metadata

### Path Navigation
- **`.`** - Current directory
- **`..`** - Parent directory
- **`/`** - Root directory or path separator
- **`~`** - Home directory

### SSH and Remote Access
- **`ssh -i <keyfile> <user>@<ip>`** - Establish secure shell connection
- **`chmod 400`** - Set read-only permissions for private keys

---

## Appendix: Command Syntax Reference

```bash
# Directory creation - single directory
mkdir DirectoryName

# Directory creation - multiple directories
mkdir Dir1 Dir2 Dir3

# Recursive directory copying
cp -r SourceDirectory DestinationPath

# File creation - single file
touch filename.txt

# File creation - multiple files
touch file1.txt file2.txt file3.txt

# Moving files or directories
mv SourcePath DestinationPath

# Removing files
rm filepath

# Removing empty directories
rmdir directorypath

# Listing directory contents with full details recursively
ls -laR
```

