# Managing Log Files (Linux Fundamentals)

This document described the journey through the "Managing Log Files" lab. The narrative was written in past tense and it documented the steps that had been completed during the lab. It left explicit placeholders for screenshots of the most important aspects so they could be added later in the repository's images folder.

## Summary

I reviewed system and authentication logs on an Amazon Linux EC2 instance. I inspected a provided secure log file under /tmp/log/secure (the lab used a sample file), paged through it with less, and used lastlog to review previous user login times.

## Objectives

The lab objectives were:
- I reviewed the secure log output of the Linux machine.
- I reviewed user last-login information using lastlog.

## Duration

This lab required approximately 5–10 minutes to complete.

## macOS and Linux users — SSH access

These instructions were specifically for macOS/Linux users. If someone was using Windows they were instructed to follow the Windows-specific steps elsewhere.

I connected to the EC2 instance as follows:

1. I opened the Details drop-down in the lab interface, selected Show, and downloaded the PEM key (labsuser.pem).
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
> ![SSH Terminal placeholder](images/managing_logs_ssh.png)
>
> Caption: Insert the SSH terminal screenshot used to connect to the instance.

---

## Task: Review secure log files

I used less to view the sample secure log file and I used lastlog to list the most recent logins for all users.

1. I verified I was in the companyA home folder as instructed:

```bash
pwd
# if needed: cd companyA
```

2. I opened the sample secure log file with less (the lab used /tmp/log/secure instead of /var/log/secure):

```bash
sudo less /tmp/log/secure
```

- I paged through the file with the cursor keys and searched for authentication failures and connection attempts.
- To exit less I pressed `q`.

> Screenshot placeholder: less output for /tmp/log/secure
>
> ![secure log placeholder](images/tmp-log.jpg)
>
> Caption: Insert the screenshot showing the output of `sudo less /tmp/log/secure` (authentication failures, source IPs, ports, etc.).

Note: On most systems the secure log lived at /var/log/secure; the lab provided a sample at /tmp/log/secure for convenience.

3. I listed last login times of all users with lastlog:

```bash
sudo lastlog
```

- The output showed each user and their most recent login date/time (users that had never logged in were marked as "**Never logged in**").

> Screenshot placeholder: lastlog output
>
> ![lastlog placeholder](images/last-log.jpg)
>
> Caption: Insert the screenshot showing `sudo lastlog` output listing users and their most recent login timestamps.

---

## Notes and tips

- Secure logs contained authentication messages, sudo usage, and other security-related events — these were valuable for basic incident investigation and for auditing failed login attempts.
- I used `less` because it was a safe pager for long logs (it did not load the entire file into memory). I used search within less (press `/` then type a pattern like "Failed" or "Failed password") to find relevant entries quickly.
- For ongoing monitoring, I recommended combining log review with tools like journalctl (for systemd-based logs), logrotate (to manage log growth), and centralized logging (CloudWatch Logs, ELK, etc.) for production environments.

## Screenshots and images

I left explicit image placeholders and recommended filenames in the `Labs/Linux Fundamentals/images/` folder so maintainers could add screenshots to render inline:

- images/managing_logs_ssh.png
- images/tmp-log.jpg
- images/last-log.jpg

Place these files in `Labs/Linux Fundamentals/images/` to have them render inline in this document.

---

If you would like, I could also:
- Commit the sample screenshots into Labs/Linux Fundamentals/images/ if you upload them.
- Add a short printable cheatsheet with quick commands for log inspection (less, tail -f, journalctl, lastlog, zgrep).
- Create an example logrotate config snippet for the secure log.
