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
> <img width="811" height="264" alt="Screenshot 2026-06-28 at 14 01 47" src="https://github.com/user-attachments/assets/7d29fa32-0596-4f44-9dfe-fb70ddd4a25a" />


## Task: Write a shell script to automate backups

I created a script named `backup.sh` that produced a timestamped, compressed tarball of the CompanyA directory and saved it under `/home/$USER/backups/`.

1. I verified I was in the home folder:

```bash
pwd
# Expected: /home/ec2-user/
```

> <img width="403" height="69" alt="Screenshot 2026-06-28 at 14 02 05" src="https://github.com/user-attachments/assets/8c842f60-352f-4654-bb4d-451652d26071" />

2. I created the script file and made it executable:

```bash
touch backup.sh
sudo chmod 755 backup.sh
```

> Screenshot placeholder: touch and chmod
>
<img width="491" height="27" alt="Screenshot 2026-06-28 at 14 02 21" src="https://github.com/user-attachments/assets/260d46f3-6eff-4920-9da0-0ed1c2d95d47" />

<img width="453" height="73" alt="Screenshot 2026-06-28 at 14 02 44" src="https://github.com/user-attachments/assets/bf2d2765-d9d1-45c1-ab53-b22ec955d135" />

<img width="544" height="56" alt="Screenshot 2026-06-28 at 14 05 41" src="https://github.com/user-attachments/assets/4fb87ee7-4e85-4af7-ae71-71deb523d26c" />

3. I opened the script in a text editor (vi was used in the lab instructions) and added the script contents.

- In vi I entered insert mode (i) and added the following content (the shebang, a date variable, backup path, and the tar command):

```bash
#!/bin/bash
DAY="$(date +%Y_%m_%d_%T_%H_%M)"
BACKUP="/home/$USER/backups/$DAY-backup-CompanyA.tar.gz"
tar -csvpzf "$BACKUP" /home/$USER/CompanyA
```

- I saved and exited vi with `Esc` then `:wq`.

<img width="438" height="32" alt="Screenshot 2026-06-28 at 14 06 09" src="https://github.com/user-attachments/assets/87597918-5b88-497f-99db-1e9d81db4c84" />

<img width="805" height="894" alt="Screenshot 2026-06-28 at 14 06 22" src="https://github.com/user-attachments/assets/999fb710-e308-4a60-af4d-7c26d50a588b" />

<img width="816" height="894" alt="Screenshot 2026-06-28 at 14 06 29" src="https://github.com/user-attachments/assets/80ae041e-85bd-41b1-8c7e-dd636a0d6e4e" />

<img width="809" height="885" alt="Screenshot 2026-06-28 at 14 12 59" src="https://github.com/user-attachments/assets/30a65732-1bd8-4615-a07a-b85bd31522a1" />

4. I ran the script from the home directory:

```bash
./backup.sh
```

- Expected output: tar printed the files being archived and a message about removing the leading `/` from member names.

> Screenshot placeholder: backup.sh run output
<img width="556" height="349" alt="Screenshot 2026-06-28 at 14 14 13" src="https://github.com/user-attachments/assets/dfe02f21-4842-4b96-b3fa-9c45f068883b" />


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
<img width="562" height="64" alt="Screenshot 2026-06-28 at 14 14 34" src="https://github.com/user-attachments/assets/0e443e27-2c02-4b3e-9f05-847a2bbb4d23" />


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
