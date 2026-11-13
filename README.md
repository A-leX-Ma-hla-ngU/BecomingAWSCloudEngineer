# Becoming an AWS Cloud Engineer

A practical learning portfolio documenting my development toward cloud operations and junior cloud engineering roles. This repository brings together AWS Academy / AWS re:Start-style lab notes, Linux and networking practice, and programming and automation projects.

> **Portfolio note:** The lab write-ups represent guided, hands-on learning exercises. They are evidence of practice and troubleshooting, not claims of production engineering experience.

## Start here

- [AWS and Linux labs](Labs/README.md) — browse the lab notes by technical area.
- [Projects](Projects/README.md) — explore programming and automation projects.
- [Python CI/CD demo](Projects/python-github-actions-cicd/README.md) — Python health-check service, unit tests, Docker, and GitHub Actions.

## Technical areas

| Area | Topics represented in this repository |
|---|---|
| **Linux administration** | Bash, filesystem navigation, users and groups, processes, services, logs, package management, SSH, and backup operations |
| **AWS compute and storage** | EC2, S3, EBS, Lambda, and static website hosting exercises |
| **Networking** | VPCs, subnets, IP addressing, web-server connectivity, and network troubleshooting |
| **Databases** | Relational database operations, Amazon Aurora, DynamoDB, and application-to-database exercises |
| **Management and governance** | CloudTrail and CloudFormation troubleshooting |
| **Programming and automation** | Python fundamentals, unit testing, Docker, GitHub Actions, and container registry publishing workflow configuration |

See [Labs/README.md](Labs/README.md) for the available subject folders and individual lab notes.

## Featured project

### Python CI/CD demo

A small Python HTTP health-check application used to demonstrate an automated delivery workflow.

- Unit tests run with Python's unittest framework.
- Docker packages the application into a container image.
- GitHub Actions runs tests and builds the image.
- The workflow is configured to publish to GitHub Container Registry on pushes to the main branch, after tests pass. Pull requests build the image without publishing it.

[Read the project guide](Projects/python-github-actions-cicd/README.md).

## Repository layout

- .github/workflows/ — repository-level GitHub Actions workflows
- Labs/ — guided AWS and Linux lab notes, organized by subject
- Projects/ — Python exercises and the Python CI/CD demo
- Python-Exercises/ — existing Python practice material retained at the repository root
- README.md — portfolio overview and navigation

The two Python exercise folders are retained as they currently exist; no learning files have been removed as part of this documentation update.

## Skills I am developing

- Linux command-line operations and Bash scripting
- AWS compute, storage, networking, and database fundamentals
- VPC and subnet design concepts
- Cloud troubleshooting and operational documentation
- Python fundamentals and unit testing
- Docker fundamentals and GitHub Actions CI/CD

## How to explore this portfolio

1. Start with the [lab index](Labs/README.md) and open a subject area.
2. Review each lab's objective, implementation notes, screenshots, and troubleshooting record where available.
3. Explore the [projects index](Projects/README.md) for work that applies the concepts.
4. For the CI/CD project, follow its README to run the tests and application locally.

## Roadmap

- Build more independent AWS projects using Infrastructure as Code.
- Expand Linux and Bash automation with practical operational scripts.
- Develop AWS monitoring and alerting examples.
- Improve automated testing and deployment workflows.
- Continue documenting architecture decisions, validation steps, and troubleshooting outcomes.

---

This repository is updated as I continue building and documenting practical cloud engineering skills.
