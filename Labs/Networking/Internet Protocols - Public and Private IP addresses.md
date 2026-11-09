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

> **Screenshot placeholder — Customer architecture:**
<img width="739" height="465" alt="Screenshot 2026-11-09 at 18 39 50" src="https://github.com/user-attachments/assets/1551223b-d3c9-4a16-950d-27aa92571581" />

## Task 1: Investigated the instances

In the AWS Management Console, I opened **EC2** > **Instances** and reviewed both instances. For each instance, I recorded its name, public IPv4 address, private IPv4 address, VPC, and subnet from the **Networking** details.

| Instance | Public IPv4 address | Private IPv4 address | VPC/subnet notes |
| --- | --- | --- | --- |
| Instance A | `<none>` | `10.0.10.181` | `vpc-0a5dc9a61445da23c and subnet-067e00ec69539f283` |
| Instance B | `<recorded value>` | `10.0.10.17` | `vpc-0a5dc9a61445da23c and subnet-067e00ec69539f283` |

I observed that the instances differed in their public IPv4 address assignment. Instance A had only a private IPv4 address, while Instance B had a public IPv4 address as well as a private address. This difference helped explain why an external SSH connection could reach Instance B but not Instance A.

> **Screenshot placeholder — Instance A networking details:**

<img width="812" height="662" alt="Screenshot 2026-11-09 at 18 56 14" src="https://github.com/user-attachments/assets/c2915c4a-3e21-49a8-bc7b-a321782fe1b6" />
<img width="800" height="582" alt="Screenshot 2026-11-09 at 18 56 36" src="https://github.com/user-attachments/assets/b4bbcb56-d403-4ab1-80ed-ed85e3baa7b3" />

> **Screenshot placeholder — Instance B networking details:**

<img width="782" height="490" alt="Screenshot 2026-11-09 at 18 57 24" src="https://github.com/user-attachments/assets/6d2530bb-b1e9-41f6-9f29-7327cceeea35" />
<img width="801" height="538" alt="Screenshot 2026-11-09 at 18 57 41" src="https://github.com/user-attachments/assets/e92ab07a-dfd5-4fe7-bd76-41dfc674ef39" />


## Task 2: Tested SSH access and evaluated VPC address space

### Tested SSH connectivity

I used the lab-provided PEM key and followed the SSH instructions for my operating system. On macOS or Linux, I made the key read-only and used the instance’s public address when connecting from outside the VPC:

```bash
chmod 400 labsuser.pem
ssh -i labsuser.pem ec2-user@<instance-public-ip>
```

I was able to connect to the instance that had a public IPv4 address, assuming its security group allowed SSH from my source IP. I could not connect directly from the internet to Instance A using its private IPv4 address because private addresses are not publicly routable. A private instance can still be reached from inside its VPC or through a configured private connection, such as a VPN, Direct Connect, bastion host, or Systems Manager Session Manager.

The public IP assignment alone did not guarantee connectivity: the route to an internet gateway, security group rules, network ACLs, host firewall, and SSH service also had to allow the traffic. In this lab, the architecture was already verified, so the address assignment was the relevant difference.

> **Screenshot placeholder — SSH connection to Instance B:**
<img width="806" height="372" alt="Screenshot 2026-08-05 at 12 32 39" src="https://github.com/user-attachments/assets/48f08a80-c2aa-473a-92de-c8823adbc938" />
>
> **Screenshot placeholder — Connection attempt to Instance A:**
<img width="811" height="113" alt="Screenshot 2026-08-05 at 13 26 32" src="https://github.com/user-attachments/assets/f454d6d0-f91c-43b3-8ee8-3245b9d50ba5" />
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

## Lab completion

I completed the lab by comparing the instances’ IP configurations, testing SSH access, explaining why a private IP was not directly reachable from the internet, and recommending private address space for the new VPC. I shared the findings with the customer role-play partner.
