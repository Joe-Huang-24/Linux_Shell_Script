#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd -- "${SCRIPT_DIR}/../lib" && pwd)"

WORKER_A9812="${LIB_DIR}/srd-user-a9812-create"

DEFAULT_COUNT="1"

log()  { printf '%s - %s\n' "$(date '+%F %T')" "$*"; }
err()  { printf '%s - ERROR: %s\n' "$(date '+%F %T')" "$*" >&2; }
die()  { err "$*"; exit 1; }

usage() {
  cat <<'EOF'
Usage:
  srd-user --team A9812 [--count N] [--server HOST --disk NUM] [--dry-run]
  srd-user --team DPU   [--count N] ...

Options:
  --team,  -t   Team name: A9812 | DPU
  --count, -c   Number of users to create (default: 1)
  --server,-s   Home server hostname (for non-interactive mode)
  --disk,  -d   Disk number (e.g. 6501/6502/6651/6652) (for non-interactive mode)
  --dry-run     Print what would be done (no changes)
  --help,  -h   Show this help

Examples:
  srd-user -t A9812
  srd-user -t A9812 -c 3
  srd-user -t A9812 -c 2 -s SRV01 -d 6501
  srd-user -t A9812 -s SRV01 -d 6501 --dry-run
EOF
}

TEAM=""
COUNT="${DEFAULT_COUNT}"
SERVER=""
DISK=""
DRY_RUN="0"

# Simple arg parser (production-friendly, explicit errors)
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--team)   TEAM="${2:-}"; shift 2 ;;
    -c|--count)  COUNT="${2:-}"; shift 2 ;;
    -s|--server) SERVER="${2:-}"; shift 2 ;;
    -d|--disk)   DISK="${2:-}"; shift 2 ;;
    --dry-run)   DRY_RUN="1"; shift ;;
    -h|--help)   usage; exit 0 ;;
    *)
      die "Unknown argument: $1. Use --help."
      ;;
  esac
done

[[ -n "${TEAM}" ]] || die "Missing --team. Use --help."
[[ "${COUNT}" =~ ^[0-9]+$ ]] || die "--count must be a positive integer."
[[ "${COUNT}" -ge 1 ]] || die "--count must be >= 1."

log "You wish create ${COUNT} User(s)"
log "Team: ${TEAM}"

case "${TEAM,,}" in
  a9812)
    [[ -x "${WORKER_A9812}" ]] || die "Worker not found or not executable: ${WORKER_A9812}"

    # If server+disk provided -> non-interactive mode
    args=( "--count" "${COUNT}" )
    if [[ -n "${SERVER}" || -n "${DISK}" ]]; then
      [[ -n "${SERVER}" && -n "${DISK}" ]] || die "For non-interactive mode, both --server and --disk are required."
      args+=( "--server" "${SERVER}" "--disk" "${DISK}" )
    fi
    [[ "${DRY_RUN}" == "1" ]] && args+=( "--dry-run" )

    log "Dispatch to worker: ${WORKER_A9812} ${args[*]}"
    exec "${WORKER_A9812}" "${args[@]}"
    ;;
  dpu)
    die "DPU workflow not implemented yet. Add a worker like lib/srd-user-dpu-create."
    ;;
  *)
    die "Invalid team: ${TEAM}. Allowed: A9812 | DPU"
    ;;
esac