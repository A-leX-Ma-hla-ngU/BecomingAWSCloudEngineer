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

> **Screenshot placeholder — Customer architecture:**
<img width="806" height="539" alt="Screenshot 2026-08-06 at 09 58 30" src="https://github.com/user-attachments/assets/7b4beecd-b01d-4fb9-977c-c5dae46c08a8" />

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

> **Screenshot placeholder — Test instance configuration:**
<img width="775" height="160" alt="Screenshot 2026-08-06 at 12 13 23" src="https://github.com/user-attachments/assets/3431ef31-02ae-4b37-8199-961fbf288d87" />
<img width="822" height="411" alt="Screenshot 2026-08-06 at 12 13 31" src="https://github.com/user-attachments/assets/dee0baab-5a3f-4e5a-a4db-477ec556860f" />
<img width="820" height="345" alt="Screenshot 2026-08-06 at 12 17 54" src="https://github.com/user-attachments/assets/6e156efc-077d-42e6-8a00-35a8cf525736" />
<img width="831" height="362" alt="Screenshot 2026-08-06 at 12 22 45" src="https://github.com/user-attachments/assets/63bca4df-2826-43be-8b56-9015868878ac" />
<img width="810" height="120" alt="Screenshot 2026-08-06 at 12 23 25" src="https://github.com/user-attachments/assets/f2ea2117-a994-41c9-9f2e-ac686d0c0c54" />
<img width="804" height="313" alt="Screenshot 2026-08-06 at 12 23 35" src="https://github.com/user-attachments/assets/66aee1b9-fa1d-496b-885a-946467cc3020" />
<img width="816" height="279" alt="Screenshot 2026-08-06 at 12 41 52" src="https://github.com/user-attachments/assets/6e569352-c449-42b2-a25c-eac8fbbeb665" />
<img width="788" height="440" alt="Screenshot 2026-08-06 at 12 44 45" src="https://github.com/user-attachments/assets/292847fa-2cca-4850-a3a5-cb2c8dde146f" />
<img width="819" height="258" alt="Screenshot 2026-08-06 at 12 57 38" src="https://github.com/user-attachments/assets/0238248d-f44b-47c7-8dd4-11502997d525" />
<img width="800" height="273" alt="Screenshot 2026-08-06 at 12 57 46" src="https://github.com/user-attachments/assets/03851e08-ea98-4feb-bf15-c89362eea641" />

> **Screenshot placeholder — Instance running:**
<img width="549" height="145" alt="Screenshot 2026-08-06 at 12 58 41" src="https://github.com/user-attachments/assets/72588769-1d9c-44f1-82aa-5b0f2910347e" />
<img width="784" height="166" alt="Screenshot 2026-08-06 at 13 04 18" src="https://github.com/user-attachments/assets/d33c29fd-4729-4966-a089-c61ce622d1f6" />


### Compared the addresses before and after a stop/start

I recorded the public and private IPv4 addresses from the instance's **Networking** tab. I stopped the instance, waited until it was stopped, and checked its addresses again. I then started it, waited until it was running, and recorded the addresses once more.

| State | Public IPv4 address | Private IPv4 address |
| --- | --- | --- |
| Before stopping | `44.244.223.122` | `10.0.10.72` |
| While stopped | ` unavailable` | `10.0.10.72` |
| After starting | `44.247.238.174` | `10.0.10.72` |

I observed that an auto-assigned public IPv4 address could change after a stop and start. The private IPv4 address remained associated with the instance's network interface in the subnet. Because the instance had an automatically assigned public address rather than a persistent Elastic IP, I had reproduced the customer's issue.

> **Screenshot placeholder — Addresses before stop:**
<img width="795" height="158" alt="Screenshot 2026-08-06 at 13 06 07" src="https://github.com/user-attachments/assets/a74d0a28-19d9-40a4-8af4-3f9652bc55d8" />
>
> **Screenshot placeholder — Addresses after restart:**
<img width="821" height="331" alt="Screenshot 2026-08-06 at 13 14 35" src="https://github.com/user-attachments/assets/cbc61026-cb66-4f15-bb23-901b30810613" />

### Allocated and associated an Elastic IP address

In the EC2 console, I opened **Network & Security** > **Elastic IPs** and allocated an Elastic IP address using the lab's default settings. I recorded the allocated address, selected it, and chose **Actions** > **Associate Elastic IP address**. I selected **Instance** as the resource type, chose `test instance`, selected its private IP address, and associated the Elastic IP.

I returned to **Instances**, selected `test instance`, and confirmed that the Networking tab showed the Elastic IP as the public IPv4 address. I stopped and started the instance again and verified that the Elastic IP remained assigned.

| Address type | Behavior observed |
| --- | --- |
| Auto-assigned public IPv4 address | Could change when the instance was stopped and started |
| Private IPv4 address | Was used for communication within the VPC and associated private networks |
| Elastic IP address | Provided a persistent public IPv4 address while it remained allocated and associated |

> **Screenshot placeholder — Allocated Elastic IP:**
<img width="809" height="517" alt="Screenshot 2026-08-06 at 13 43 06" src="https://github.com/user-attachments/assets/29e4a9a6-8884-47b9-8a23-ef557d273054" />

> **Screenshot placeholder — Elastic IP association:**
<img width="811" height="438" alt="Screenshot 2026-08-06 at 13 44 06" src="https://github.com/user-attachments/assets/37921f89-0622-43e9-9a66-e6ce6609eec5" />

<img width="491" height="427" alt="Screenshot 2026-08-06 at 13 44 28" src="https://github.com/user-attachments/assets/6eca1b76-216a-4841-9194-77d2b3036e8b" />

<img width="819" height="728" alt="Screenshot 2026-08-06 at 13 44 57" src="https://github.com/user-attachments/assets/72fe75bd-d1b1-4ae4-a290-ff3c7e059c46" />

<img width="800" height="423" alt="Screenshot 2026-08-06 at 13 45 39" src="https://github.com/user-attachments/assets/e433ed70-be6d-4a1a-bbe6-a613981b20b0" />

<img width="835" height="332" alt="Screenshot 2026-08-06 at 13 46 49" src="https://github.com/user-attachments/assets/6da31028-0311-4bd3-b8a7-bc1407dccd9c" />

> **Screenshot placeholder — Elastic IP after restart:**
<img width="813" height="306" alt="Screenshot 2026-08-06 at 13 47 49" src="https://github.com/user-attachments/assets/8167e68d-fd0f-4a62-abca-5587f27cc0f3" />
<img width="815" height="442" alt="Screenshot 2026-08-06 at 13 48 58" src="https://github.com/user-attachments/assets/0eadbe3c-75e1-4afc-b95a-ebee055e44be" />
<img width="821" height="515" alt="Screenshot 2026-08-06 at 13 49 57" src="https://github.com/user-attachments/assets/fe1a4bea-03f0-4374-8862-80567840cb3c" />

## Task 2: Summarized the findings for the customer

I explained to Bob that the instance had been using an auto-assigned public IPv4 address, which was not guaranteed to remain the same after a stop and start. I recommended allocating and associating an Elastic IP address when a persistent public IPv4 address was required. The Elastic IP remained stable while it was allocated to the account and associated with the instance or its network interface.

I also noted that an Elastic IP was a public address and should be used only where needed. I reminded Bob to review AWS pricing and release an Elastic IP when it was no longer required, because unused or unassociated public IPv4 addresses could incur charges.


## Lab completion

I reproduced the changing public IP behavior, associated an Elastic IP address with the test instance, verified that it persisted through a stop/start cycle, and presented the solution to the customer role-play partner.

> **Cleanup reminder:** After completing the activity, I released the Elastic IP and terminated the test instance if they were no longer needed, following the lab cleanup instructions.
