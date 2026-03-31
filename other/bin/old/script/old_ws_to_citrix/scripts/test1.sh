#!/bin/bash

# 功能性腳本：檢查多日多個備份日誌狀態

LOG_DIR="/var/log/backup_log"
CHECK_DAYS=1  # 默認檢查最近幾天
STATUS_MSG="Backup Finish!!"  # 備份完成的標誌信息

# 需要檢查的日誌文件模板
LOG_FILES=(
    "${LOG_DIR}/$(date +%Y-%m-%d)_backup_user_home.log"
    "${LOG_DIR}/$(date +%Y-%m-%d)_HD6501_backup_other_to_snas3.log"
    "${LOG_DIR}/$(date +%Y-%m-%d)_HD6501_backup_old_data_to_snas.log"
    "${LOG_DIR}/$(date +%Y-%m-%d)_HD6501_backup_old_data_to_snas3.log"
)

# 打印使用幫助信息
usage() {
    echo "Usage: $0 [-d DAYS] [-h]"
    echo "  -d DAYS   Check backup status for the last N days (default: 1 day)"
    echo "  -h        Show this help message"
    exit 0
}

# 檢查單個日誌文件的備份狀態
check_single_log() {
    local log_file=$1
    if [[ -f "$log_file" ]]; then
        local last_line
        last_line=$(tail -n 1 "$log_file")
        if [[ "$last_line" == "$STATUS_MSG" ]]; then
            echo -e "\e[32m$(basename "$log_file"): Backup Finished Successfully.\e[0m"
        else
            echo -e "\e[31m$(basename "$log_file"): Backup Incomplete or Error: $last_line\e[0m"
        fi
    else
        echo -e "\e[33m$(basename "$log_file"): Log file not found.\e[0m"
    fi
}

# 檢查單日的所有日誌文件
check_logs_for_date() {
    local date=$1
    for log_file_template in "${LOG_FILES[@]}"; do
        local log_file
        log_file=$(echo "$log_file_template" | sed "s/$(date +%Y-%m-%d)/$date/")
        check_single_log "$log_file"
    done
}

# 解析參數
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

# 主流程：檢查最近 N 天的所有日誌文件
echo -e "\e[34mChecking backup status for the last $CHECK_DAYS day(s)...\e[0m"
for ((i=0; i<CHECK_DAYS; i++)); do
    date_to_check=$(date -d "$i days ago" +%Y-%m-%d)
    echo -e "\e[34mChecking logs for date: $date_to_check\e[0m"
    check_logs_for_date "$date_to_check"
done

echo -e "\e[34mBackup status check complete.\e[0m"

