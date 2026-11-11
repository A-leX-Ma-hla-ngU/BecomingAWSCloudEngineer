# Internet Protocol Troubleshooting Commands

## Lab overview

In this lab, I practiced common network troubleshooting commands and considered how they applied to customer scenarios. I used commands for network-layer reachability, transport-layer connections, and application-layer HTTP requests.

**Approximate duration:** 30 minutes

## Objectives completed

- I practiced network troubleshooting commands.
- I identified how the commands could help investigate customer issues.

## Scenario

I acted as a new network administrator who investigated customer connectivity issues. I followed a layered troubleshooting approach, starting with basic IP reachability and then checking transport and application behavior.

> **Screenshot placeholder — Troubleshooting layers:** <img width="716" height="541" alt="Screenshot 2026-08-06 at 17 09 19" src="https://github.com/user-attachments/assets/7ac1e0d0-e60a-44ef-8d02-73ce2ae95eba" />

## Task 1: Connected to the EC2 instance

I downloaded the lab-provided PEM key and noted the instance's public IPv4 address. On macOS or Linux, I changed to the directory containing the key and made it read-only:

```bash
cd ~/Downloads
chmod 400 labsuser.pem
```

I connected to the EC2 instance using its public IPv4 address:

```bash
ssh -i labsuser.pem ec2-user@<public-ip>
```

When prompted, I confirmed the first connection. Key-pair authentication did not require a password. I kept the private key secure and did not include it in screenshots.

> **Screenshot placeholder — SSH connection:**
<img width="828" height="252" alt="Screenshot 2026-08-06 at 17 08 33" src="https://github.com/user-attachments/assets/e3a0770f-442a-448c-92eb-da49126c453b" />

## Task 2: Practiced troubleshooting commands

### Layer 3 — Network: `ping` and `traceroute`

#### Tested reachability with `ping`

I sent five ICMP echo requests to `8.8.8.8`:

```bash
ping 8.8.8.8 -c 5
```

The replies and summary helped me check IP reachability and round-trip time. A failed ping did not, by itself, prove that the target or route was unavailable: ICMP could also have been blocked by a host firewall, security group, network ACL, or destination policy.

> **Screenshot placeholder — Ping output:**
<img width="712" height="242" alt="Screenshot 2026-08-06 at 17 17 00" src="https://github.com/user-attachments/assets/f99e5806-61db-414b-a97a-5f184b71e0e1" />

#### Inspected the path with `traceroute`

I examined the network path and hop timings to `8.8.8.8`:

```bash
traceroute 8.8.8.8
```

Each hop represented a router along the path. A hop displayed as `* * *` indicated that no response was received within the probe timeout; it did not necessarily mean that the hop or route was broken, since routers often filtered or deprioritized traceroute probes. I used the output as a diagnostic clue and considered the end-to-end symptoms and other evidence before attributing packet loss to AWS, a local network, or an ISP.

> **Screenshot placeholder — Traceroute output:**
<img width="892" height="285" alt="Screenshot 2026-08-06 at 17 19 18" src="https://github.com/user-attachments/assets/8fb7c8d3-55c5-4517-b4dc-79228ea21315" />

### Layer 4 — Transport: `netstat` and `telnet`

#### Reviewed TCP connections and listening ports with `netstat`

I reviewed established TCP connections:

```bash
netstat -tp
```

I also used these variants to inspect listening services:

```bash
netstat -tlp
netstat -ntlp
```

`-tp` showed TCP connections and associated processes where permissions allowed. `-tlp` listed listening TCP sockets and processes, while `-ntlp` avoided resolving addresses and port numbers. These commands provided a host-level snapshot; they did not replace checks of security groups, network ACLs, routes, or remote reachability.

> **Screenshot placeholder — Netstat output:**
<img width="889" height="141" alt="Screenshot 2026-08-06 at 17 23 03" src="https://github.com/user-attachments/assets/22bce9a2-8d86-4cdc-be7d-5840e370647c" />
<img width="734" height="290" alt="Screenshot 2026-11-11 at 20 18 41" src="https://github.com/user-attachments/assets/f0c6eeab-8836-4ff3-8e16-1748ddb3b8ca" />


#### Tested a TCP port with `telnet`

I installed the Telnet client if it was not already available:

```bash
sudo yum install telnet -y
```

I tested a TCP connection to port 80 on a web server:

```bash
telnet www.google.com 80
```

A successful connection indicated that a TCP handshake to the destination and port had completed. A **connection refused** result indicated that the destination or an intermediary actively rejected the connection. A **connection timed out** result could indicate filtering, routing, or reachability problems. Telnet tested TCP connectivity only; it did not verify that an HTTP application request succeeded. I exited the session after the test.

> **Screenshot placeholder — Telnet connection test:**
<img width="897" height="687" alt="Screenshot 2026-08-06 at 17 23 37" src="https://github.com/user-attachments/assets/43870bff-f40f-45a7-9e10-d444a4810512" />

<img width="587" height="81" alt="Screenshot 2026-11-11 at 20 14 15" src="https://github.com/user-attachments/assets/94ce664f-1180-46fa-9181-505cd724fecb" />


### Layer 7 — Application: `curl`

I made a verbose HTTPS request and discarded the response body:

```bash
curl -vLo /dev/null https://aws.com
```

I used `curl` to inspect connection and HTTP behavior. Common options included `-I` for a HEAD request, `-i` for including response headers in a GET response, `-k` for bypassing certificate verification, `-v` for verbose diagnostics, and `-o /dev/null` for discarding the response body. I used `-k` only as a temporary diagnostic because it disabled certificate validation.

A successful HTTP response, such as `200 OK`, indicated that the server returned a successful status for that request. I interpreted the status in context because redirects, authentication, and application behavior could also affect the response.

> **Screenshot placeholder — Curl output:**
<img width="469" height="26" alt="Screenshot 2026-08-06 at 17 24 29" src="https://github.com/user-attachments/assets/91089d11-aac4-4c33-a8d2-ee2257d5d413" />
<img width="1680" height="1050" alt="Screenshot 2026-08-06 at 17 29 42" src="https://github.com/user-attachments/assets/8c9f74f0-ebde-4a13-8705-4b80df801529" />
<img width="1680" height="1050" alt="Screenshot 2026-08-06 at 17 29 46" src="https://github.com/user-attachments/assets/199bc70c-1b0d-45b8-87e9-18227f9da26a" />


## Findings and lab completion

I completed the lab by using `ping` and `traceroute` to investigate IP reachability and paths, `netstat` to inspect local TCP sockets, `telnet` to test a remote TCP port, and `curl` to inspect an application-level HTTP response. I used each result as one part of a layered investigation rather than treating an individual command as definitive proof of a root cause.

> **Cleanup reminder:** After completing the activity, I disconnected from the EC2 instance and ended the lab as instructed. I kept the private key and any sensitive connection details secure.
