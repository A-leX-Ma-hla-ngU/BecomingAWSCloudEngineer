# Bash Shell Scripts (Linux Fundamentals)

This document described the journey through the "Bash Shell Scripts" lab. The write-up was written entirely in past tense and it documented the actions that had been completed during the lab. It left explicit placeholders for screenshots highlighting the most important steps so they could be added later in the repository's images folder.

## Summary

I had created a Bash script that automated the creation of a compressed backup archive of the CompanyA folder. The archive filename included a timestamp so multiple backups could be kept without overwriting previous files. I had made the script executable, run it, and verified the resulting archive in a backups directory.

## Objectives

The lab objectives were:
- I had created a bash script that automated the backup of a folder.

## Duration

This lab required approximately 25 minutes to complete.

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
> ![SSH Terminal placeholder](images/bash_scripts_ssh.png)
>
> Caption: Insert the SSH connection screenshot here.

## Task: Write a shell script to automate backups

I created a script named `backup.sh` that produced a timestamped, compressed tarball of the CompanyA directory and saved it under `/home/$USER/backups/`.

1. I verified I was in the home folder:

```bash
pwd
# Expected: /home/ec2-user/
```

> Screenshot placeholder: pwd output
>
> ![pwd placeholder](images/bash_scripts_pwd.png)
>
> Caption: Insert the terminal screenshot confirming the working directory.

2. I created the script file and made it executable:

```bash
touch backup.sh
sudo chmod 755 backup.sh
```

> Screenshot placeholder: touch and chmod
>
> ![touch chmod placeholder](images/backup_touch_chmod.png)
>
> Caption: Insert the terminal screenshot showing backup.sh creation and chmod 755 applied.

3. I opened the script in a text editor (vi was used in the lab instructions) and added the script contents.

- In vi I entered insert mode (i) and added the following content (the shebang, a date variable, backup path, and the tar command):

```bash
#!/bin/bash
DAY="$(date +%Y_%m_%d_%T_%H_%M)"
BACKUP="/home/$USER/backups/$DAY-backup-CompanyA.tar.gz"
tar -csvpzf "$BACKUP" /home/$USER/CompanyA
```

- I saved and exited vi with `Esc` then `:wq`.

> Screenshot placeholder: vi editing backup.sh
>
> ![vi edit placeholder](images/backup_vi_edit.png)
>
> Caption: Insert a screenshot of backup.sh open in vi with the script content visible.

4. I ran the script from the home directory:

```bash
./backup.sh
```

- Expected output: tar printed the files being archived and a message about removing the leading `/` from member names.

> Screenshot placeholder: backup.sh run output
>
> ![backup output placeholder](images/backup_run_output.png)
>
> Caption: Insert the terminal screenshot showing tar verbose output while creating the archive.

Example expected output excerpt:

```
[ec2-user@ ~]$ ./backup.sh
tar: Removing leading `/' from member names
/home/ec2-user/CompanyA/
/home/ec2-user/CompanyA/Management/
/home/ec2-user/CompanyA/Management/Sections.csv
... (other files listed) ...
```

5. I verified the archive was present in the backups directory:

```bash
ls backups/
# Expected: 2022_05_18_05:55:28_05_55-backup-CompanyA.tar.gz (example)
```

> Screenshot placeholder: ls backups
>
> ![ls backups placeholder](images/backups_ls.png)
>
> Caption: Insert the terminal screenshot showing the timestamped archive in backups/.

## Notes and observations

- I had used `-c` to create the archive, `-v` for verbose listing while creating it, `-s` for ? (note: `-s` is not a standard tar option on all implementations — the lab had included `-csvpzf` which I interpreted as `-c -v -s -p -z -f`; to avoid portability issues I recommended using `-cvpzf` or `-czpf` depending on the desired behavior). If consistent behavior was required across systems, I recommended a conservative option set such as `tar -czpf "$BACKUP" /home/$USER/CompanyA` or `tar -cvpzf "$BACKUP" /home/$USER/CompanyA`.

- The timestamp format used in the `DAY` variable ensured unique filenames. I used `date +%Y_%m_%d_%T_%H_%M` in the example; an alternative with fewer symbols would be `date +%Y%m%d_%H%M%S`.

- The script placed the archive under `/home/$USER/backups/`. If the `backups` directory did not already exist, the script would have failed. To make the script more robust I had suggested adding a line before the tar command to create the directory if it did not exist:

```bash
mkdir -p "/home/$USER/backups"
```

- To schedule automated, recurring backups I suggested setting up a cron job (for example `crontab -e` to edit the crontab and adding a daily entry). That was mentioned but left as an exercise beyond the immediate lab.

## Suggested script improvements (optional)

- Check for the existence of the source directory and exit gracefully if it was missing.
- Use `set -euo pipefail` at the top of the script to fail fast on errors.
- Rotate backups or remove archives older than a retention window (e.g., `find /home/$USER/backups -type f -mtime +30 -delete`).
- Copy the archive to remote storage (S3, another host) after creation.

## Screenshots and images

I left explicit image placeholders and recommended filenames in the `Labs/Linux Fundamentals/images/` folder so maintainers could add screenshots to render inline:

- images/bash_scripts_ssh.png
- images/bash_scripts_pwd.png
- images/backup_touch_chmod.png
- images/backup_vi_edit.png
- images/backup_run_output.png
- images/backups_ls.png

Place these files in `Labs/Linux Fundamentals/images/` to have them render inline in this document.

## What I added to the repository

I added this documentation file to the `Labs/Linux Fundamentals` folder. It described the completed steps in past tense, and it included robust guidance and screenshot placeholders so the lab could be validated visually.

---

If you want, I could also:
- Commit this file into the repository now and create the images folder.
- Add the `backup.sh` sample file into the repo (with the robust improvements suggested) so the lab could be run directly from the repository.
- Create a short cheatsheet or a cron example to schedule the script.
