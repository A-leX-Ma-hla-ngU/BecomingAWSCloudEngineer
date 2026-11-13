# AWS CloudFormation — VPC Network Foundation

A reusable AWS CloudFormation template that provisions a small VPC network foundation across two Availability Zones.

## Architecture

```text
                         Internet
                            |
                     Internet Gateway
                            |
                     VPC 10.20.0.0/16
                            |
                    Public Route Table
                     /              \\
                    /                \\
          Public Subnet A       Public Subnet B
             10.20.1.0/24         10.20.2.0/24
             AZ 1                  AZ 2

       Shared security group: SSH (TCP/22) from a
       user-supplied trusted IPv4 CIDR only
```

## Resources created

- One VPC with DNS support and DNS hostnames enabled.
- Two public subnets in separate Availability Zones.
- One Internet Gateway and VPC attachment.
- One public route table with a default route to the Internet Gateway.
- Associations between both public subnets and the public route table.
- One security group with SSH ingress restricted to a parameter.

## Cost and safety design

This template intentionally does not create EC2 instances, NAT gateways, load balancers, or managed databases. The network resources do not incur the ongoing compute and NAT gateway charges associated with those services, but AWS pricing and any applicable data transfer or public IPv4 charges can change. Check current pricing for your region before deploying.

The SSH rule must not be left open to `0.0.0.0/0`. Replace the example `SshAllowedCidr` parameter with your trusted public IPv4 address in `/32` notation. The default is a documentation-only example and is not your address.

## Deploy

Use a non-production AWS lab account and a region with at least two Availability Zones.

1. Save the template as `template.yaml`.
2. Replace the example SSH CIDR with your trusted public IPv4 CIDR.
3. Validate the template:

   ```bash
   aws cloudformation validate-template --template-body file://template.yaml
   ```

4. Create the stack:

   ```bash
   aws cloudformation deploy \
     --template-file template.yaml \
     --stack-name portfolio-network-foundation \
     --parameter-overrides EnvironmentName=portfolio-lab SshAllowedCidr=YOUR_PUBLIC_IP/32
   ```

5. Inspect the stack outputs and verify the VPC, subnets, route table, Internet Gateway attachment, and security group in the VPC console.

Do not literally enter `YOUR_PUBLIC_IP/32`; replace it with your actual trusted IPv4 address.

## Clean up

When finished, delete the stack:

```bash
aws cloudformation delete-stack --stack-name portfolio-network-foundation
aws cloudformation wait stack-delete-complete --stack-name portfolio-network-foundation
```

Confirm that the stack reaches `DELETE_COMPLETE` and that its resources are removed.

## Learning objectives

- Define AWS networking resources as infrastructure as code.
- Understand VPC and subnet CIDR allocation.
- Place subnets in separate Availability Zones.
- Route internet-bound traffic through an Internet Gateway.
- Restrict administrative access using a security group parameter.
- Use CloudFormation outputs to discover resource IDs.

## Evidence to add after deployment

- CloudFormation stack status showing `CREATE_COMPLETE`.
- VPC resource map showing both subnets and the Internet Gateway route.
- Stack outputs with resource IDs (redact account IDs and any sensitive values).
- Successful stack deletion status.

Do not add credentials, access keys, private IP details from unrelated environments, or unrestricted SSH rules to the repository.
