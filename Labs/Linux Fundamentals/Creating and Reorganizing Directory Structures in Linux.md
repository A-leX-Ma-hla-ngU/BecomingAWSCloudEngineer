# Creating and Reorganizing Directory Structures in Linux - Documentation Journey

## Executive Summary

This documentation captures the journey of completing a comprehensive Linux file system management lab that focused on creating hierarchical folder structures and reorganizing existing directories. Over approximately 45-60 minutes, the lab provided hands-on experience with creating directories, organizing files, and performing complex directory restructuring operations. This lab reinforced foundational Linux concepts while introducing practical file system management skills essential for organizing data and project structures in Linux environments.

---

## Introduction to Directory Structure Management

### Context and Objectives

The lab was structured to develop practical file system organization skills essential for managing data and projects in Linux environments. The primary objectives were to gain proficiency in:

- **Directory Creation:** Creating hierarchical folder structures with mkdir
- **File Creation:** Creating empty files with touch
- **Directory Navigation:** Moving between directories with cd
- **Path Understanding:** Working with absolute and relative paths
- **Directory Copying:** Duplicating folders with cp -r
- **Directory Moving:** Reorganizing folder structures with mv
- **Directory Deletion:** Removing directories with rmdir
- **File Deletion:** Removing files with rm
- **Structure Verification:** Validating organization with ls commands

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

## Task 1: Initial Directory Verification

### Confirming Starting Location

Before beginning the folder structure creation, the current working directory was verified to ensure proper positioning in the file system:

```bash
pwd
```

**Output:**
```
/home/ec2-user
```

This confirmed the user was in the correct home directory from which the CompanyA folder structure would be created.

If not in the home directory, navigation was performed:

```bash
cd /home/ec2-user
```

**[Screenshot: pwd Command - Home Directory Verified]**
> *Place screenshot showing the /home/ec2-user directory confirmation here*

---

## Task 2: Creating a Folder Structure

### Overview of Target Structure

This task involved creating a specific organizational folder structure representing a fictional company with three departments. The target structure was hierarchical and organized by business function.

#### Target Directory Structure:

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

### Step 1: Creating the Top-Level CompanyA Directory

The top-level directory for the company was created:

```bash
mkdir CompanyA
```

This command created a new directory named "CompanyA" in the current location (/home/ec2-user).

**[Screenshot: mkdir CompanyA Command]**
> *Place screenshot showing the top-level directory creation here*

### Step 2: Navigating to CompanyA Directory

Navigation into the newly created CompanyA directory was performed:

```bash
cd CompanyA
```

This command changed the working directory to the newly created CompanyA folder.

**[Screenshot: cd CompanyA Command]**
> *Place screenshot showing navigation into CompanyA here*

### Step 3: Creating Subdirectories

The three primary subdirectories were created in a single command:

```bash
mkdir Finance HR Management
```

This command created all three folders (Finance, HR, and Management) simultaneously within the CompanyA directory.

**[Screenshot: mkdir Finance HR Management Command]**
> *Place screenshot showing subdirectory creation here*

### Step 4: Verifying Subdirectories

The folder creation was validated:

```bash
ls
```

**Output:**
```
Finance  HR  Management
```

All three subdirectories were confirmed to be successfully created.

**[Screenshot: ls Command - Subdirectories Verified]**
> *Place screenshot showing the three folders listed here*

### Step 5: Creating Files in the HR Directory

Navigation into the HR directory was performed:

```bash
cd HR
```

Two CSV files were created using the touch command:

```bash
touch Assessments.csv TrialPeriod.csv
```

Verification of file creation:

```bash
ls
```

**Output:**
```
Assessments.csv  TrialPeriod.csv
```

Both files were confirmed to be successfully created in the HR directory.

**[Screenshot: touch Command - Files Created in HR]**
> *Place screenshot showing the two HR CSV files here*

### Step 6: Creating Files in the Finance Directory

Navigation to the Finance directory was accomplished using a relative path:

```bash
cd ../Finance
```

The `../` notation navigated up one level (to CompanyA) and then into the Finance directory.

Two financial CSV files were created:

```bash
touch Salary.csv ProfitAndLossStatements.csv
```

Verification:

```bash
ls
```

**Output:**
```
Salary.csv  ProfitAndLossStatements.csv
```

Both files were confirmed to be successfully created in the Finance directory.

**[Screenshot: touch Command - Files Created in Finance]**
> *Place screenshot showing the Finance CSV files here*

### Step 7: Creating Files in the Management Directory

Navigation back to the CompanyA directory was performed:

```bash
cd ..
```

This command moved up one level from Finance to CompanyA.

Management folder files were created using a path-relative approach without navigating into the directory:

```bash
touch Management/Managers.csv Management/Schedule.csv
```

This command created files in the Management subdirectory from the parent CompanyA directory.

Verification:

```bash
ls Management
```

**Output:**
```
Managers.csv  Schedule.csv
```

Both files were confirmed to be successfully created in the Management directory.

**[Screenshot: touch Command with Path - Files Created in Management]**
> *Place screenshot showing files created via relative path here*

### Step 8: Understanding Path Methods

Throughout this task, two different approaches to path navigation were demonstrated:

#### Method 1: Direct Working Directory Approach
- Navigate into the target folder: `cd HR`
- Create files in current directory: `touch file.csv`
- List current directory: `ls`

#### Method 2: Relative Path Approach
- Remain in parent directory: Stay in CompanyA
- Create files with path: `touch Management/file.csv`
- List specific directory: `ls Management`

#### Path Navigation Examples:
- `cd ..` - Navigate to parent directory
- `cd ../Finance` - Navigate to parent, then to Finance
- `touch ../Management/file.csv` - Create file in sibling directory

**[Screenshot: Terminal showing both path methods]**
> *Place screenshot demonstrating both direct and relative path usage here*

### Step 9: Complete Structure Validation

A comprehensive recursive listing was performed to validate the entire folder structure:

```bash
ls -laR
```

This command displayed all directories and files with detailed metadata in a recursive manner.

**Output (showing complete structure):**
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
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:37 Assessments.csv
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:37 TrialPeriod.csv

./Management:
total 0
drwxrwxr-x 2 ec2-user ec2-user 46 Aug 10 13:39 .
drwxr-xr-x 5 ec2-user root     49 Aug 10 13:36 ..
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:39 Managers.csv
-rw-rw-r-- 1 ec2-user ec2-user  0 Aug 10 13:39 Schedule.csv
```

The complete organizational structure was verified with all directories and files properly created.

**[Screenshot: ls -laR Complete Structure Output]**
> *Place screenshot showing the complete recursive directory listing here*

### Key Concepts Learned in Task 2

- **mkdir:** Creating single or multiple directories simultaneously
- **cd:** Navigating between directories with absolute and relative paths
- **touch:** Creating empty files
- **ls:** Verifying file and directory creation
- **ls -laR:** Comprehensive recursive directory structure validation
- **Relative Paths:** Using `../` to navigate to parent directories
- **Path Shortcuts:** Using relative paths to create files without changing directories
- **File Organization:** Creating logical hierarchical structures

---

## Task 3: Reorganizing Folder Structures

### Overview of Reorganization

After several weeks, organizational changes required restructuring the directory layout. Finance and Management departments were consolidated under HR management, and a new Employee subfolder was created within HR to organize employee-related files.

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

**[Screenshot: Organizational Restructuring Diagram]**
> *Place screenshot showing before and after structure comparison here*

### Step 1: Verifying Current Directory

Directory verification was performed before beginning reorganization:

```bash
pwd
```

**Output:**
```
/home/ec2-user/CompanyA
```

This confirmed the correct location for performing directory operations.

**[Screenshot: pwd - CompanyA Directory Confirmed]**
> *Place screenshot showing directory confirmation here*

### Step 2: Copying Finance to HR Directory

The Finance folder and its entire contents were copied into the HR directory:

```bash
cp -r Finance HR
```

This command used the `-r` (recursive) flag to copy the directory and all its contents. The Finance folder was duplicated inside HR while keeping the original Finance folder intact temporarily.

**[Screenshot: cp -r Finance HR Command]**
> *Place screenshot showing the copy command execution here*

### Step 3: Verifying Finance Copy

The copy operation was verified by checking if Finance folder existed within HR:

```bash
ls HR/Finance
```

**Output:**
```
ProfitAndLossStatements.csv  Salary.csv
```

The Finance folder and its files were successfully copied to the HR directory.

**[Screenshot: Verification - Finance Copied to HR]**
> *Place screenshot showing the copied files in HR/Finance here*

### Step 4: Attempting Directory Removal - Initial rmdir

An attempt was made to remove the original Finance directory:

```bash
rmdir Finance
```

**Output (error):**
```
rmdir: failed to remove 'Finance/': Directory not empty
```

This error occurred because `rmdir` only works on empty directories. The Finance folder still contained files that needed to be deleted first.

**[Screenshot: rmdir Error - Directory Not Empty]**
> *Place screenshot showing the rmdir error message here*

### Step 5: Removing Files from Finance Directory

The individual files within the Finance directory were deleted:

```bash
rm Finance/ProfitAndLossStatements.csv Finance/Salary.csv
```

This command removed both CSV files from the Finance directory, preparing it for directory removal.

Verification that the directory was now empty:

```bash
ls Finance
```

**Output:**
```
(empty - no output)
```

The Finance folder was confirmed to be empty.

**[Screenshot: rm Command - Files Deleted from Finance]**
> *Place screenshot showing the file removal and empty directory here*

### Step 6: Removing the Empty Finance Directory

With the directory now empty, the `rmdir` command successfully removed it:

```bash
rmdir Finance
```

Final verification:

```bash
ls
```

**Output:**
```
HR  Management
```

The Finance folder was no longer present in the CompanyA directory.

**[Screenshot: rmdir Success - Finance Directory Removed]**
> *Place screenshot showing successful directory removal here*

### Step 7: Moving Management Directory to HR

The Management directory was moved into the HR directory:

```bash
mv Management HR
```

This command moved the entire Management directory and its contents into HR, removing it from the CompanyA level.

Verification of the move operation:

```bash
ls . HR/Management
```

**Output:**
```
.:
HR

HR/Management:
Managers.csv  Schedule.csv
```

The Management folder was confirmed to be moved into HR with its files intact.

**[Screenshot: mv Command - Management Moved to HR]**
> *Place screenshot showing the move command and verification here*

### Step 8: Creating and Organizing the Employees Folder

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

**[Screenshot: mkdir Employees and mv Commands]**
> *Place screenshot showing Employees folder creation and file movement here*

### Step 9: Verifying Final Reorganization Structure

The final HR directory structure was verified:

```bash
ls . Employees
```

**Output:**
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

### Key Concepts Learned in Task 3

- **cp -r:** Copying directories and their contents recursively
- **rmdir:** Removing empty directories only
- **rm:** Deleting individual files
- **mv:** Moving directories and files to new locations
- **Error Handling:** Understanding why operations fail and troubleshooting
- **File and Folder Dependencies:** Understanding when files must be removed before directories
- **Organizational Restructuring:** Practical experience with complex directory reorganization
- **Verification at Each Step:** Confirming operations succeeded before proceeding

---

## Key Learnings and Best Practices

### Directory Organization Principles

The lab demonstrated important principles for organizing file systems:

- **Hierarchical Structure:** Creating logical parent-child directory relationships
- **Semantic Naming:** Using descriptive folder and file names reflecting content
- **Scalability:** Designing structures that accommodate future expansion
- **Maintainability:** Organizing data for easy later reorganization
- **Department Consolidation:** Logically grouping related departments

### Command Usage and Efficiency

Several important command techniques were demonstrated:

- **Single-Command Directory Creation:** Creating multiple folders simultaneously
- **Recursive Operations:** Using `-r` flags to operate on entire directory trees
- **Relative Paths:** Using `../` to navigate efficiently
- **Batch Operations:** Moving multiple files in a single command
- **Verification Steps:** Using `ls` and `pwd` to confirm operations

### Error Recovery and Troubleshooting

The lab illustrated proper error handling:

- **Understanding Constraints:** Learning why `rmdir` requires empty directories
- **Alternative Solutions:** Using `rm` when `rmdir` failed
- **Sequential Operations:** Removing files before directories
- **Verification:** Confirming each operation before proceeding to the next

### Directory Operation Workflow

A logical workflow was demonstrated:

1. **Plan** - Understanding the desired end structure
2. **Create** - Building directories and files
3. **Verify** - Checking results at each step
4. **Modify** - Copying and moving as needed
5. **Clean Up** - Removing unnecessary old structures
6. **Final Verify** - Confirming complete reorganization

---

## Conclusion

The completion of this lab provided comprehensive hands-on experience with Linux file system management and directory organization. The journey covered:

1. **Directory creation** using mkdir for hierarchical folder structures
2. **File creation** with touch to populate directories
3. **Navigation** through absolute and relative paths
4. **Directory copying** with cp -r for duplication
5. **Directory moving** with mv for reorganization
6. **Directory deletion** with rmdir for cleanup
7. **File deletion** with rm for preparation
8. **Structure verification** with ls and ls -laR for validation
9. **Error handling** and recovery techniques
10. **Complex reorganization** involving multiple operations

These skills are foundational for Linux file system management, enabling proper organization of projects, data, and system administration tasks in multi-user Linux environments.

**Lab Duration:** Approximately 45-60 minutes  
**Status:** Successfully Completed  
**Key Achievement:** Demonstrated proficiency in creating hierarchical directory structures and executing complex reorganization operations using Linux command-line tools.

---

## Appendix: Directory Management Commands Reference

### Directory Creation

```bash
# Create single directory
mkdir directoryname

# Create multiple directories
mkdir dir1 dir2 dir3

# Create nested directories (if parent doesn't exist)
mkdir -p path/to/nested/directory
```

### Directory Navigation

```bash
# Move to directory (absolute path)
cd /path/to/directory

# Move to directory (relative path)
cd directoryname

# Move to parent directory
cd ..

# Move to grandparent directory
cd ../..

# Move to sibling directory
cd ../siblingdir

# Move to home directory
cd ~
# or
cd

# Print current directory
pwd
```

### Directory Listing and Verification

```bash
# List contents of current directory
ls

# List contents with details
ls -l

# List all files including hidden
ls -a

# List all with details and hidden files
ls -la

# Recursively list all contents
ls -R

# Recursively list all with details
ls -laR

# List specific directory contents
ls directoryname

# List specific directory recursively
ls -R directoryname
```

### File and Directory Operations

```bash
# Create empty file
touch filename

# Create multiple files
touch file1 file2 file3

# Create file in subdirectory
touch directoryname/filename

# Remove file
rm filename

# Remove multiple files
rm file1 file2 file3

# Remove files in subdirectory
rm directoryname/file1 directoryname/file2

# Copy file
cp sourcefile destinationfile

# Copy directory recursively
cp -r sourcedirectory destinationdirectory

# Move or rename file/directory
mv source destination

# Move multiple files
mv file1 file2 file3 destinationdirectory
```

### Directory Removal

```bash
# Remove empty directory
rmdir directoryname

# Remove empty nested directories
rmdir path/to/directory

# Recursively remove directory and contents
rm -r directoryname

# Force remove directory without prompting
rm -rf directoryname
```

---

## Appendix: Path Navigation Guide

### Understanding Paths

#### Absolute Paths
- Start with `/` (root directory)
- Example: `/home/ec2-user/CompanyA/Finance`
- Used when you need to reference from any location

#### Relative Paths
- Don't start with `/`
- Relative to current working directory
- Examples:
  - `Finance` - subdirectory in current location
  - `../Finance` - sibling directory
  - `../../file.txt` - file in parent's parent
  - `./Finance/file.csv` - file in subdirectory (explicit current)

### Path Shortcuts

```bash
# Current directory
.

# Parent directory
..

# Home directory
~

# User's home directory
~username
```

### Examples of Path Usage

```bash
# Navigate with absolute path
cd /home/ec2-user/CompanyA

# Navigate with relative path
cd Finance

# Navigate to parent
cd ..

# Navigate to sibling from child
cd ../Management

# Create file with path
touch Management/Managers.csv

# List with path
ls HR/Finance

# Copy with paths
cp -r HR/Finance HR/FinanceBackup
```

---

## Appendix: Directory Structure Comparison

### Initial Structure (Created in Task 2)

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

**Characteristics:**
- Finance at root level of CompanyA
- HR at root level of CompanyA
- Management at root level of CompanyA
- Three separate departments at same hierarchy level
- Total of 6 files across 3 directories

### Reorganized Structure (After Task 3)

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

**Characteristics:**
- Finance moved under HR
- Employees folder created (new)
- Management moved under HR
- Employee files grouped in Employees folder
- HR acts as parent organization
- Same 6 files reorganized into new structure

### Changes Made

| Change | Command | Purpose |
|--------|---------|---------|
| Copy Finance to HR | `cp -r Finance HR` | Duplicate before moving |
| Delete Finance files | `rm Finance/*.csv` | Prepare for directory removal |
| Remove Finance | `rmdir Finance` | Clean up old structure |
| Move Management | `mv Management HR` | Consolidate under HR |
| Create Employees | `mkdir Employees` | New employee folder |
| Move employee files | `mv Assessments.csv TrialPeriod.csv Employees` | Organize by type |

### Directory Count Summary

| Metric | Initial | Final | Change |
|--------|---------|-------|--------|
| Total Directories | 4 | 5 | +1 (Employees) |
| Files | 6 | 6 | Same |
| Root-level folders | 3 | 1 | -2 (consolidated) |
| HR subfolders | 0 | 3 | +3 |
| Hierarchy levels | 2 | 3 | +1 |

