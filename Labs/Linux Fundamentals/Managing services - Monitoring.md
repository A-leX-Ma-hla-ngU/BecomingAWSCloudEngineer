# Managing services - Monitoring (Linux Fundamentals)

This document described the journey through the "Managing services - Monitoring" lab. The content was written in past tense and it documented the steps that had been completed during the lab. The file left clear placeholders for screenshots of the most important aspects of the lab so they could be added later in the repository's images folder.

## Summary

I checked the status of the Apache HTTP service (httpd) on an Amazon Linux 2 EC2 instance, started and stopped the service, verified the web server response in a browser, and monitored instance resource usage using local Linux tools (top) and AWS CloudWatch.

## Objectives

The lab objectives were:
- I had checked the status of the httpd service to confirm it was running and that an HTTP connection to the instance's public IP address worked.
- I monitored the Amazon Linux 2 EC2 instance using the Linux top command.
- I inspected EC2 metrics using AWS CloudWatch.

## Duration

The lab had a target duration of about 30 minutes.

## Notes on AWS service restrictions

The lab environment had restricted access to only the AWS services and actions needed to complete the lab instructions. Attempts to access other services or actions had produced errors.

## Prerequisites

- Access to the lab credentials (PEM key) and the instance Public IP.
- A macOS or Linux workstation for SSH instructions below. (Windows users were instructed to follow Windows-specific steps elsewhere.)

## SSH access (macOS / Linux)

I followed these steps to connect to the instance:

1. I opened the Details drop-down in the lab interface, selected Show and downloaded the PEM key (labsuser.pem).
2. I noted the instance Public IP from the lab details.
3. In a terminal I changed to the directory where labsuser.pem had been saved, for example:

```bash
cd ~/Downloads
```

4. I protected the key by changing its permissions:

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
> ![SSH Terminal placeholder](images/ssh_connection.png)
>
> Caption: Insert the SSH connection screenshot here.

## Task: Check the status of the httpd service

I inspected and controlled the Apache httpd service using systemd (systemctl). A note: if I was not root I used sudo for the commands.

1. I checked the status of the httpd service:

```bash
sudo systemctl status httpd.service
```

- Expected outcome: the service might have been loaded but inactive (dead) if it had not been started yet.

> Screenshot placeholder: httpd inactive
>
> ![Httpd Service Inactive placeholder](images/Httpd_Service_Inactive.png)
>
> Caption: Insert the output showing httpd in inactive (dead) state.

2. I started the httpd service:

```bash
sudo systemctl start httpd.service
```

3. I re-checked the status to confirm it was running:

```bash
sudo systemctl status httpd.service
```

- Expected outcome: the service was shown as active (running).

> Screenshot placeholder: httpd active
>
> ![Httpd Service Active placeholder](images/Httpd_Service_Active.png)
>
> Caption: Insert the output showing httpd in active (running) state.

4. I verified the web server response by opening a browser and navigating to the instance public IP:

- URL used: http://<publicip>

- Expected outcome: the Apache HTTP Server Test page was displayed.

> Screenshot placeholder: Apache test page
>
> ![Apache Test Page placeholder](images/http_test_page.png)
>
> Caption: Insert the browser screenshot that showed the Apache Test page.

5. I stopped the httpd service when I finished:

```bash
sudo systemctl stop httpd.service
```

## Task: Monitoring the Linux EC2 instance locally (top) and with AWS CloudWatch

I used top locally to view process and resource usage, and I used AWS CloudWatch dashboards to inspect instance metrics.

1. I ran top to display running processes and resource usage:

```bash
top
```

- I examined CPU and memory usage and then pressed Q to exit top.

> Screenshot placeholder: top normal usage
>
> ![top normal usage placeholder](images/top_1.png)
>
> Caption: Insert the top output screenshot showing normal CPU usage.

2. I simulated CPU load by running the provided stress script in background and restarted top to observe the change:

```bash
./stress.sh &
# then in the same terminal
top
```

- Expected outcome: top showed a process with high CPU usage while the script ran (the script was designed to run for about 6 minutes).

> Screenshot placeholder: top high CPU usage
>
> ![top high CPU usage placeholder](images/top_high_cpu.png)
>
> Caption: Insert the top output screenshot showing the stress process and high CPU usage.

3. I opened the AWS Management Console, searched for CloudWatch, and navigated to Dashboards -> Automatic dashboards -> EC2.

- I observed default EC2 metrics such as CPUUtilization, DiskReadBytes, DiskReadOps, DiskWriteBytes, DiskWriteOps, and NetworkIn.
- I compared the timestamped CPU utilization graph with the time I had started the stress script and I saw a corresponding spike.

> Screenshot placeholder: CloudWatch EC2 dashboard
>
> ![CloudWatch EC2 dashboard placeholder](images/cloudwatch_ec2_dashboard.png)
>
> Caption: Insert the CloudWatch EC2 dashboard screenshot showing CPU spike.

Notes and observations

- I had noticed that CloudWatch aggregated metrics at 5-minute intervals by default. For faster visibility into short spikes I changed the period/aggregation where permitted.
- The CloudWatch dashboards were customizable; I had considered adding alarms and additional widgets as next steps.

## Where to place screenshots

I had left clear image placeholders inside this markdown. The repository path I used for those references was `Labs/Linux Fundamentals/images/` and the recommended filenames were:

- images/ssh_connection.png
- images/Httpd_Service_Inactive.png
- images/Httpd_Service_Active.png
- images/http_test_page.png
- images/top_1.png
- images/top_high_cpu.png
- images/cloudwatch_ec2_dashboard.png

You could add these image files to the same folder in the repository so the markdown showed actual screenshots.

## What I added to the repo

I added this documentation file to the `Labs/Linux Fundamentals` folder. It described the steps that had been completed, and it included placeholders for the most important screenshots so the lab documentation could be visually verified later.

---

If you want, I could also:
- Add an images subfolder and upload any screenshots you provide.
- Split the content into a lab README and a short quick-reference cheatsheet.
- Convert this into an HTML lab guide or PDF for distribution.
