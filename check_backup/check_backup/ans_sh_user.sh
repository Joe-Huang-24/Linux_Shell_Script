#!/usr/bin/env bash
# Purpose: Run /mis_daily_check/show_userlist across hosts via Ansible
# Notes  : - Comments are in English per your preference
#          - Static config lives in ansible.env; CLI args override HOSTS

set -euo pipefail

# ------------------------------
# Locate & source env
# ------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${ENV_FILE:-${SCRIPT_DIR}/env.d/ansible.env}"
FUNC_FILE="${FUNC_FILE:-${SCRIPT_DIR}/function.d/function.sh}"

# Load env if present; it's OK if missing (we'll fallback)
if [[ -f "$ENV_FILE" && -f "$FUNC_FILE" ]]; then
  # shellcheck source=/dev/null
	source "$ENV_FILE"
	source "$FUNC_FILE" 
fi

# ------------------------------
# Sanity & tools
# ------------------------------
require_root
need_cmd ansible

# Required/optional env
INV="${inv:-${INV:-/etc/ansible/hosts}}"  # allow 'inv' or 'INV'; default /etc/ansible/hosts
HOSTS_DEFAULT="${hosts:-${HOSTS:-}}"      # allow 'hosts' or 'HOSTS'
ABC="${abc:-${ABC:-}}"                    # optional, not used by the script but kept for compatibility

[[ -r "$INV" ]] || die "Inventory not readable: $INV"

# ------------------------------
# Execute
# ------------------------------

if [[ -z "${TARGETS}" && $# -gt 0 ]]; then
	TARGETS="$1"
fi

if $use_default || [[ -z "${TARGETS}" ]]; then
	TARGETS="${HOSTS_DEFAULT:-all}"
fi

echo "[INFO] Using inventory: $INV"
echo "[INFO] Target pattern : $TARGETS"

ansible "$TARGETS" -i "$INV" -m shell -a '/mis_daily_check/show_userlist'
