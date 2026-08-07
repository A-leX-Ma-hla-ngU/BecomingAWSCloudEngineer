# Managing Processes - Documentation Journey

Note
All labs relied on previous courseware and lab information.

Duration
This lab required approximately 45 minutes to complete.

Objectives
In this lab, you would:
- Create a new log file for process listings
- Use the `top` command to observe system activity
- Establish a repetitive task that ran previous auditing commands once a day (cron)

AWS service restrictions
In the lab environment, access to AWS services and service actions might have been restricted to the ones that were needed to complete the lab instructions. You might have encountered errors if you attempted to access other services or perform actions beyond those described in this lab.

macOS and Linux users
These instructions were specifically for macOS/Linux users. Windows users were instructed to skip to the next task.

Pre-Lab: SSH Connection Establishment

Before starting the exercises, the lab credentials were retrieved and SSH connectivity to the EC2 instance was established.

Steps performed:
1. I opened the Details drop-down above the lab instructions and selected Show to present the Credentials window.
2. I selected Download PEM and saved the `labsuser.pem` file.
3. I made a note of the instance PublicIP.
4. I exited the Details panel.
5. I opened a terminal and changed directory to where the PEM file was saved, for example:

```bash
cd ~/Downloads
```

6. I restricted the PEM file permissions for secure key-based authentication:

```bash
chmod 400 labsuser.pem
```

7. I connected to the EC2 instance with:

```bash
ssh -i labsuser.pem ec2-user@<public-ip>
```

When prompted the first time to allow the remote host key, I typed `yes`. Because a key pair was used for authentication, I was not prompted for a password.

[Screenshot: Terminal - SSH Connection Prompt]
> *Place screenshot of the SSH host verification prompt here*

[Screenshot: Successful SSH Connection]
> *Place screenshot showing the successful SSH connection and the `ec2-user` prompt here*


Task 1: Exercise - Create List of Processes

Overview
I created a CSV-formatted log file of the non-root processes running on the instance and saved it to the SharedFolders directory for later inspection.

Steps performed:
1. I validated that I was in the expected working directory and moved into the `companyA` folder if needed:

```bash
pwd
# If not in /home/ec2-user/companyA
cd companyA
```

2. I listed all processes with `ps -aux`, excluded any lines containing the word `root`, and wrote the remaining output to `SharedFolders/processes.csv` using `tee` so the command's output could be reviewed immediately:

```bash
sudo ps -aux | grep -v root | sudo tee SharedFolders/processes.csv
```

Notes and filtering
- The pipeline excluded any process lines that contained `root` in the USER column.
- Processes whose COMMAND column contained `[` or `]` were left out by the `grep -v root` step in this lab; depending on the shell and the ps output, additional filtering with `grep -v "\[" | grep -v "\]"` could have been added to remove kernel worker or thread entries that used brackets.

3. I validated the created file by displaying its contents:

```bash
cat SharedFolders/processes.csv
```

[Screenshot: Terminal - ps and processes.csv output]
> *Place screenshot showing the command and resulting `SharedFolders/processes.csv` content here*

Figure: The command `sudo ps -aux | grep -v root | sudo tee SharedFolders/processes.csv` produced a snapshot of the current processes (excluding root-owned processes) and saved them to the SharedFolders location.


Task 2: Exercise - List the processes using the top command

Overview
I observed system performance and the live process list using the `top` command.

Steps performed:
1. I launched `top` in the terminal:

```bash
top
```

2. I observed the real-time output, which displayed system metrics and a live list of processes including CPU and memory usage. I examined the header lines that reported totals for tasks and their states (running, sleeping, stopped, zombie), along with CPU%, KiB memory, and KiB swap usage.

[Screenshot: Terminal - top command full view]
> *Place screenshot of the `top` command main output here*

3. I inspected the Tasks line (second line under the summary) to determine how many total tasks there were and how many were running vs sleeping. Example output that I observed included values similar to:

```
Tasks: 93 total, 1 running, 48 sleeping, 0 stopped, 0 zombie
```

[Screenshot: top Tasks line highlighted]
> *Place screenshot showing the Tasks summary line from `top` here*

4. To exit `top`, I pressed `q`.

5. For usage and version help, I ran:

```bash
top -hv
```


Task 3: Exercise - Create a Cron Job to Audit CSV Files

Overview
I created a cron job in the root crontab that produced an audit file which replaced `.csv` suffixes with `#####.csv` for all CSV files found in the working tree; this was intended to demonstrate scheduled auditing and to create a repeatable, automated output.

Note: The tasks below used `sudo` since the lab user might not have owned the root crontab.

Steps performed:
1. I validated I was in the `/home/ec2-user/companyA` folder:

```bash
pwd
# If not in /home/ec2-user/companyA
cd companyA
```

2. I opened the root crontab editor:

```bash
sudo crontab -e
```

3. In the editor I entered insert mode and added the following lines at the top of the file:

```
SHELL=/bin/bash
PATH=/usr/bin:/bin:/usr/local/bin
MAILTO=root
```

4. On the final line I added the cron schedule and the command to create the filtered audit file once every hour at minute 0 (the lab instructed `0 * * * *` for hourly runs; change the schedule as needed):

```
0 * * * * ls -la $(find .) | sed -e 's/..csv/#####.csv/g' > /home/ec2-user/companyA/SharedFolders/filteredAudit.csv
```

Notes on the cron entry:
- The `SHELL` and `PATH` entries ensured the script used bash and could find standard binaries.
- `MAILTO=root` directed any cron output mail to root (this was the lab default).
- The `find`/`ls`/`sed` pipeline mirrored the lab example; in production, a more robust script would be recommended.

5. I saved and exited the editor (for `vi`/`vim`: `ESC :wq`), then verified the installed crontab:

```bash
sudo crontab -l
```

[Screenshot: Terminal - crontab editor showing SHELL/PATH/MAILTO and cron line]
> *Place screenshot showing the crontab `-e` contents here*

[Screenshot: Terminal - sudo crontab -l output]
> *Place screenshot showing the output of `sudo crontab -l` verifying the cron job here*

Figure: The terminal displayed the installed cron job; it created a repeating audit file at `/home/ec2-user/companyA/SharedFolders/filteredAudit.csv`.


Validation and Troubleshooting Tips
- If the cron job did not run as expected, I checked `/var/log/cron` and `/var/log/messages` (or systemd journal) for cron daemon logs, and ensured the PATH and SHELL values were correct within the crontab.
- If file permissions prevented writing to SharedFolders, I validated directory ownership and permissions with `ls -la SharedFolders` and adjusted with `chown`/`chmod` as necessary.
- If `ps` output included unexpected bracketed commands or kernel threads, I used additional grep filters to exclude `\[` and `\]` from the output.


Key Learnings and Best Practices
- I learned how to capture process snapshots non-interactively and store them for review.
- `top` provided a quick, live view of CPU, memory, and task state that was useful for troubleshooting spikes and long-running processes.
- Cron allowed me to schedule automated audits; ensuring the crontab environment (SHELL, PATH) was correct prevented common runtime issues.
- When capturing process lists for auditing, it was important to consider which system-owned processes to exclude to avoid noise in the logs.


Appendix: Useful Commands Used in This Lab

```bash
# Confirm current folder
pwd

# Move into companyA (if needed)
cd companyA

# Create the processes CSV by excluding root-owned processes
sudo ps -aux | grep -v root | sudo tee SharedFolders/processes.csv

# View the saved processes file
cat SharedFolders/processes.csv

# Launch top
top

# Exit top
q

# Cron editing & listing
sudo crontab -e
sudo crontab -l
```


Appendix: Screenshot Placeholders
- SSH connection prompt and successful login
- `ps` command execution and `SharedFolders/processes.csv` contents
- `top` main output and Tasks line highlighted
- `crontab -e` editor contents showing SHELL, PATH, MAILTO, and cron line
- `sudo crontab -l` output verifying the installed job


File: Labs/Linux Fundamentals/Managing Processes.md
