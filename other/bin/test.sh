#!/usr/bin/env bash
# List users from mapping file, optionally filter by online status
# Compatible with CentOS 6.10 (no assoc array, no process substitution)

set -e
export LC_ALL=C

# === Config (可放在 .env, 這裡直接示範) ===
#MAPFILE_PATH="/snas/snas_Backup/Citrix_User.txt"
source /mis_daily_check/test.env

# === Usage function ===
usage() {
    echo "Usage: $0 [--online | --all]"
    echo "  --online   Show only accounts that appear in ps aux"
    echo "  --all      Show all accounts in mapping file (default)"
    exit 1
}

# === Parse parameter ===
MODE="all"
case "${1:-}" in
    --online) MODE="online" ;;
    --all|"") MODE="all" ;;
    -h|--help) usage ;;
    *) echo "[ERROR] Unknown option: $1" >&2; usage ;;
esac

# === Check mapping file ===
if [ ! -f "$MAPFILE_PATH" ]; then
    echo "[ERROR] Mapping file not found: $MAPFILE_PATH" >&2
    exit 1
fi

# === Load users/names arrays ===
users=()
names=()
while IFS= read -r line; do
    # Skip blank and comment
    [ -z "$line" ] && continue
    case "$line" in \#*) continue ;; esac

    # Split by first "="
    u="${line%%=*}"
    n="${line#*=}"

    # Trim spaces
    u="${u#"${u%%[![:space:]]*}"}"; u="${u%"${u##*[![:space:]]}"}"
    n="${n#"${n%%[![:space:]]*}"}"; n="${n%"${n##*[![:space:]]}"}"

    [ -z "$u" ] && continue

    # Strip surrounding quotes from name if any
    n="${n%\"}"; n="${n#\"}"

    users+=("$u")
    names+=("$n")
done < "$MAPFILE_PATH"

# Sanity check
if [ "${#users[@]}" -ne "${#names[@]}" ]; then
    echo "[ERROR] users/names length mismatch" >&2
    exit 1
fi

# === If mode=online, build online user list ===
tmp_online=""
if [ "$MODE" = "online" ]; then
    tmp_online="$(mktemp /tmp/online.XXXXXX)"
    ps auxww | awk 'NR>1{print $1}' | sort -u > "$tmp_online"
    trap 'rm -f "$tmp_online"' EXIT
fi

# === Output ===
for i in "${!users[@]}"; do
    if [ "$MODE" = "online" ]; then
        if grep -xFq "${users[$i]}" "$tmp_online"; then
            echo "User Account: ${users[$i]}  User Name: ${names[$i]}"
        fi
    else
        echo "User Account: ${users[$i]}  User Name: ${names[$i]}"
    fi
done

