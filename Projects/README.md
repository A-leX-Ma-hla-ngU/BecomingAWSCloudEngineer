# Projects

This directory contains programming and automation work that applies concepts from my cloud engineering studies. The projects are a mix of independent portfolio work and guided learning exercises; each README explains the scope and how to validate it.

## Independent portfolio projects

### [Linux Server Health Monitor](linux-server-health-monitor/README.md)

A read-only Bash utility that checks Linux load average, memory usage, filesystem capacity, and optional systemd service status. It uses configurable thresholds and exit codes suitable for later scheduling or monitoring integration.

### [AWS CloudFormation — VPC Network Foundation](aws-cloudformation-network-foundation/README.md)

A CloudFormation template that provisions a VPC, two public subnets across Availability Zones, an Internet Gateway, route table, and a security group with restricted SSH ingress. It deliberately avoids EC2 and NAT Gateway resources to keep the initial lab footprint cost-conscious.

### [AWS CloudWatch EC2 Monitoring and SNS Alerting](aws-cloudwatch-ec2-alerting/README.md)

A CloudFormation template that monitors CPU utilization for an existing EC2 instance and sends alarm-state notifications through Amazon SNS to an email subscription.

## Application delivery

### [Python CI/CD Demo — GitHub Actions and Docker](python-github-actions-cicd/README.md)

A Python HTTP health-check service with unit tests and a Docker image. A repository-level GitHub Actions workflow runs tests and builds the image; publishing to GitHub Container Registry is restricted to successful pushes to the main branch.

## Python practice

### [Python Exercises](Python-Exercises/README.md)

Beginner exercises covering variables, data types, strings, numbers, operators, lists, dictionaries, conditionals, loops, and structured data.

A second Python-Exercises directory exists at the repository root. Both locations are retained to avoid removing or relocating learning material without reviewing its history and contents.

## GitHub profile

A draft profile README is available at [profile/README.md](../profile/README.md). To display it on the GitHub profile, create a public repository named exactly `A-leX-Ma-hla-ngU` and place the draft at its root as `README.md`.

See the [lab index](../Labs/README.md) for guided AWS and Linux exercises.
