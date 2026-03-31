#!/bin/bash

LOG_DIR="/var/log/backup_log"
CHECK_DAYS=1  
STATUS_MSG="Backup Finish!!" 

usage() {
    echo "Usage: $0 [-d DAYS] [-h]"
    echo "  -d DAYS   Check backup status for the last N days (default: 1 day)"
    echo "  -h        Show this help message"
    exit 0
}

check_backup_status() {
    local date=$1
    local log_file="$LOG_DIR/${date}_backup_user_home.log"

    if [[ -f "$log_file" ]]; then
        local last_line
        last_line=$(tail -n 1 "$log_file")
        if [[ "$last_line" == "$STATUS_MSG" ]]; then
            echo -e "\e[32m$date: Backup Finished Successfully.\e[0m"
        else
            echo -e "\e[31m$date: Backup Incomplete or Error: $last_line\e[0m"
        fi
    else
        echo -e "\e[33m$date: Log file not found.\e[0m"
    fi
}

while getopts "d:h" opt; do
    case $opt in
        d)
            CHECK_DAYS=$OPTARG
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

echo -e "\e[34mChecking backup status for the last $CHECK_DAYS day(s)...\e[0m"
for ((i=0; i<CHECK_DAYS; i++)); do
    date_to_check=$(date -d "$i days ago" +%Y-%m-%d)
    check_backup_status "$date_to_check"
done

echo -e "\e[34mBackup status check complete.\e[0m"

