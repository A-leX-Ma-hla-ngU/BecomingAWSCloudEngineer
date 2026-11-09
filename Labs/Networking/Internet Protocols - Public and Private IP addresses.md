# Internet Protocols - Public and Private IP addresses

## Lab overview

In this lab, I investigated a customer’s EC2 connectivity issue and compared public and private IPv4 addresses. I reviewed the customer scenario, tested access to two instances, considered the risks of using public address space for a VPC, and summarized my findings for the customer.

**Approximate duration:** 1 hour

## Objectives completed

- I summarized and investigated the customer scenario.
- I analyzed the difference between private and public IP addresses.
- I developed an explanation for the connectivity issue.
- I summarized my findings for the customer.

## Customer scenario

Jess, a cloud administrator, reported that two EC2 instances in a VPC with CIDR `10.0.0.0/16` had different internet connectivity. Instance A could not reach the internet, while instance B could, even though their AWS configurations appeared similar. Jess also asked whether she should use `12.0.0.0/16` as the CIDR range for a new VPC.

The lab architecture had already been checked, and its routes and attachments were configured correctly. I focused on comparing the instances’ IP addressing rather than changing the architecture.

> **Screenshot placeholder — Customer architecture:** Add the lab diagram showing the VPC, internet gateway, public subnet, and both EC2 instances.

## Task 1: Investigated the instances

In the AWS Management Console, I opened **EC2** > **Instances** and reviewed both instances. For each instance, I recorded its name, public IPv4 address, private IPv4 address, VPC, and subnet from the **Networking** details.

| Instance | Public IPv4 address | Private IPv4 address | VPC/subnet notes |
| --- | --- | --- | --- |
| Instance A | `<recorded value or none>` | `<recorded value>` | `<recorded VPC and subnet>` |
| Instance B | `<recorded value or none>` | `<recorded value>` | `<recorded VPC and subnet>` |

I observed that the instances differed in their public IPv4 address assignment. Instance A had only a private IPv4 address, while Instance B had a public IPv4 address as well as a private address. This difference helped explain why an external SSH connection could reach Instance B but not Instance A.

> **Screenshot placeholder — Instance A networking details:** Add a screenshot showing its public and private IPv4 address fields, VPC, and subnet.
>
> **Screenshot placeholder — Instance B networking details:** Add a screenshot showing its public and private IPv4 address fields, VPC, and subnet.

## Task 2: Tested SSH access and evaluated VPC address space

### Tested SSH connectivity

I used the lab-provided PEM key and followed the SSH instructions for my operating system. On macOS or Linux, I made the key read-only and used the instance’s public address when connecting from outside the VPC:

```bash
chmod 400 labsuser.pem
ssh -i labsuser.pem ec2-user@<instance-public-ip>
```

I was able to connect to the instance that had a public IPv4 address, assuming its security group allowed SSH from my source IP. I could not connect directly from the internet to Instance A using its private IPv4 address because private addresses are not publicly routable. A private instance can still be reached from inside its VPC or through a configured private connection, such as a VPN, Direct Connect, bastion host, or Systems Manager Session Manager.

The public IP assignment alone did not guarantee connectivity: the route to an internet gateway, security group rules, network ACLs, host firewall, and SSH service also had to allow the traffic. In this lab, the architecture was already verified, so the address assignment was the relevant difference.

> **Screenshot placeholder — SSH connection to Instance B:** Add a screenshot showing a successful SSH session. Do not display private keys or credentials.
>
> **Screenshot placeholder — Connection attempt to Instance A:** Add a screenshot showing the failed direct connection or the lack of a public address. Redact personal IP addresses.

### Recommended VPC CIDR range

I recommended that Jess not use `12.0.0.0/16` for a VPC unless her organization owned and was authorized to use that public address range. Public IPv4 ranges may belong to other organizations and are globally routable. Using someone else’s public range internally can cause address conflicts and can prevent or misroute connections to legitimate internet destinations that use those addresses.

For typical private VPC addressing, I recommended choosing a non-overlapping CIDR from the RFC 1918 private ranges:

- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

I also advised Jess to plan the VPC range against existing networks, connected VPCs, VPNs, and on-premises networks to avoid overlapping CIDRs. Public IPv4 addresses could still be assigned to resources that needed internet reachability, while private VPC addressing remained appropriate for internal resources.

## Task 3: Summarized the findings for the customer

I explained that Instance A’s lack of a public IPv4 address prevented direct SSH access from outside the VPC. Instance B had a public IPv4 address, which made it externally addressable when the network routes and security rules also permitted the connection. Private IPv4 addresses remained usable for communication within the VPC and connected private networks.

I recommended that Jess use an appropriate private CIDR range for the new VPC rather than `12.0.0.0/16`, unless she owned that public range. I also recommended checking for CIDR overlap with existing environments before creating the VPC.

> **Screenshot placeholder — Customer response or findings summary:** Add a screenshot of the group activity or written response, with any account-specific information redacted.

## Lab completion

I completed the lab by comparing the instances’ IP configurations, testing SSH access, explaining why a private IP was not directly reachable from the internet, and recommending private address space for the new VPC. I shared the findings with the customer role-play partner.
