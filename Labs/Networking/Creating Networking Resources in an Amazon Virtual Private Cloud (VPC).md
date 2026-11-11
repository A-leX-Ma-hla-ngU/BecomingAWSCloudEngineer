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

> **Screenshot placeholder — Customer architecture:**
<img width="554" height="376" alt="Screenshot 2026-11-11 at 20 49 32" src="https://github.com/user-attachments/assets/b89f629f-fdbc-48cb-ad94-0ef7dfd894a2" />

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

> **Screenshot placeholder — VPC settings:**
<img width="690" height="637" alt="Screenshot 2026-08-10 at 12 40 53" src="https://github.com/user-attachments/assets/a0baeada-92e5-4a0d-b625-224d1275ce47" />
<img width="806" height="684" alt="Screenshot 2026-08-10 at 12 42 48" src="https://github.com/user-attachments/assets/fd285d8a-de0d-4d72-9185-b10326fdd6d3" />

> **Screenshot placeholder — Subnet settings:**
<img width="825" height="269" alt="Screenshot 2026-08-10 at 12 50 48" src="https://github.com/user-attachments/assets/dd8ac191-e5aa-4e2d-b937-108033b193e4" />
<img width="823" height="541" alt="Screenshot 2026-08-10 at 12 51 28" src="https://github.com/user-attachments/assets/8f659364-4b0c-41df-a33a-053fe75c3a28" />
<img width="781" height="152" alt="Screenshot 2026-08-12 at 16 01 32" src="https://github.com/user-attachments/assets/cc4f4efa-ae1e-4094-a60c-ae9d18cc9677" />

### Created the route table and internet gateway

I created a route table named `Public route table` and associated it with `Test VPC`. I created an internet gateway named `IGW test VPC` and attached it to `Test VPC`.

In the route table's **Routes** tab, I added a route for internet-bound traffic:

| Destination | Target |
| --- | --- |
| `0.0.0.0/0` | `IGW test VPC` |

I saved the route, opened **Subnet associations**, associated `Public subnet` with `Public route table`, and saved the association. The VPC's local route remained in place.

> **Screenshot placeholder — Internet gateway attachment:** <img width="824" height="647" alt="Screenshot 2026-08-12 at 16 23 24" src="https://github.com/user-attachments/assets/23b2ec0a-b8c9-413f-b84a-c77da1608867" />
<img width="824" height="667" alt="Screenshot 2026-08-12 at 16 25 40" src="https://github.com/user-attachments/assets/538625af-3fff-41fc-9ad3-deeb8aca68b7" />


> **Screenshot placeholder — Public route table route:**
<img width="820" height="340" alt="Screenshot 2026-08-12 at 16 31 00" src="https://github.com/user-attachments/assets/fb0ddb70-cd08-4b90-898f-4a18df10ac38" />
<img width="821" height="657" alt="Screenshot 2026-08-12 at 16 32 29" src="https://github.com/user-attachments/assets/a4715e3d-6982-4f47-9cc0-24875262733c" />
<img width="800" height="370" alt="Screenshot 2026-08-12 at 16 32 53" src="https://github.com/user-attachments/assets/8e495b81-6862-4f2d-a046-722b1a5654cb" />
<img width="414" height="511" alt="Screenshot 2026-08-12 at 16 33 17" src="https://github.com/user-attachments/assets/3a3beae6-289e-4819-af46-f5fdab7d22c7" />
<img width="812" height="317" alt="Screenshot 2026-08-12 at 16 34 57" src="https://github.com/user-attachments/assets/8454ca4b-5c1f-4d07-9572-91861a9b8901" />


> **Screenshot placeholder — Subnet association:**
<img width="819" height="554" alt="Screenshot 2026-08-12 at 16 36 00" src="https://github.com/user-attachments/assets/71b6d4b2-aa4d-461e-8743-e9ac0bbd68d2" />
<img width="826" height="706" alt="Screenshot 2026-08-12 at 16 36 31" src="https://github.com/user-attachments/assets/0dba9b0b-5dcb-43bf-85b3-467fc97e4718" />

### Created and configured the network ACL

I created a network ACL named `Public Subnet NACL` in `Test VPC`. I added an inbound rule and an outbound rule with rule number `100`, each allowing all traffic. The default `*` rule denied traffic that did not match an earlier rule. I associated the ACL with `Public subnet` if it was not already associated.

Network ACLs were stateless, so inbound and outbound traffic were evaluated independently. The all-traffic rules were used for this lab's connectivity test; production ACL rules should be narrowed to the required protocols, ports, and sources.

> **Screenshot placeholder — Network ACL inbound rules:**
<img width="824" height="700" alt="Screenshot 2026-08-12 at 16 45 52" src="https://github.com/user-attachments/assets/f7ae8795-a900-4475-b6ff-cda96863b8f6" />
<img width="829" height="703" alt="Screenshot 2026-08-12 at 16 47 01" src="https://github.com/user-attachments/assets/f88c242d-5cc0-4808-93e6-92ca3d05dc75" />
<img width="818" height="714" alt="Screenshot 2026-08-12 at 16 48 21" src="https://github.com/user-attachments/assets/2454a8a4-46b2-41f8-a4bd-4884addebede" />
<img width="806" height="180" alt="Screenshot 2026-08-12 at 17 40 03" src="https://github.com/user-attachments/assets/6c34f3c3-a8a9-4ea4-a7cc-98f04d611f30" />


> **Screenshot placeholder — Network ACL outbound rules:**
<img width="1663" height="250" alt="Screenshot 2026-08-12 at 16 49 11" src="https://github.com/user-attachments/assets/9af46e34-a2ae-4290-920c-4d2800dc5e2f" />
>
> **Screenshot placeholder — NACL subnet association:**
<img width="803" height="368" alt="Screenshot 2026-08-12 at 16 51 30" src="https://github.com/user-attachments/assets/734a51b4-8da7-435e-b26a-24cac4bf91ba" />
<img width="821" height="520" alt="Screenshot 2026-08-12 at 16 51 57" src="https://github.com/user-attachments/assets/d23715b8-428c-4a0f-b3a9-5932293c423d" />
<img width="835" height="710" alt="Screenshot 2026-08-12 at 16 52 23" src="https://github.com/user-attachments/assets/e7240bae-b6f1-4320-a205-dc7d8856e40b" />


### Created and configured the security group

I created a security group named `public security group` in `Test VPC`, with the description `allows public access`. I configured its inbound rules for SSH, HTTP, and HTTPS, and left outbound traffic allowed for the lab connectivity test.

The lab rules allowed inbound SSH, HTTP, and HTTPS from anywhere. This was a lab configuration, not a production recommendation. In a real environment, I would restrict SSH to trusted source IPs and allow only the application traffic that was needed. Security groups were stateful and applied to network interfaces; unlike network ACLs, they did not have explicit deny rules.

> **Screenshot placeholder — Security group details:**
<img width="820" height="709" alt="Screenshot 2026-08-12 at 16 55 01" src="https://github.com/user-attachments/assets/05053d1e-bd56-480b-9904-6de4e51e29ba" />

> **Screenshot placeholder — Security group rules:**
<img width="817" height="530" alt="Screenshot 2026-08-12 at 16 55 41" src="https://github.com/user-attachments/assets/1e766ebe-9c2f-469a-a132-e53ca03e7b5f" />
<img width="809" height="459" alt="Screenshot 2026-08-12 at 16 56 46" src="https://github.com/user-attachments/assets/adeff9a9-bf60-489c-b834-2ebdba6d8bac" />
<img width="819" height="475" alt="Screenshot 2026-08-12 at 16 57 21" src="https://github.com/user-attachments/assets/855324e7-e75d-4e2a-835f-53fa9dceb066" />
<img width="819" height="529" alt="Screenshot 2026-08-12 at 16 57 49" src="https://github.com/user-attachments/assets/ddbeed9c-502c-40f0-b367-06035e56cc84" />


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

> **Screenshot placeholder — EC2 instance configuration:**
<img width="815" height="639" alt="Screenshot 2026-08-12 at 17 03 39" src="https://github.com/user-attachments/assets/009c3d8e-7f5e-47f9-960b-9afaebf439b4" />
<img width="820" height="376" alt="Screenshot 2026-08-12 at 17 04 02" src="https://github.com/user-attachments/assets/6dfe86b4-79e9-41e7-b458-50360059f6c2" />
<img width="789" height="362" alt="Screenshot 2026-08-12 at 17 04 17" src="https://github.com/user-attachments/assets/e10a45c6-4402-4669-8274-40fba0f72385" />
<img width="799" height="342" alt="Screenshot 2026-08-12 at 17 06 16" src="https://github.com/user-attachments/assets/2dd888d5-69b2-4814-ad91-ee30de110101" />
<img width="786" height="95" alt="Screenshot 2026-08-12 at 17 06 27" src="https://github.com/user-attachments/assets/08966c3e-aca4-432d-aebb-7feddb0275f8" />
<img width="760" height="324" alt="Screenshot 2026-08-12 at 17 11 40" src="https://github.com/user-attachments/assets/5ab23850-6074-47d9-887a-c34473f5d59f" />
<img width="807" height="229" alt="Screenshot 2026-08-12 at 17 11 54" src="https://github.com/user-attachments/assets/052466b6-dc7f-4b15-8bb7-8578c09ce664" />


> **Screenshot placeholder — Running EC2 instance:**
<img width="828" height="411" alt="Screenshot 2026-08-12 at 17 17 07" src="https://github.com/user-attachments/assets/dc922b0f-1dbf-4567-b675-33df171020db" />
> **Screenshot placeholder — SSH session:**
<img width="811" height="340" alt="Screenshot 2026-08-12 at 17 40 34" src="https://github.com/user-attachments/assets/a818636c-3cd1-4b85-826c-9ea09e85aa92" />

## Task 3: Tested internet connectivity

From the SSH session, I tested name resolution and outbound connectivity by running:

```bash
ping google.com
```

After receiving replies, I stopped the ping with `Ctrl+C` (or `Cmd+C` in the lab's macOS instructions). The replies and packet-loss summary confirmed that the instance could reach the destination. If the test had failed, I would have checked the instance's public IP, subnet route-table association, `0.0.0.0/0` route to the attached internet gateway, security group egress, network ACL inbound and outbound rules, and DNS configuration.

> **Screenshot placeholder — Successful ping:**
<img width="815" height="275" alt="Screenshot 2026-08-12 at 17 42 19" src="https://github.com/user-attachments/assets/73e11957-4399-47a5-8f3b-a359e05c6706" />
<img width="840" height="93" alt="Screenshot 2026-08-12 at 17 42 56" src="https://github.com/user-attachments/assets/addb7c2e-9f52-457b-ad1f-87be70c83af3" />

## Findings and lab completion

I completed the lab by connecting the VPC, public subnet, route table, internet gateway, network ACL, security group, and EC2 instance, then verifying internet connectivity with `ping`. The successful test confirmed that the lab instance had a working path out of the VPC.

I explained to Brock that internet connectivity depended on the complete network path: a public address for direct IPv4 internet communication, a route from the subnet to an attached internet gateway, and firewall rules that permitted the traffic. I also noted that the lab's broad rules should be restricted before using a similar design in production.

> **Cleanup reminder:** After completing the activity, I stopped or removed lab resources as instructed to avoid unnecessary charges.
