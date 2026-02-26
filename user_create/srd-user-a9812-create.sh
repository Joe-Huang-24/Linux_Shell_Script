#!/usr/bin/env bash
set -Eeuo pipefail

A9812FIX="A9812-"
AUTOHOMEFILE="/etc/auto.home"
DEFAULT_COUNT="1"

# Defaults (match your original logic)
PRIMARY_GID="1100"
LOGIN_SHELL="/bin/csh"
EXTRA_GROUP="rdc-srd"
OWN_GROUP="A9812"   # used for chown user:group on remote home folder

COUNT="${DEFAULT_COUNT}"
SERVER=""
DISK=""
DRY_RUN="0"

usage() {
  cat <<'EOF'
Usage:
  srd-user-a9812-create [--count N] [--server HOST --disk NUM] [--dry-run]

Options:
  --count     Number of users to create (default: 1)
  --server    Home server hostname (non-interactive)
  --disk      Disk number (non-interactive)
  --dry-run   Print actions only, do not modify system
  --help      Show this help

Notes:
  If --server/--disk not provided, it will prompt interactively.
EOF
}

log()  { printf '%s - %s\n' "$(date '+%F %T')" "$*"; }
warn() { printf '%s - WARN: %s\n' "$(date '+%F %T')" "$*" >&2; }
err()  { printf '%s - ERROR: %s\n' "$(date '+%F %T')" "$*" >&2; }
die()  { err "$*"; exit 1; }

run() {
  # run commands with dry-run support
  if [[ "${DRY_RUN}" == "1" ]]; then
    printf '[DRY-RUN] %q' "$1"
    shift || true
    for a in "$@"; do printf ' %q' "$a"; done
    printf '\n'
  else
    "$@"
  fi
}

need_root() {
  [[ "${EUID}" -eq 0 ]] || die "Must run as root."
}

get_last_id() {
  # Returns numeric last id; if none, returns 0
  local last
  last="$(grep -E "^${A9812FIX}[0-9]+:" /etc/passwd \
    | awk -F':' '{print $1}' \
    | awk -F'-' '{print $2}' \
    | sort -n \
    | tail -n 1 || true)"
  if [[ -z "${last}" ]]; then
    echo "0"
  else
    # ensure base-10
    echo "$((10#${last}))"
  fi
}

ensure_files() {
  [[ -f "${AUTOHOMEFILE}" ]] || die "Missing ${AUTOHOMEFILE}"
  [[ -f "/etc/shadow" ]] || die "Missing /etc/shadow"
}

create_one_user() {
  local last_id next_id nwusr last_user srvname disknum new_line

  last_id="$(get_last_id)"
  next_id="$(( last_id + 1 ))"
  nwusr="${A9812FIX}${next_id}"
  last_user="${A9812FIX}${last_id}"

  echo -e "\033[35mSRD ADD New User Account\033[0m"
  echo "#############"
  log "Next user will be: ${nwusr}"

  if getent passwd "${nwusr}" >/dev/null 2>&1; then
    warn "User account ${nwusr} already exists. Skipping."
    return 0
  fi

  # useradd/usermod
  run useradd -M -g "${PRIMARY_GID}" -s "${LOGIN_SHELL}" "${nwusr}"
  run usermod -aG "${EXTRA_GROUP}" "${nwusr}"
  log "User account ${nwusr} created."

  # /etc/shadow tweak (your original logic)
  if getent passwd "${nwusr}" >/dev/null 2>&1; then
    run sed -i."$(date +%Y-%m-%d-%H%M)" "s|^${nwusr}:!!:|${nwusr}::|g" /etc/shadow
    log "Configure /etc/shadow Success."
  else
    die "User ${nwusr} not found after creation."
  fi

  # Interactive fallback if not provided
  if [[ -z "${SERVER}" ]]; then
    read -r -p "New User home folder machine: " srvname
  else
    srvname="${SERVER}"
  fi

  if [[ -z "${DISK}" ]]; then
    read -r -p "New User home folder machine Disk (ex.6501, 6502, 6651, 6652): " disknum
  else
    disknum="${DISK}"
  fi

  # auto.home insert right after last_user (same as your original)
  new_line="${nwusr}        -acl,vers=3,retry=3,nofail,soft,bg,timeo=600 ${srvname}:/HD${disknum}/home/${nwusr}"
  run sed -i."$(date +%Y-%m-%d-%H%M)" "/${last_user}/a ${new_line}" "${AUTOHOMEFILE}"

  # NIS rebuild + set password
  run make -C /var/yp
  run yppasswd "${nwusr}"

  # Remote home folder creation
  run ssh "${srvname}" "mkdir -p /HD${disknum}/home/${nwusr} && chown ${nwusr}:${OWN_GROUP} /HD${disknum}/home/${nwusr}"

  # Print last A9812 user in NIS passwd map (your original last line)
  run ypcat passwd | grep -i 'A9812' | awk -F ':' '{print $1,$3}' | sort -u | tail -n 1
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --count)  COUNT="${2:-}"; shift 2 ;;
    --server) SERVER="${2:-}"; shift 2 ;;
    --disk)   DISK="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN="1"; shift ;;
    --help) usage; exit 0 ;;
    *) die "Unknown argument: $1. Use --help." ;;
  esac
done

[[ "${COUNT}" =~ ^[0-9]+$ ]] || die "--count must be a positive integer."
[[ "${COUNT}" -ge 1 ]] || die "--count must be >= 1."

# If one of server/disk provided, require both (avoid half-configured runs)
if [[ -n "${SERVER}" || -n "${DISK}" ]]; then
  [[ -n "${SERVER}" && -n "${DISK}" ]] || die "Both --server and --disk are required for non-interactive mode."
fi

need_root
ensure_files

i=1
while [[ "${i}" -le "${COUNT}" ]]; do
  log "Creating user ${i}/${COUNT} ..."
  create_one_user
  i=$(( i + 1 ))
done