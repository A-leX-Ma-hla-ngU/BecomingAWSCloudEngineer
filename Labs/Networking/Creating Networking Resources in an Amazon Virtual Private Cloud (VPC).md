# Creating Networking Resources in an Amazon Virtual Private Cloud (VPC)

## Lab overview

In this lab, I built a routable VPC for a customer who could not ping outside the VPC. I created a VPC, subnet, route table, internet gateway, network ACL, and security group, launched an EC2 instance in the public subnet, and tested connectivity with `ping`.

**Approximate duration:** 60 minutes

## Objectives completed

- I summarized and investigated the customer scenario.
- I created and connected VPC networking resources.
- I launched an EC2 instance in the public subnet.
- I tested outbound connectivity with `ping`.

## Customer scenario

Brock, a startup owner, had created a VPC but could not ping an internet destination from an EC2 instance. He requested help connecting his network resources so that the instance could reach the internet.

I used the following address ranges from the customer requirements:

| Resource | Name | CIDR |
| --- | --- | --- |
| VPC | `Test VPC` | `192.168.0.0/18` |
| Public subnet | `Public subnet` | `192.168.1.0/26` |

A VPC provided an isolated virtual network. Subnets divided its address range. A route table directed traffic, an internet gateway enabled internet routing, a network ACL filtered traffic at the subnet level, and a security group filtered traffic at the instance level.

> **Screenshot placeholder — Customer architecture:** Add the lab diagram showing the VPC, internet gateway, public subnet, security group, and EC2 instance.

## Task 1: Built and investigated the VPC network

I used a top-down sequence, starting with the VPC and then adding the subnet and its network components.

### Created the VPC and subnet

In the VPC console, I opened **Your VPCs** > **Create VPC** and configured:

| Setting | Value |
| --- | --- |
| Name | `Test VPC` |
| IPv4 CIDR block | `192.168.0.0/18` |
| Other settings | Defaults |

I then opened **Subnets** > **Create subnet**, selected `Test VPC`, and configured:

| Setting | Value |
| --- | --- |
| Subnet name | `Public subnet` |
| Availability Zone | No preference |
| IPv4 CIDR block | `192.168.1.0/26` |

> **Screenshot placeholder — VPC settings:** Add a screenshot showing `Test VPC` and `192.168.0.0/18`.
>
> **Screenshot placeholder — Subnet settings:** Add a screenshot showing `Public subnet` in `Test VPC` with CIDR `192.168.1.0/26`.

### Created the route table and internet gateway

I created a route table named `Public route table` and associated it with `Test VPC`. I created an internet gateway named `IGW test VPC` and attached it to `Test VPC`.

In the route table's **Routes** tab, I added a route for internet-bound traffic:

| Destination | Target |
| --- | --- |
| `0.0.0.0/0` | `IGW test VPC` |

I saved the route, opened **Subnet associations**, associated `Public subnet` with `Public route table`, and saved the association. The VPC's local route remained in place.

> **Screenshot placeholder — Internet gateway attachment:** Add a screenshot showing `IGW test VPC` attached to `Test VPC`.
>
> **Screenshot placeholder — Public route table route:** Add a screenshot showing `0.0.0.0/0` routed to the internet gateway.
>
> **Screenshot placeholder — Subnet association:** Add a screenshot showing `Public subnet` associated with `Public route table`.

### Created and configured the network ACL

I created a network ACL named `Public Subnet NACL` in `Test VPC`. I added an inbound rule and an outbound rule with rule number `100`, each allowing all traffic. The default `*` rule denied traffic that did not match an earlier rule. I associated the ACL with `Public subnet` if it was not already associated.

Network ACLs were stateless, so inbound and outbound traffic were evaluated independently. The all-traffic rules were used for this lab's connectivity test; production ACL rules should be narrowed to the required protocols, ports, and sources.

> **Screenshot placeholder — Network ACL inbound rules:** Add a screenshot showing rule 100 allowing the lab traffic.
>
> **Screenshot placeholder — Network ACL outbound rules:** Add a screenshot showing rule 100 allowing the lab traffic.
>
> **Screenshot placeholder — NACL subnet association:** Add a screenshot showing `Public subnet` associated with `Public Subnet NACL`.

### Created and configured the security group

I created a security group named `public security group` in `Test VPC`, with the description `allows public access`. I configured its inbound rules for SSH, HTTP, and HTTPS, and left outbound traffic allowed for the lab connectivity test.

The lab rules allowed inbound SSH, HTTP, and HTTPS from anywhere. This was a lab configuration, not a production recommendation. In a real environment, I would restrict SSH to trusted source IPs and allow only the application traffic that was needed. Security groups were stateful and applied to network interfaces; unlike network ACLs, they did not have explicit deny rules.

> **Screenshot placeholder — Security group details:** Add a screenshot showing the group name and VPC.
>
> **Screenshot placeholder — Security group rules:** Add a screenshot showing the inbound and outbound rules. For public sharing, avoid displaying unnecessarily broad rules or account-specific details.

## Task 2: Launched and connected to an EC2 instance

In the EC2 console, I selected **Launch instances** and configured an Amazon Linux 2023 instance:

| Setting | Value |
| --- | --- |
| AMI | Amazon Linux 2023 |
| Instance type | `t3.micro` |
| Key pair | `vockey` |
| VPC | `Test VPC` |
| Subnet | `Public subnet` |
| Auto-assign public IP | Enabled |
| Existing security group | `public security group` |

I launched the instance and waited until its state was **Running** and its status checks passed. I used the lab-provided PEM credentials to connect over SSH, keeping the private key secure. On macOS or Linux, I made the key read-only and connected to the instance's public IPv4 address:

```bash
chmod 400 labsuser.pem
ssh -i labsuser.pem ec2-user@<public-ip>
```

> **Screenshot placeholder — EC2 instance configuration:** Add a screenshot showing the AMI, instance type, VPC, subnet, and security group.
>
> **Screenshot placeholder — Running EC2 instance:** Add a screenshot showing the instance in the running state with successful status checks.
>
> **Screenshot placeholder — SSH session:** Add a screenshot showing the connected terminal. Do not include the private key or credentials.

## Task 3: Tested internet connectivity

From the SSH session, I tested name resolution and outbound connectivity by running:

```bash
ping google.com
```

After receiving replies, I stopped the ping with `Ctrl+C` (or `Cmd+C` in the lab's macOS instructions). The replies and packet-loss summary confirmed that the instance could reach the destination. If the test had failed, I would have checked the instance's public IP, subnet route-table association, `0.0.0.0/0` route to the attached internet gateway, security group egress, network ACL inbound and outbound rules, and DNS configuration.

> **Screenshot placeholder — Successful ping:** Add a screenshot showing replies from `google.com` and the packet-loss summary. Redact public IP addresses if needed.

## Findings and lab completion

I completed the lab by connecting the VPC, public subnet, route table, internet gateway, network ACL, security group, and EC2 instance, then verifying internet connectivity with `ping`. The successful test confirmed that the lab instance had a working path out of the VPC.

I explained to Brock that internet connectivity depended on the complete network path: a public address for direct IPv4 internet communication, a route from the subnet to an attached internet gateway, and firewall rules that permitted the traffic. I also noted that the lab's broad rules should be restricted before using a similar design in production.

> **Cleanup reminder:** After completing the activity, I stopped or removed lab resources as instructed to avoid unnecessary charges.
