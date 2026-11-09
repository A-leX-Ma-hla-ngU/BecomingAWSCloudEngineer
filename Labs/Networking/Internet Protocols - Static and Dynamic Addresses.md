# Internet Protocols - Static and Dynamic Addresses

## Lab overview

In this lab, I investigated a customer's EC2 networking issue. The customer reported that the public IP address of an instance changed whenever it was stopped and started, disrupting resources that depended on a consistent address. I reproduced the behavior, compared public and private IP address persistence, and assigned an Elastic IP address to provide a persistent public IPv4 address.

**Approximate duration:** 60 minutes

## Objectives completed

- I summarized and investigated the customer scenario.
- I compared dynamically assigned public addresses with private addresses.
- I assigned an Elastic IP address to an EC2 instance.
- I summarized the solution for the customer.

## Customer scenario

Bob, a cloud administrator, reported that the public IP address of his EC2 instance, **Public Instance**, changed every time he stopped and started it. Other resources depended on that address, and keeping the instance running continuously was too expensive. Bob asked how he could use a consistent public IP address.

> **Screenshot placeholder — Customer architecture:** Add the lab diagram showing the VPC, internet gateway, public subnet, and EC2 instance.

## Task 1: Investigated the customer's environment

### Launched a test instance

In the AWS Management Console, I opened **EC2** > **Instances** and launched a test instance with the lab configuration:

| Setting | Value |
| --- | --- |
| AMI | Amazon Linux 2 AMI (HVM) |
| Instance type | `t3.micro` |
| VPC | `Lab VPC` |
| Subnet | `Public Subnet 1` |
| Auto-assign public IP | Enabled |
| Name tag | `test instance` |
| Security group | Existing `Linux Instance SG` |
| Key pair | Existing `vockey` RSA key pair |

I left the unlisted settings at their defaults, launched the instance, and waited until it was running and passed its status checks.

> **Screenshot placeholder — Test instance configuration:** Add a screenshot showing the instance's AMI, instance type, subnet, and security group. Redact account details.
>
> **Screenshot placeholder — Instance running:** Add a screenshot showing the `test instance` in the running state with successful status checks.

### Compared the addresses before and after a stop/start

I recorded the public and private IPv4 addresses from the instance's **Networking** tab. I stopped the instance, waited until it was stopped, and checked its addresses again. I then started it, waited until it was running, and recorded the addresses once more.

| State | Public IPv4 address | Private IPv4 address |
| --- | --- | --- |
| Before stopping | `<recorded value>` | `<recorded value>` |
| While stopped | `<recorded value or unavailable>` | `<recorded value>` |
| After starting | `<recorded value>` | `<recorded value>` |

I observed that an auto-assigned public IPv4 address could change after a stop and start. The private IPv4 address remained associated with the instance's network interface in the subnet. Because the instance had an automatically assigned public address rather than a persistent Elastic IP, I had reproduced the customer's issue.

> **Screenshot placeholder — Addresses before stop:** Add a screenshot of the Networking tab before stopping the instance.
>
> **Screenshot placeholder — Addresses after restart:** Add a screenshot of the Networking tab after restarting the instance. Redact public IPs if they should not be shared.

### Allocated and associated an Elastic IP address

In the EC2 console, I opened **Network & Security** > **Elastic IPs** and allocated an Elastic IP address using the lab's default settings. I recorded the allocated address, selected it, and chose **Actions** > **Associate Elastic IP address**. I selected **Instance** as the resource type, chose `test instance`, selected its private IP address, and associated the Elastic IP.

I returned to **Instances**, selected `test instance`, and confirmed that the Networking tab showed the Elastic IP as the public IPv4 address. I stopped and started the instance again and verified that the Elastic IP remained assigned.

| Address type | Behavior observed |
| --- | --- |
| Auto-assigned public IPv4 address | Could change when the instance was stopped and started |
| Private IPv4 address | Was used for communication within the VPC and associated private networks |
| Elastic IP address | Provided a persistent public IPv4 address while it remained allocated and associated |

> **Screenshot placeholder — Allocated Elastic IP:** Add a screenshot showing the allocated address. Redact it if it should not be shared publicly.
>
> **Screenshot placeholder — Elastic IP association:** Add a screenshot showing the EIP associated with `test instance`.
>
> **Screenshot placeholder — Elastic IP after restart:** Add a screenshot showing that the same EIP remained assigned after the stop/start cycle.

## Task 2: Summarized the findings for the customer

I explained to Bob that the instance had been using an auto-assigned public IPv4 address, which was not guaranteed to remain the same after a stop and start. I recommended allocating and associating an Elastic IP address when a persistent public IPv4 address was required. The Elastic IP remained stable while it was allocated to the account and associated with the instance or its network interface.

I also noted that an Elastic IP was a public address and should be used only where needed. I reminded Bob to review AWS pricing and release an Elastic IP when it was no longer required, because unused or unassociated public IPv4 addresses could incur charges.

> **Screenshot placeholder — Customer response or group discussion:** Add a screenshot of the final findings or presentation, with account-specific details redacted.

## Lab completion

I reproduced the changing public IP behavior, associated an Elastic IP address with the test instance, verified that it persisted through a stop/start cycle, and presented the solution to the customer role-play partner.

> **Cleanup reminder:** After completing the activity, I released the Elastic IP and terminated the test instance if they were no longer needed, following the lab cleanup instructions.
