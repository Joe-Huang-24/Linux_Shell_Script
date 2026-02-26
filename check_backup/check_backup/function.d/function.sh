#!/usr/bin/env bash
# Purpose: Run /mis_daily_check/show_userlist across hosts via Ansible
# Notes  : - Comments are in English per your preference
#          - Static config lives in ansible.env; CLI args override HOSTS

set -euo pipefail

# ------------------------------
# Helpers
# ------------------------------
die() { echo "[ERROR] $*" >&2; exit 1; }
require_root() { [ "${EUID:-$(id -u)}" -eq 0 ] || die "Run as root."; }
need_cmd() { for c in "$@"; do command -v "$c" >/dev/null 2>&1 || die "Missing command: $c"; done; }

usage() {
  cat <<'EOF'
Usage:
  ans_sh_user.sh [-a] [-H <pattern>] [-h] [pattern]

Examples:
  ans_sh_user.sh                 # use env hosts or 'all'
  ans_sh_user.sh -a              # same as above
  ans_sh_user.sh -H webservers   # explicit pattern
  ans_sh_user.sh 'hpc:&prod'     # positional pattern
  ans_sh_user.sh 'host1,host2'   # positional list
EOF
}

TARGETS=""
use_default=false

while getopts ":aH:h" opt; do
        case $opt in
                a)
                        use_default=true
                        ;;
                H)
                        TARGETS="$OPTARG"
                        ;;
                h)
                        usage
                        exit 0
                        ;;
                :)
                        die "Option -$OPTARG requires an argument."
                        ;;
                \?)
                        die "Unknown option: -$OPTARG (try -h)"
                        ;;
        esac
done
shift $((OPTIND - 1))

