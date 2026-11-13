# Linux Server Health Monitor

A lightweight Bash utility that performs read-only health checks on a Linux host. It reports system load, memory use, filesystem capacity, and optional systemd service status.

## Why this project?

Cloud and DevOps operations involve checking host health before diagnosing application incidents. This project demonstrates shell scripting, Linux observability fundamentals, exit codes, configurable thresholds, and safe operational behaviour.

## Checks performed

| Check | Source | Behaviour |
|---|---|---|
| System load | `/proc/loadavg` and `nproc` | Compares 1-minute load average against CPU count multiplied by a configurable ratio |
| Memory | `/proc/meminfo` | Calculates used memory from MemTotal and MemAvailable |
| Disk | `df -P` | Checks usage for the selected path (defaults to `/`) |
| Services | `systemctl` | Optionally checks whether named services are active |

The script is read-only. It does not restart services, modify configuration, install packages, or send data to an external endpoint.

## Requirements

- Linux host with Bash.
- Standard Linux utilities: `awk`, `df`, `date`, and `hostname`.
- `/proc` for load and memory checks.
- `nproc` for the load-per-core comparison.
- `systemctl` only when optional service checks are enabled.

macOS uses a different process and memory reporting interface, so this Linux-focused script is intended to run on an EC2 Linux instance, Linux VM, or Linux workstation.

## Run it

From this directory:

```bash
chmod +x health-check.sh
./health-check.sh
```

Check a different mounted filesystem:

```bash
./health-check.sh /var
```

Enable optional service checks:

```bash
SERVICES="sshd cron" ./health-check.sh
```

Service names differ between distributions. For example, some systems use `ssh` instead of `sshd`.

## Configure thresholds

The defaults are intentionally conservative examples, not universal production thresholds.

```bash
DISK_WARN_PERCENT=75 \
MEMORY_WARN_PERCENT=80 \
LOAD_WARN_PER_CORE=1.5 \
SERVICES="sshd" \
./health-check.sh /
```

- `DISK_WARN_PERCENT`: warn when filesystem use reaches this percentage.
- `MEMORY_WARN_PERCENT`: warn when calculated memory use reaches this percentage.
- `LOAD_WARN_PER_CORE`: warning ratio multiplied by the number of CPU cores.
- `SERVICES`: optional whitespace-separated systemd service names.

## Exit codes

| Exit code | Meaning |
|---|---|
| `0` | All configured checks passed |
| `1` | One or more checks produced a warning |
| `2` | A required command is missing |

This makes the script suitable for later integration into cron, a systemd timer, or a monitoring agent.

## Validate the script

```bash
bash -n health-check.sh
```

Run it on a disposable Linux VM or EC2 lab instance and capture example output. Do not claim it has been tested on a distribution until you have run it there.

## Future enhancements

- Structured JSON output for monitoring integrations.
- Log rotation and a configurable log destination.
- A systemd timer unit for scheduled checks.
- Optional CloudWatch Agent integration.
- Automated shell linting with ShellCheck.
