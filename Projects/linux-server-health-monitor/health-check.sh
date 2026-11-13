#!/usr/bin/env bash
#
# Lightweight, read-only Linux host health check.
# Usage: ./health-check.sh [filesystem-path]
#
# Optional environment variables:
#   DISK_WARN_PERCENT=80
#   MEMORY_WARN_PERCENT=85
#   LOAD_WARN_PER_CORE=1.0
#   SERVICES="sshd cron"
#
# The script reports findings; it does not restart services or change the host.

set -uo pipefail

DISK_WARN_PERCENT="${DISK_WARN_PERCENT:-80}"
MEMORY_WARN_PERCENT="${MEMORY_WARN_PERCENT:-85}"
LOAD_WARN_PER_CORE="${LOAD_WARN_PER_CORE:-1.0}"
CHECK_PATH="${1:-/}"
SERVICES="${SERVICES:-}"

if ! [[ "$DISK_WARN_PERCENT" =~ ^[0-9]+$ ]] || [ "$DISK_WARN_PERCENT" -lt 1 ] || [ "$DISK_WARN_PERCENT" -gt 100 ]; then
  printf 'ERROR: DISK_WARN_PERCENT must be an integer from 1 to 100.\n' >&2
  exit 2
fi
if ! [[ "$MEMORY_WARN_PERCENT" =~ ^[0-9]+$ ]] || [ "$MEMORY_WARN_PERCENT" -lt 1 ] || [ "$MEMORY_WARN_PERCENT" -gt 100 ]; then
  printf 'ERROR: MEMORY_WARN_PERCENT must be an integer from 1 to 100.\n' >&2
  exit 2
fi
if ! [[ "$LOAD_WARN_PER_CORE" =~ ^[0-9]+([.][0-9]+)?$ ]] || ! awk -v value="$LOAD_WARN_PER_CORE" 'BEGIN { exit !(value > 0) }'; then
  printf 'ERROR: LOAD_WARN_PER_CORE must be a positive number.\n' >&2
  exit 2
fi

WARNINGS=0
HOSTNAME_VALUE="$(hostname 2>/dev/null || printf 'unknown')"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S %Z')"

log() {
  printf '[%s] %-7s %s\n' "$TIMESTAMP" "$1" "$2"
}

warn() {
  WARNINGS=$((WARNINGS + 1))
  log "WARNING" "$1"
}

command -v awk >/dev/null 2>&1 || {
  printf 'ERROR: awk is required.\n' >&2
  exit 2
}
command -v df >/dev/null 2>&1 || {
  printf 'ERROR: df is required.\n' >&2
  exit 2
}

log "INFO" "Starting read-only health check for $HOSTNAME_VALUE"
log "INFO" "Filesystem path: $CHECK_PATH"

# Load average relative to the number of available CPU cores.
if [ -r /proc/loadavg ] && command -v nproc >/dev/null 2>&1; then
  LOAD_1="$(awk '{print $1}' /proc/loadavg)"
  CPU_COUNT="$(nproc)"
  LOAD_LIMIT="$(awk -v cores="$CPU_COUNT" -v ratio="$LOAD_WARN_PER_CORE" 'BEGIN { printf "%.2f", cores * ratio }')"
  log "INFO" "1-minute load average: $LOAD_1 (warning threshold: $LOAD_LIMIT; CPUs: $CPU_COUNT)"
  if awk -v load="$LOAD_1" -v limit="$LOAD_LIMIT" 'BEGIN { exit !(load > limit) }'; then
    warn "System load is above the configured per-core threshold."
  fi
else
  log "SKIP" "Load average check requires /proc/loadavg and nproc (Linux)."
fi

# Memory usage from /proc/meminfo, avoiding a dependency on the free command.
if [ -r /proc/meminfo ]; then
  MEMORY_USED_PERCENT="$(awk '
    /^MemTotal:/ { total=$2 }
    /^MemAvailable:/ { available=$2 }
    END {
      if (total > 0) printf "%.0f", ((total - available) / total) * 100
      else print "0"
    }' /proc/meminfo)"
  log "INFO" "Memory used: ${MEMORY_USED_PERCENT}% (warning threshold: ${MEMORY_WARN_PERCENT}%)"
  if [ "$MEMORY_USED_PERCENT" -ge "$MEMORY_WARN_PERCENT" ]; then
    warn "Memory usage reached or exceeded the configured threshold."
  fi
else
  log "SKIP" "Memory check requires /proc/meminfo (Linux)."
fi

# Root or caller-selected filesystem capacity.
DISK_USED_PERCENT="$(df -P "$CHECK_PATH" 2>/dev/null | awk 'NR==2 { gsub(/%/, "", $5); print $5 }')"
if [[ "$DISK_USED_PERCENT" =~ ^[0-9]+$ ]]; then
  log "INFO" "Disk usage for $CHECK_PATH: ${DISK_USED_PERCENT}% (warning threshold: ${DISK_WARN_PERCENT}%)"
  if [ "$DISK_USED_PERCENT" -ge "$DISK_WARN_PERCENT" ]; then
    warn "Filesystem usage reached or exceeded the configured threshold."
  fi
else
  warn "Could not read disk usage for path: $CHECK_PATH"
fi

# Optional service checks. No service is restarted or modified.
if [ -n "$SERVICES" ]; then
  if command -v systemctl >/dev/null 2>&1; then
    for service in $SERVICES; do
      if systemctl is-active --quiet "$service"; then
        log "OK" "Service is active: $service"
      else
        warn "Service is not active: $service"
      fi
    done
  else
    log "SKIP" "SERVICES was set, but systemctl is not available."
  fi
else
  log "INFO" "No service checks requested. Set SERVICES='sshd cron' to enable them."
fi

if [ "$WARNINGS" -gt 0 ]; then
  log "SUMMARY" "Completed with $WARNINGS warning(s). Review the findings above."
  exit 1
fi

log "SUMMARY" "All configured checks passed."
exit 0
