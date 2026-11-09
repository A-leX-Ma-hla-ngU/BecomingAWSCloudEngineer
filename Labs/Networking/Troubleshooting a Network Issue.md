# Troubleshooting a Network Issue

## Lab overview

In this lab, I investigated a customer's report that an Apache web server could not be reached by ping or loaded in a browser. I connected to the EC2 instance, checked and started the Apache service, inspected the VPC network path and security controls, corrected the security group rules, and verified access to the web server.

**Approximate duration:** 1 hour

## Objectives completed

- I analyzed the customer scenario.
- I troubleshot the network and web server issue.
- I verified the Apache server after correcting the configuration.

## Customer scenario

Ana, a contractor, reported that she had created an Apache server from the command line but could not reach it with ping or load its IP address in a browser. The lab environment replicated the customer's VPC and resources so that I could investigate the issue.

> **Screenshot placeholder — Customer architecture:** Add the lab diagram showing the VPC, internet gateway, public subnet, and EC2 instance.

## Task 1: Connected to the EC2 instance

I downloaded the lab-provided PEM key and noted the instance's public IPv4 address. On macOS or Linux, I changed to the directory containing the key and made it read-only:

```bash
cd ~/Downloads
chmod 400 labsuser.pem
```

I connected to the instance over SSH using its public IPv4 address:

```bash
ssh -i labsuser.pem ec2-user@<public-ip>
```

I confirmed the first connection when prompted. I used the lab-provided key for authentication and kept the private key secure.

> **Screenshot placeholder — SSH connection:** Add a screenshot showing the connected terminal. Do not include the private key or credentials.

## Task 2: Checked and started Apache

I checked the Apache HTTP Server (`httpd`) service status:

```bash
sudo systemctl status httpd.service
```

The service was installed but inactive. I started it and checked its status again:

```bash
sudo systemctl start httpd.service
sudo systemctl status httpd.service
```

The service then showed an active status. I opened the instance's public IPv4 address in a browser:

```text
http://<public-ip>
```

The Apache test page still did not load at this stage, which indicated that starting the service alone had not resolved the network access problem.

> **Screenshot placeholder — Inactive Apache service:** Add a screenshot showing the initial `httpd` status.
>
> **Screenshot placeholder — Active Apache service:** Add a screenshot showing `httpd` in the active state.
>
> **Screenshot placeholder — Initial browser test:** Add a screenshot of the browser error before the network rule was corrected.

## Task 3: Investigated the VPC configuration

I opened the VPC console and reviewed the network path and controls associated with the instance. I checked:

- **Subnet association:** I verified that the subnet used the expected route table.
- **Route table:** I checked for the local route and the default route to the internet gateway (`0.0.0.0/0`).
- **Internet gateway:** I confirmed that an internet gateway was attached to the VPC.
- **Network ACL:** I reviewed the subnet-level inbound and outbound rules.
- **Security group:** I reviewed the instance-level inbound and outbound rules.

I also used internet reachability as a diagnostic clue. A successful ping to a public destination could suggest that an outbound route worked, but it would not prove that inbound HTTP access to Apache was permitted. ICMP and HTTP used different protocols and could be filtered by different rules.

The Apache server used HTTP on TCP port 80. The issue was caused by the instance security group's missing or incorrect HTTP inbound rule. I corrected the security group to allow HTTP traffic on TCP port 80 from the lab's intended client source, then saved the rule. I avoided opening administrative access more broadly than required.

| Access purpose | Protocol and port | Source used |
| --- | --- | --- |
| Apache web access | TCP 80 (HTTP) | The lab-required client source |
| SSH administration | TCP 22 (SSH) | Restricted to the lab user's trusted IP where applicable |

> **Screenshot placeholder — VPC route table and internet gateway:** Add a screenshot showing the subnet route and attached gateway.
>
> **Screenshot placeholder — Security group before correction:** Add a screenshot showing the missing or incorrect HTTP inbound rule.
>
> **Screenshot placeholder — Corrected security group:** Add a screenshot showing the HTTP rule on TCP port 80 and its intended source. Redact personal IP addresses.
>
> **Screenshot placeholder — Network ACL rules:** Add a screenshot showing the relevant inbound and outbound rules, if reviewed.

## Task 4: Verified the solution

After correcting the security group rule, I opened the instance's public IPv4 address again:

```text
http://<public-ip>
```

The Apache test page loaded successfully. This confirmed that the Apache service was active and that the VPC route and security controls allowed the required HTTP traffic.

> **Screenshot placeholder — Apache page after correction:** Add a screenshot showing the Apache test page loaded in the browser.

## Findings and lab completion

I found that Apache had been installed but was initially inactive. After starting the service, the web page still could not be reached because the security group did not allow the required HTTP traffic. I corrected the security group rule for TCP port 80 and verified that the Apache test page loaded.

I noted that ping and browser tests checked different kinds of traffic: ping used ICMP, while the web page used HTTP over TCP port 80. A failure in one test did not necessarily mean that the other protocol was blocked for the same reason.

> **Cleanup reminder:** After completing the activity, I disconnected from the instance and ended the lab as instructed. I kept SSH access restricted and avoided leaving unnecessary inbound rules enabled.

## Additional resource

- [What is Amazon VPC?](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
