# Create Subnets and Allocate IP Addresses in an Amazon VPC

## Lab overview

In this lab, I investigated a customer's VPC requirements and created a VPC with a public subnet. I selected a private IPv4 CIDR range that provided at least 15,000 addresses for the VPC and a subnet CIDR that provided at least 50 addresses for the public subnet. I then summarized the design for the customer.

**Approximate duration:** 1 hour

## Objectives completed

- I summarized and investigated the customer scenario.
- I created an Amazon VPC and a public subnet with suitable CIDR blocks.
- I became familiar with the AWS Management Console's VPC workflow.
- I explained my design and findings to the customer role-play partner.

## Customer scenario

Paulo, a startup owner who was new to AWS, requested a VPC with approximately 15,000 private IP addresses and a public subnet with at least 50 addresses. He asked whether a `192.x.x.x` range could be private and requested a short setup walkthrough.

A VPC was a logically isolated virtual network for AWS resources. Resources in a VPC used private IP addresses to communicate internally. Internet access depended on the network configuration, such as a subnet's route table, an internet gateway, and appropriate public addressing. A subnet was a CIDR range within the VPC CIDR.

> **Screenshot placeholder — Customer architecture:**
<img width="898" height="578" alt="Screenshot 2026-08-06 at 16 56 09" src="https://github.com/user-attachments/assets/54e8450d-1ef6-4d1f-b454-1175e9112e43" />

## Task 1: Investigated the customer's requirements and created the VPC

### Selected CIDR ranges

I used address planning to select non-overlapping CIDR blocks that met Paulo's needs:

| Resource | CIDR block | Address capacity | Why it fit |
| --- | --- | ---: | --- |
| VPC | `192.168.0.0/18` | 16,384 total IPv4 addresses | It was within the RFC 1918 private range `192.168.0.0/16` and exceeded the requested 15,000 addresses. |
| Public subnet | `192.168.1.0/26` | 64 total IPv4 addresses | It provided more than the requested 50 addresses. |

The VPC CIDR was from the private `192.168.0.0/16` block defined by RFC 1918. The `192.x.x.x` notation alone did not guarantee that an address was private; only the designated private ranges were private. The subnet range was contained within the VPC range and was smaller than the VPC range.

AWS reserved five IPv4 addresses in each subnet, so the `/26` subnet provided 59 assignable addresses, which still met the requirement for at least 50. The VPC's 16,384 total addresses also exceeded the requested capacity, though AWS subnet reservations affected the number of addresses assignable to resources inside subnets.

### Created the VPC with one public subnet

In the AWS Management Console, I opened **VPC** and used the VPC creation workflow to create a VPC with a single public subnet. I configured the following values:

| Setting | Value |
| --- | --- |
| VPC configuration | VPC with a Single Public Subnet |
| VPC name | `First VPC` |
| IPv4 CIDR block | `192.168.0.0/18` |
| IPv6 CIDR block | No IPv6 CIDR block |
| Public subnet IPv4 CIDR | `192.168.1.0/26` |
| Availability Zone | No Preference |
| Subnet name | `Public subnet` |
| Other options | Defaults |

I created the VPC and confirmed the success message. I then opened **Your VPCs** and verified that `First VPC` appeared in the VPC list.

> **Screenshot placeholder — VPC wizard configuration:**
<img width="663" height="608" alt="Screenshot 2026-08-06 at 16 36 03" src="https://github.com/user-attachments/assets/64985ba4-7fcd-450f-a527-4ac070a7239a" />
<img width="685" height="623" alt="Screenshot 2026-08-06 at 16 36 18" src="https://github.com/user-attachments/assets/84fb2ca7-caf0-436c-8333-a255050548f4" />

> **Screenshot placeholder — VPC creation confirmation:**
<img width="825" height="631" alt="Screenshot 2026-08-06 at 16 36 58" src="https://github.com/user-attachments/assets/ec394843-00a1-4610-9a15-aeede3039756" />
>
> **Screenshot placeholder — VPC in Your VPCs:**
<img width="825" height="690" alt="Screenshot 2026-08-06 at 16 51 51" src="https://github.com/user-attachments/assets/02ce61ea-c8f4-41b6-af88-3384009f5f54" />


## Task 2: Summarized the response to the customer

I explained that `192.168.0.0/18` was a private VPC CIDR from the RFC 1918 range and provided 16,384 total IPv4 addresses, which exceeded the requested 15,000. I chose `192.168.1.0/26` for the public subnet because it contained 64 total addresses and 59 assignable addresses after AWS's five reserved addresses, meeting Paulo's requirement for at least 50.

I also explained that a public subnet's internet connectivity depended on its routing and the resources' public addressing and security configuration. In this lab, the VPC workflow created the requested single-public-subnet environment; a subnet's name alone did not make it public. The route table and internet gateway configuration determined its routing behavior.


## Lab completion

I completed the lab by planning private CIDR ranges, creating `First VPC` with one public subnet, verifying the resources, and explaining the design choices to the customer role-play partner.

> **Cleanup reminder:** After the activity, I removed lab resources if they were no longer required, following the lab instructions.

## References

- [RFC 1918 — Address Allocation for Private Internets](https://datatracker.ietf.org/doc/html/rfc1918)
- [AWS VPC user guide](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
