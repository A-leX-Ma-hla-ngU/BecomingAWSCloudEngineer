# The Bash shell (Linux Fundamentals)

This document described the journey through "The Bash shell" lab. The content was written in past tense and it documented the steps that had been completed during the lab. The file left clear placeholders for screenshots of the most important aspects of the lab so they could be added later in the repository's images folder.

## Summary

I created and used an alias to back up a folder with tar. I also inspected and modified the PATH environment variable so that a script in a user bin directory could be executed by name from anywhere.

## Objectives

The lab objectives were:
- I created and worked with an alias to back up a complete folder.
- I inspected and updated the PATH variable and added a new folder to it.

## Duration

The lab required approximately 30 minutes to complete.

## macOS and Linux users — SSH access

These instructions were specifically for macOS/Linux users. If someone was using Windows they were instructed to follow the Windows-specific steps elsewhere.

I connected to the EC2 instance as follows:

1. I opened the Details drop-down in the lab interface, selected Show and downloaded the PEM key (labsuser.pem).
2. I noted the instance Public IP from the lab details.
3. In a terminal I changed to the directory where labsuser.pem had been saved, for example:

```bash
cd ~/Downloads
```

4. I restricted the key permissions:

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
> ![SSH Terminal placeholder](images/bash_ssh.png)
>
> Caption: Insert the SSH connection screenshot here.

## Task: Create an alias for a backup operation

I created an alias named `backup` that used tar to archive and compress a provided path into a specified file name. I used sudo where necessary.

1. I verified I was in the home folder:

```bash
pwd
# Expected: /home/ec2-user/
```

> Screenshot placeholder: pwd output
>
> ![pwd placeholder](images/pwd_output.png)
>
> Caption: Insert the terminal output showing the working directory.

2. I created the alias called `backup`.

Note: The alias needed to accept two arguments: the first was the destination archive (for example `backup_companyA.tar.gz`) and the second was the path to back up. Because aliases do not accept positional parameters directly, I used a short shell function defined as an alias-style command in the interactive shell. For the lab I created an alias that invoked `tar -cvzf` with the provided parameters, for example:

```bash
alias backup='f(){ tar -cvzf "$1" "$2"; }; f'
```

3. I used the alias to back up the CompanyA folder:

```bash
backup backup_companyA.tar.gz CompanyA
```

- Expected outcome: tar printed the list of files being archived.

> Screenshot placeholder: alias run / tar output
>
> ![Backup result placeholder](images/alias_run.png)
>
> Caption: Insert the terminal screenshot showing tar verbose output for CompanyA.

Example of the expected terminal output:

```
[ec2-user@ ~]$ backup backup_companyA.tar.gz CompanyA
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
CompanyA/bin/hello.sh
```

4. I confirmed that the archive had been created by listing files in the home directory:

```bash
ls
# Expected to see: backup_companyA.tar.gz  CompanyA
```

> Screenshot placeholder: ls output with archive
>
> ![ls backup placeholder](images/ls_backup.png)
>
> Caption: Insert the output showing backup_companyA.tar.gz in the directory.

## Task: Explore and update the PATH environment variable

I explored three ways of running a simple script and then updated PATH so that the script could be invoked by name without specifying a path.

1. I navigated to the bin folder inside CompanyA:

```bash
cd /home/ec2-user/CompanyA/bin
```

2. I ran the hello.sh script from within the bin directory:

```bash
./hello.sh
# Expected output: hello ec2-user
```

> Screenshot placeholder: hello.sh run from bin
>
> ![hello run from bin placeholder](images/hello_run1.png)
>
> Caption: Insert the terminal screenshot of hello.sh output when run with ./hello.sh inside bin.

3. I moved back to the parent directory and ran the script by relative path:

```bash
cd ..
./bin/hello.sh
# Expected output: hello ec2-user
```

> Screenshot placeholder: hello.sh run via ./bin/hello.sh
>
> ![hello run relative placeholder](images/hello_run2.png)
>
> Caption: Insert the terminal screenshot of hello.sh output when run with ./bin/hello.sh from parent folder.

4. I attempted to run the script by name only, which failed because the script's directory was not on PATH:

```bash
hello.sh
# Expected: bash: hello.sh: command not found
```

> Screenshot placeholder: hello.sh command not found
>
> ![hello not found placeholder](images/hello_not_found.png)
>
> Caption: Insert the terminal screenshot showing the command not found error.

5. I displayed the current PATH value:

```bash
echo $PATH
# Example expected output:
# /usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin
```

> Screenshot placeholder: echo PATH
>
> ![echo path placeholder](images/echo_path.png)
>
> Caption: Insert the PATH environment variable screenshot.

6. I updated PATH to include the CompanyA/bin directory so the script could be executed by name from anywhere in the shell session:

```bash
PATH=$PATH:/home/ec2-user/CompanyA/bin
```

> Screenshot placeholder: PATH updated
>
> ![path updated placeholder](images/path_updated.png)
>
> Caption: Insert the output showing that PATH was updated.

7. I ran `hello.sh` again and it executed successfully by name:

```bash
hello.sh
# Expected output: hello ec2-user
```

> Screenshot placeholder: hello.sh run after PATH update
>
> ![hello run after path placeholder](images/hello_run_after_path.png)
>
> Caption: Insert the terminal screenshot showing hello.sh executed by name after PATH update.

Notes and tips

- The PATH change above affected only the current shell session. To persist the change across logins, I would add the PATH assignment to `~/.bashrc` or `~/.bash_profile`.

- For a more robust backup command that accepted arbitrary numbers of files and directories, I would have implemented a shell function (in `~/.bashrc`) rather than a simple alias, for example:

```bash
backup() { tar -cvzf "$1" "${@:2}"; }
```

This allowed multiple source arguments after the destination filename.

## Screenshots and images

I left explicit image placeholders and recommended filenames in the `Labs/Linux Fundamentals/images/` folder:

- images/bash_ssh.png
- images/pwd_output.png
- images/alias_run.png
- images/ls_backup.png
- images/hello_run1.png
- images/hello_run2.png
- images/hello_not_found.png
- images/echo_path.png
- images/path_updated.png
- images/hello_run_after_path.png

Place these files in `Labs/Linux Fundamentals/images/` to have them render inline in this document.

## What I did in the repository

I added this documentation file to the `Labs/Linux Fundamentals` folder. It described the steps that had been completed, it used past tense throughout, and it included placeholders for the most important screenshots so others could verify and reproduce the lab visually.

---

If you wanted, I could also:
- Upload screenshots into Labs/Linux Fundamentals/images/ if you provide them.
- Persist the PATH change to `~/.bashrc` in the instructions and show how to source it.
- Add a small sample `stress.sh` or `hello.sh` to the repository for the lab to reference.
