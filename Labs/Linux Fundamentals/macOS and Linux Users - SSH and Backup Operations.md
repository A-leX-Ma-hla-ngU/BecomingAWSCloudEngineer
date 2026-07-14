# macOS and Linux Users: File Backup and Archival - Documentation Journey

## Executive Summary

This documentation captures the comprehensive journey of completing a Linux file backup and archival lab designed specifically for macOS and Linux users. Over approximately 60-75 minutes, the lab provided essential hands-on experience with SSH connectivity, file archival using tar compression, backup logging, and file transfer operations. The experience reinforced foundational Linux command-line skills while introducing critical backup and disaster recovery procedures essential for system administration and data protection in professional environments.

---

## Introduction: Backup and Archival Operations

### Context and Objectives

This lab was structured to develop practical backup and archival skills essential for protecting data and maintaining system resilience. The primary learning objectives were to gain proficiency in:

- **SSH Connectivity:** Establishing secure remote connections to EC2 instances
- **Terminal Navigation:** Working efficiently in command-line environments
- **File Permissions:** Understanding and modifying access controls with chmod
- **Archival Operations:** Creating compressed tar archives
- **Data Backup:** Protecting entire directory structures
- **Backup Documentation:** Logging backup operations for auditing
- **File Transfer:** Moving files between directories for organizational purposes
- **Directory Validation:** Verifying backup integrity and completeness

**[Screenshot: Terminal Application - Ready for SSH Connection]**
> *Place screenshot of terminal window open and ready here*

### Lab Environment and Prerequisites

The lab environment was accessed through an Amazon EC2 instance running Amazon Linux, providing a t3.micro instance with compute resources. The lab was specifically designed for macOS and Linux users who had direct terminal access to their systems. Windows users were directed to alternative instructions.

**Key Environment Details:**
- Instance Type: t3.micro
- Operating System: Amazon Linux
- Access Method: SSH with public key authentication
- User Account: ec2-user
- Home Directory: /home/ec2-user

---

## Part 1: SSH Connection Setup for macOS and Linux Users

### Overview of Credentials Retrieval

Before establishing the SSH connection, the necessary credentials and authentication materials were obtained through the lab console.

**[Screenshot: Lab Instructions Panel]**
> *Place screenshot showing the lab instructions interface here*

### Step 1: Accessing Lab Credentials

The lab credentials were retrieved through the following process:

1. Located the "Details" drop-down menu positioned above the lab instructions
2. Selected the "Show" option to reveal the Credentials window
3. The Credentials window was presented, containing essential connection information

**[Screenshot: Details Drop-down Menu]**
> *Place screenshot showing the Details menu before selecting Show here*

**[Screenshot: Credentials Window Display]**
> *Place screenshot showing the Credentials window with PEM download and PublicIP here*

### Step 2: Obtaining the PEM File

The PEM (Privacy Enhanced Mail) file, which contained the private key for authentication, was downloaded:

1. Selected the "Download PEM" button in the Credentials window
2. The labsuser.pem file was saved to the local system
3. Made a note of the file location (typically Downloads directory)
4. Recorded the PublicIP address displayed in the credentials panel
5. Exited the Details panel by selecting the X button

**[Screenshot: Credentials Window - Download PEM Button]**
> *Place screenshot highlighting the Download PEM button here*

### Step 3: Terminal Setup and Navigation

The terminal application was opened on the macOS or Linux system:

```bash
cd ~/Downloads
```

This command changed the working directory to the Downloads folder where the labsuser.pem file was typically saved. The `~` symbol represented the user's home directory, and `Downloads` was the standard downloads location.

**[Screenshot: Terminal - Directory Navigation]**
> *Place screenshot showing the cd ~/Downloads command execution here*

**Alternative Directory Examples:**

If the PEM file was saved to a different location, the cd command would be adjusted accordingly:

```bash
# If saved to Documents
cd ~/Documents

# If saved to Desktop
cd ~/Desktop

# If saved to custom location
cd /path/to/directory
```

### Step 4: Securing the PEM File Permissions

The permissions on the PEM file were modified to restrict access, which was a security requirement for SSH key authentication:

```bash
chmod 400 labsuser.pem
```

**Understanding the chmod Command:**

- `chmod` - Change mode (file permissions)
- `400` - Permission code meaning:
  - `4` (Owner): Read-only access
  - `0` (Group): No access
  - `0` (Others): No access

This restrictive permission setting was mandatory for SSH key authentication to function properly. SSH would refuse to use a key file with overly permissive permissions for security reasons.

**[Screenshot: chmod 400 Command Execution]**
> *Place screenshot showing the chmod command and successful execution here*

### Step 5: Establishing SSH Connection

The SSH connection to the EC2 instance was initiated:

```bash
ssh -i labsuser.pem ec2-user@<public-ip>
```

**Command Breakdown:**

- `ssh` - Secure Shell protocol for remote connection
- `-i labsuser.pem` - Identity file flag specifying the private key file
- `ec2-user` - Username for authentication on the remote system
- `<public-ip>` - Public IP address of the EC2 instance (e.g., 54.123.45.67)

**Example with actual IP:**

```bash
ssh -i labsuser.pem ec2-user@54.123.45.67
```

**[Screenshot: SSH Connection Command - Before Execution]**
> *Place screenshot showing the ssh command typed in terminal here*

### Step 6: Accepting the Remote Host

When connecting to a remote SSH server for the first time, a host verification prompt was presented:

**Prompt Message:**
```
The authenticity of host '<public-ip> (<public-ip>)' can't be established.
ECDSA key fingerprint is SHA256:...
Are you sure you want to continue connecting (yes/no)?
```

The response "yes" was typed to confirm the connection and add the host to the known hosts file:

```
yes
```

**[Screenshot: SSH Host Verification Prompt]**
> *Place screenshot showing the "Are you sure you want to continue connecting" prompt here*

### Step 7: Successful Connection Confirmation

Upon successful authentication, the connection was established and the remote terminal prompt was displayed:

```
[ec2-user@ip-10-0-10-244 ~]$
```

This prompt indicated successful SSH connection to the EC2 instance:
- `ec2-user` - The connected user account
- `ip-10-0-10-244` - The hostname of the EC2 instance (private IP formatted)
- `~` - Current directory (home directory)
- `$` - Standard user prompt (not root)

**Key Observation:** No password was required because authentication was accomplished using the PEM private key file. This key-based authentication was more secure than password authentication.

**[Screenshot: Successful SSH Connection - Terminal Prompt]**
> *Place screenshot showing the successful connection prompt here*

### Important Security Notes

Throughout this SSH connection process, several important security principles were demonstrated:

1. **Key-Based Authentication** - More secure than password-based authentication
2. **Restrictive File Permissions** - The chmod 400 command ensured only the owner could read the key
3. **Host Verification** - Accepting the host fingerprint prevented man-in-the-middle attacks
4. **Secure Remote Access** - SSH encrypted all communication between the client and server

---

## Task 2: Creating a Comprehensive File Structure Backup

### Overview of the Work Environment

Before creating the backup, the existing folder structure was examined and documented. This structure represented a realistic company file organization with multiple departments and shared resources.

**[Screenshot: Company Folder Structure Diagram]**
> *Place screenshot showing the hierarchical structure visualization here*

### Understanding the Existing File Structure

The work environment contained the following folder and file organization:

```
/home/ec2-user/CompanyA/
├── Employees/
│   └── Schedules.csv
├── Finance/
│   └── Salary.csv
├── HR/
│   ├── Assessments.csv
│   └── Managers.csv
├── IA/
│   (empty directory)
├── Management/
│   ├── Promotions.csv
│   └── Sections.csv
└── SharedFolders.csv
```

**Structure Characteristics:**
- **Root Directory:** /home/ec2-user/CompanyA
- **Total Subdirectories:** 5 (Employees, Finance, HR, IA, Management)
- **Total Files:** 7 (various CSV files across departments)
- **IA Folder:** Empty directory for future use
- **SharedFolders.csv:** File at root level for shared documentation

This structure represented a realistic departmental organization with separate folders for different business functions.

### Step 1: Verifying Current Working Directory

Before performing backup operations, confirmation of the current working directory was essential:

```bash
pwd
```

**Expected Output:**
```
/home/ec2-user
```

**[Screenshot: pwd Command - Verifying Location]**
> *Place screenshot showing the pwd command and /home/ec2-user output here*

The pwd (print working directory) command confirmed that operations were being performed from the home directory, which was the parent directory of CompanyA.

### Step 2: Validating the CompanyA Folder Structure

The complete folder structure was validated using a recursive listing command:

```bash
ls -R CompanyA
```

**Command Explanation:**
- `ls` - List command to display directory contents
- `-R` - Recursive flag to show all subdirectories and their contents

**Expected Output:**
```
CompanyA/:
Employees  Finance  HR  IA  Management  SharedFolders

CompanyA/Employees:
Schedules.csv

CompanyA/Finance:
Salary.csv

CompanyA/HR:
Assessments.csv  Managers.csv

CompanyA/IA:

CompanyA/Management:
Promotions.csv  Sections.csv
```

**Output Analysis:**
- CompanyA root directory listed with 5 subdirectories
- Each subdirectory displayed with its contents
- IA folder showed as empty
- All expected CSV files were present and accounted for
- SharedFolders (shown as file, not folder in this output)

**[Screenshot: ls -R Output - Complete Folder Validation]**
> *Place screenshot showing the recursive directory listing here*

### Step 3: Creating the Backup Archive

The tar command was used to create a compressed backup of the entire CompanyA folder structure:

```bash
tar -csvpzf backup.CompanyA.tar.gz CompanyA
```

**Detailed Command Analysis:**

| Flag | Meaning | Purpose |
|------|---------|---------|
| `c` | Create | Create a new tar archive |
| `s` | Sparse | Handle sparse files efficiently |
| `v` | Verbose | Display files being processed |
| `p` | Preserve | Maintain file permissions and ownership |
| `z` | Gzip | Compress archive using gzip algorithm |
| `f` | File | Specify output filename |
| `backup.CompanyA.tar.gz` | Filename | Archive name with .tar.gz extension |
| `CompanyA` | Source | Directory to be archived |

**Understanding the Backup Process:**

1. **Archive Creation:** The tar command packaged all files and directories
2. **Recursive Processing:** All subdirectories and nested files were included
3. **Compression:** Gzip compression reduced the archive size significantly
4. **File Tracking:** Verbose output showed each file being processed
5. **Metadata Preservation:** Permissions and ownership were maintained

**Expected Output:**
```
CompanyA/
CompanyA/Management/
CompanyA/Management/Sections.csv
CompanyA/Management/Promotions.csv
CompanyA/Employees/
CompanyA/Employees/Schedules.csv
CompanyA/Finance/
CompanyA/Finance/Salary.csv
CompanyA/HR/
CompanyA/HR/Managers.csv
CompanyA/HR/Assessments.csv
CompanyA/IA/
CompanyA/SharedFolders/

[ec2-user@ip-10-0-10-244 ~]$ 
```

**[Screenshot: tar Command - Archive Creation in Progress]**
> *Place screenshot showing the tar command output with verbose file listing here*

### Step 4: Verifying Archive Creation

After the tar command completed, the archive file was verified to ensure successful creation:

```bash
ls
```

**Expected Output:**
```
backup.CompanyA.tar.gz  CompanyA
```

**Verification Details:**
- The backup.CompanyA.tar.gz archive file was present in the /home/ec2-user directory
- The original CompanyA folder remained intact (tar creates a copy within the archive)
- File size of the archive could be viewed with ls -lh for human-readable format

**[Screenshot: ls Command - Archive File Verified]**
> *Place screenshot showing both the backup archive and original CompanyA folder here*

### Understanding the Archive Format

The backup.CompanyA.tar.gz file combined two technologies:

1. **TAR (Tape Archive):**
   - Packages multiple files and directories into a single file
   - Preserves file permissions, ownership, and directory structure
   - Does not compress by default

2. **GZIP Compression:**
   - Compresses the tar archive to reduce storage size
   - Commonly reduces size by 80-90% depending on file content
   - .tar.gz extension indicates both tar and gzip were used

**Backup Advantages:**
- **Complete Structure Preservation:** All files, folders, and permissions backed up
- **Single File Transfer:** Entire backup can be transferred as one file
- **Compression:** Reduced storage and bandwidth requirements
- **Portability:** Archive can be restored on any Unix-like system

**[Screenshot: Backup Archive Statistics]**
> *Place screenshot showing file size comparison between original and backup here*

---

## Task 3: Logging the Backup Operation

### Importance of Backup Documentation

Maintaining a log of backup operations provided crucial information for backup management:

- **Historical Record:** When backups were created and what was backed up
- **Audit Trail:** Verification of backup completion for compliance
- **Duplicate Prevention:** Avoiding unnecessary backup operations
- **Recovery Planning:** Reference when restoration is needed

### Step 1: Navigating to the CompanyA Directory

Navigation to the CompanyA folder was performed to create the backup log:

```bash
cd /home/ec2-user/CompanyA
```

**Terminal Response:**
```
[ec2-user@ip-10-0-10-244 CompanyA]$
```

The changed prompt indicated successful navigation to the CompanyA directory. The hostname displayed as the instance ID, and the directory name "CompanyA" was shown at the prompt.

**[Screenshot: cd Command - Navigation to CompanyA]**
> *Place screenshot showing directory navigation here*

### Step 2: Creating the Backup Log File

An empty CSV (Comma-Separated Values) file was created to store backup logs:

```bash
touch SharedFolders/backups.csv
```

**Command Explanation:**
- `touch` - Creates an empty file or updates timestamp if file exists
- `SharedFolders/backups.csv` - Path specifying the file location within SharedFolders directory

**File Creation Details:**
- File created as: backups.csv
- Location: SharedFolders subdirectory
- Format: CSV for structured backup logging
- Initial state: Empty file ready for data entry

**[Screenshot: touch Command - Creating Backup Log File]**
> *Place screenshot showing the file creation command here*

### Step 3: Adding Backup Metadata to the Log

The date, time, and backup filename were added to the backups.csv file:

```bash
echo "25 Aug 25 2021, 16:59, backup.CompanyA.tar.gz" | sudo tee SharedFolders/backups.csv
```

**Complex Command Breakdown:**

| Component | Function | Purpose |
|-----------|----------|---------|
| `echo` | Print command | Output text to terminal |
| `"25 Aug 25 2021, 16:59..."` | String content | Backup metadata to record |
| `\|` | Pipe operator | Redirect output to next command |
| `sudo` | Superuser | Elevate privileges for file writing |
| `tee` | T-pipe command | Write to both terminal and file |
| `SharedFolders/backups.csv` | Target file | Where log entry is written |

**Understanding the Pipe and Tee:**

1. **Pipe Operator (\|):**
   - Redirects the standard output (stdout) of the first command
   - Passes output as input to the second command
   - Allows command chaining for complex operations

2. **Tee Command:**
   - Reads input from pipe
   - Writes content to specified file
   - Also outputs to terminal (standard output)
   - "T" shape represents the split: input splits to file and terminal

**[Screenshot: echo and tee Command - Adding Log Entry]**
> *Place screenshot showing the echo and tee command with output here*

**Expected Output:**
```
25 Aug 25 2021, 16:59, backup.CompanyA.tar.gz
[ec2-user@ip-10-0-10-244 CompanyA]$
```

The output appeared on the terminal, and the same content was written to the backups.csv file.

### Step 4: Verifying the Backup Log Entry

The contents of the backup log file were displayed to verify successful entry creation:

```bash
cat SharedFolders/backups.csv
```

**Command Explanation:**
- `cat` - Concatenate command to display file contents
- `SharedFolders/backups.csv` - File path to display

**Expected Output:**
```
25 Aug 25 2021, 16:59, backup.CompanyA.tar.gz
```

This output confirmed that the backup metadata was successfully written to the log file.

**[Screenshot: cat Command - Backup Log Verification]**
> *Place screenshot showing the cat command output here*

### Understanding Backup Logging Best Practices

The backup logging demonstrated important practices for data management:

1. **Structured Format:**
   - CSV format allows easy parsing and analysis
   - Consistent formatting enables automated processing
   - Standard fields: Date, Time, Filename

2. **Centralized Location:**
   - Log stored in shared folder accessible to team
   - Centralizes all backup information
   - Facilitates team communication about backups

3. **Expandable Structure:**
   - CSV format allows adding new fields (e.g., Size, Status)
   - Can grow to include multiple backup entries
   - Scales for large backup operations

4. **Audit Trail:**
   - Timestamp provides when backup was created
   - Filename allows locating specific backup
   - Historical record for compliance and recovery

---

## Task 4: Moving the Backup File

### Business Context for File Movement

In a real-world scenario, after creating a backup, the file would often be transferred to a separate location or team. This task demonstrated transferring the backup to the Information Architecture (IA) team for further processing or storage.

### Step 1: Confirming Current Location

Before moving the backup file, the current working directory was verified:

```bash
pwd
```

**Expected Output:**
```
/home/ec2-user/CompanyA
```

**[Screenshot: pwd Command - Confirming CompanyA Location]**
> *Place screenshot showing the directory confirmation here*

### Step 2: Moving the Backup File to IA Folder

The backup file was transferred from the parent directory to the IA folder:

```bash
mv ../backup.CompanyA.tar.gz IA/
```

**Command Analysis:**

| Component | Meaning | Explanation |
|-----------|---------|-------------|
| `mv` | Move command | Relocates file to new location |
| `../backup.CompanyA.tar.gz` | Source path | Backup file in parent directory (/home/ec2-user) |
| `../` | Parent reference | Navigates one level up (to /home/ec2-user) |
| `IA/` | Destination | IA folder path within CompanyA |

**Why This Path Structure:**

- Current location: /home/ec2-user/CompanyA
- Backup location: /home/ec2-user/backup.CompanyA.tar.gz
- Destination: /home/ec2-user/CompanyA/IA/
- Therefore: `../` goes to /home/ec2-user, then specify backup filename

**Alternative Commands:**

The same operation could be performed using absolute paths:

```bash
mv /home/ec2-user/backup.CompanyA.tar.gz /home/ec2-user/CompanyA/IA/
```

Or using full relative paths:

```bash
mv ~/backup.CompanyA.tar.gz IA/
```

**[Screenshot: mv Command - Moving Backup File]**
> *Place screenshot showing the move command execution here*

### Step 3: Verifying File Transfer

The file transfer was verified by listing both the current directory and the IA folder:

```bash
ls . IA
```

**Command Explanation:**
- `ls` - List command
- `.` - List contents of current directory (CompanyA)
- `IA` - List contents of IA subdirectory
- Multiple arguments to ls show contents of multiple locations

**Expected Output:**
```
.:
Employees  Finance  HR  IA  Management  SharedFolders

IA:
backup.CompanyA.tar.gz
```

**Output Analysis:**

- **Current Directory (.):** Listed all folders and files in CompanyA
- **IA Folder:** Now contained the backup.CompanyA.tar.gz file
- **Confirmation:** backup.CompanyA.tar.gz no longer at parent directory level
- **Success:** File successfully moved, not copied (original no longer exists at source)

**[Screenshot: ls Command - Verification of File Transfer]**
> *Place screenshot showing the ls output with backup in IA folder here*

### Understanding the mv Command

The move command had different behaviors depending on the destination:

1. **Moving to Existing Directory:**
   - File placed inside the directory
   - Filename remains the same
   - Original location no longer contains file

2. **Moving with Rename:**
   - If destination includes filename, file is renamed
   - Example: `mv file.txt newname.txt`

3. **Difference from Copy:**
   - `cp` creates copy at destination, original remains
   - `mv` relocates file, original is removed
   - `mv` is more efficient for reorganization

### Real-World Application

This file transfer demonstrated practical scenarios:

**In a Real Workplace:**
- Backup created by system administrator
- Moved to team folder for distributed access
- IA team can access backup without administrator involvement
- Demonstrates file sharing and responsibility delegation
- Backup isolated in team folder for security and organization

---

## Lab Completion and Cleanup

### Final Summary of Operations

The lab demonstrated the following critical skills in sequence:

1. **SSH Connection:** Secure remote access to EC2 instances
2. **File System Navigation:** Working with absolute and relative paths
3. **Backup Creation:** Using tar to create compressed archives
4. **Data Logging:** Recording operational metadata
5. **File Management:** Moving files for organizational purposes

**[Screenshot: Final Terminal State - All Tasks Complete]**
> *Place screenshot showing the terminal after completing all tasks here*

### Ending the Lab Session

Upon completion of all tasks, the lab session was properly terminated:

1. Selected the "End Lab" button located at the top of the lab instructions page
2. Selected "Yes" to confirm ending the lab session
3. A confirmation panel displayed: "DELETE has been initiated... You may close this message box now."
4. Selected the X button in the top right corner of the confirmation panel to close it

**[Screenshot: End Lab Button Location]**
> *Place screenshot showing the End Lab button before selection here*

**[Screenshot: End Lab Confirmation Dialog]**
> *Place screenshot showing the DELETE confirmation message here*

### Lab Outcomes

Upon successful completion of the lab, the following objectives were achieved:

✅ **SSH Connectivity:** Established secure remote connection to EC2 instance
✅ **File Structure Understanding:** Validated complex folder organization
✅ **Data Backup:** Created compressed tar archive of entire directory structure
✅ **Backup Logging:** Documented backup operation with timestamp and filename
✅ **File Transfer:** Successfully moved backup to designated team folder
✅ **Verification Skills:** Confirmed all operations with appropriate listing commands

---

## Key Learnings and Best Practices

### SSH and Remote Access Principles

The SSH connection process demonstrated important security practices:

- **Public Key Cryptography:** Using PEM files for authentication
- **File Permissions:** Setting restrictive permissions on private keys
- **Host Verification:** Confirming host identity on first connection
- **No Password Required:** Key-based authentication more secure than passwords

### Backup and Archive Operations

The tar backup process illustrated critical data protection concepts:

- **Recursive Archival:** Capturing entire directory structures
- **Compression:** Reducing backup size with gzip
- **Metadata Preservation:** Maintaining permissions and ownership
- **Single File Format:** Portable backup format for easy transfer

### File System Management

File operations demonstrated practical Linux administration:

- **Path Navigation:** Using absolute and relative paths effectively
- **Verbose Output:** Understanding what commands are doing (ls -R, tar -v)
- **File Verification:** Confirming operations with listing commands
- **Directory Organization:** Moving files for team accessibility

### Operational Documentation

Backup logging represented critical business practices:

- **Audit Trails:** Creating historical records of operations
- **Structured Data:** Using CSV format for organized logging
- **Accessibility:** Storing logs in shared locations
- **Compliance:** Maintaining records for verification and recovery

### Command Piping and Redirection

The echo and tee commands demonstrated advanced terminal operations:

- **Pipe Operator:** Chaining commands together
- **Output Redirection:** Directing output to multiple destinations
- **Dual Output:** Using tee for both terminal and file output
- **Command Composition:** Creating complex operations from simple commands

---

## Appendix A: Essential SSH and Backup Commands Reference

### SSH Connection and Setup Commands

```bash
# Change to downloads directory
cd ~/Downloads

# Set secure permissions on PEM file (read-only for owner)
chmod 400 labsuser.pem

# Establish SSH connection with key authentication
ssh -i labsuser.pem ec2-user@<public-ip>

# Alternative: SSH with verbose output for troubleshooting
ssh -v -i labsuser.pem ec2-user@<public-ip>
```

### Directory Navigation and Verification

```bash
# Print current working directory
pwd

# List directory contents recursively
ls -R CompanyA

# List with detailed information and hidden files
ls -la

# List multiple locations at once
ls . IA

# Change to home directory
cd /home/ec2-user
```

### Backup and Archival Commands

```bash
# Create tar archive with gzip compression (verbose)
tar -csvpzf backup.CompanyA.tar.gz CompanyA

# Extract tar archive
tar -xzvf backup.CompanyA.tar.gz

# List contents of tar archive without extracting
tar -tzvf backup.CompanyA.tar.gz

# Create tar archive without compression
tar -cvf backup.CompanyA.tar CompanyA
```

### File and Directory Operations

```bash
# Create empty file
touch SharedFolders/backups.csv

# Display file contents
cat SharedFolders/backups.csv

# Move file to new location
mv ../backup.CompanyA.tar.gz IA/

# Copy file to new location
cp ../backup.CompanyA.tar.gz IA/

# Remove file
rm filename

# List files with human-readable sizes
ls -lh
```

### Logging and Output Commands

```bash
# Echo text to terminal and file using pipe and tee
echo "25 Aug 25 2021, 16:59, backup.CompanyA.tar.gz" | sudo tee SharedFolders/backups.csv

# Append to file instead of overwriting
echo "New entry" | sudo tee -a SharedFolders/backups.csv

# Redirect output to file (overwrites)
echo "Content" > filename

# Redirect output to file (appends)
echo "Content" >> filename
```

---

## Appendix B: Understanding tar Command Flags

### tar Syntax: tar [options] [archive-file] [files or directories]

| Flag | Long Form | Purpose | Example |
|------|-----------|---------|---------|
| `-c` | `--create` | Create new archive | tar -c |
| `-x` | `--extract` | Extract archive | tar -x |
| `-t` | `--list` | List archive contents | tar -t |
| `-f` | `--file` | Specify archive filename | tar -f archive.tar |
| `-v` | `--verbose` | Show file-by-file progress | tar -v |
| `-z` | `--gzip` | Compress with gzip | tar -z |
| `-j` | `--bzip2` | Compress with bzip2 | tar -j |
| `-p` | `--preserve-permissions` | Keep file permissions | tar -p |
| `-s` | `--sparse` | Handle sparse files | tar -s |

### Common tar Command Combinations

```bash
# Create compressed archive
tar -cvzf archive.tar.gz directory/

# Extract compressed archive
tar -xvzf archive.tar.gz

# List archive contents
tar -tzvf archive.tar.gz

# Create archive without compression (faster)
tar -cvf archive.tar directory/

# Extract without decompressing first
tar -xzvf archive.tar.gz
```

---

## Appendix C: File Paths and Navigation Reference

### Path Types

#### Absolute Paths
- Start with `/` (root directory)
- Full path from system root
- Work from any location
- Example: `/home/ec2-user/CompanyA/Finance/Salary.csv`

#### Relative Paths
- Don't start with `/`
- Relative to current working directory
- Must be adjusted based on location
- Example: `Finance/Salary.csv` (when in CompanyA)

### Path Shortcuts

| Shortcut | Meaning | Example |
|----------|---------|---------|
| `~` | User's home directory | `~/CompanyA` = `/home/ec2-user/CompanyA` |
| `.` | Current directory | `./Finance` = `Finance` |
| `..` | Parent directory | `../backup.tar.gz` = move up one level |
| `/` | Root directory | `/home/ec2-user` |
| `-` | Previous directory | `cd -` returns to previous location |

### Navigation Examples

```bash
# Using absolute path from any location
cd /home/ec2-user/CompanyA

# Using relative path from home directory
cd CompanyA

# Using parent reference
cd ../OtherFolder

# Using home shortcut
cd ~/Downloads

# Referencing file in parent directory
cat ../backup.CompanyA.tar.gz

# Creating file in subdirectory from parent
touch CompanyA/Finance/Salary.csv
```

---

## Appendix D: File Transfer and Backup Scenarios

### Scenario 1: Backup Creation and Transfer

**Workflow:**
1. Connect via SSH: `ssh -i key.pem user@host`
2. Create backup: `tar -czf backup.tar.gz folder/`
3. Move to team location: `mv backup.tar.gz /shared/backups/`
4. Log operation: `echo "date, time, filename" >> backup_log.csv`

### Scenario 2: Distributed Backup Access

**Workflow:**
1. Administrator creates backup
2. Moves backup to team folder
3. Team members can access and restore
4. Centralized log tracks all backups
5. Prevents duplicate backup creation

### Scenario 3: Disaster Recovery

**Workflow:**
1. Access backup from secure location
2. Extract archive: `tar -xzf backup.tar.gz`
3. Verify contents: `ls -R restored_folder/`
4. Restore to correct location
5. Confirm file integrity

### Scenario 4: Backup Rotation and Cleanup

**Workflow:**
1. Create dated backup: `tar -czf backup_2021-08-25.tar.gz folder/`
2. Log with timestamp
3. Move older backups to archive
4. Remove backups older than retention period
5. Maintain backup_log.csv with all history

---

## Appendix E: Troubleshooting Common Issues

### SSH Connection Problems

**Issue: "Permission denied (publickey)"**
- **Cause:** PEM file permissions not restrictive enough
- **Solution:** `chmod 400 labsuser.pem`

**Issue: "Connection refused"**
- **Cause:** Wrong IP address or instance not running
- **Solution:** Verify IP address from AWS console, check instance status

**Issue: "ssh: command not found"**
- **Cause:** SSH client not installed
- **Solution:** macOS users install Command Line Tools; Linux users install openssh-client

### tar Command Problems

**Issue: "tar: directory does not exist"**
- **Cause:** Source directory path incorrect
- **Solution:** Verify directory exists: `ls -R CompanyA`

**Issue: "Permission denied" when creating archive**
- **Cause:** Insufficient write permissions
- **Solution:** Run with sudo or check directory permissions

**Issue: "Cannot open archive"**
- **Cause:** Incorrect flags or corrupted file
- **Solution:** List archive contents first: `tar -tzvf backup.tar.gz`

### File Movement Problems

**Issue: "No such file or directory"**
- **Cause:** Wrong path to source or destination
- **Solution:** Verify paths exist: `pwd` and `ls destination/`

**Issue: "Permission denied"**
- **Cause:** Insufficient permissions for file or directory
- **Solution:** Check permissions: `ls -l`, modify if needed: `chmod`

---

## Appendix F: Security Best Practices

### PEM File Security

- **Always:** Store PEM files securely with 400 permissions
- **Never:** Share PEM files with others
- **Never:** Commit PEM files to version control
- **Always:** Use unique PEM files for different systems
- **Regularly:** Rotate PEM files periodically

### SSH Security

- **Use:** Key-based authentication instead of passwords
- **Never:** Disable host key verification
- **Consider:** Using SSH config files for frequently used connections
- **Monitor:** SSH access logs for suspicious activity
- **Use:** SSH keys with passphrases for additional security

### Backup Security

- **Encrypt:** Use encryption for sensitive backups
- **Distribute:** Store backups in multiple secure locations
- **Test:** Regularly test backup restoration procedures
- **Document:** Maintain detailed backup logs
- **Verify:** Periodically verify backup integrity

---

## Conclusion

The completion of this lab provided comprehensive hands-on experience with critical Linux administration and data management skills essential for professional system administration and data protection. The journey covered:

1. **Secure Remote Access:** SSH connectivity and key-based authentication
2. **File System Operations:** Directory navigation and file management
3. **Data Archival:** Creating compressed backups of complex structures
4. **Operational Logging:** Recording and tracking backup operations
5. **File Transfer:** Moving files for team accessibility
6. **Verification Procedures:** Confirming all operations succeeded

These foundational skills are essential for:
- **System Administrators:** Managing servers and backups
- **DevOps Engineers:** Automating backup and deployment processes
- **Security Professionals:** Protecting data and managing access
- **Linux Users:** Daily command-line proficiency

The skills learned in this lab form the foundation for more advanced Linux administration, configuration management, and infrastructure automation.

**Lab Duration:** Approximately 60-75 minutes  
**Platform:** Amazon EC2 Instance (t3.micro)  
**Access Method:** SSH with Public Key Authentication  
**Status:** Successfully Completed  
**Key Achievement:** Demonstrated proficiency in backup creation, logging, and file transfer operations using Linux command-line tools.

