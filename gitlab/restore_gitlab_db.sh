#!/bin/bash

file_name=$1
BACKUP_NAME=${file_name%_gitlab_backup.tar}

log_red() {
    echo -e "\033[31m$(date '+%Y-%m-%d %H:%M:%S') - \033[0m$1"
}

log_yellow() {
    echo -e "\033[33m$(date '+%Y-%m-%d %H:%M:%S') - \033[0m$1"
}

log_green() {
    echo -e "\033[32m$(date '+%Y-%m-%d %H:%M:%S') - $1\033[0m"
}

usage() {
    echo "Usage: $0 <backup_name_without_extension>"
    exit 1
}

restore_db () {
	    log_yellow "Starting Restore db $1..."
	    gitlab-rake gitlab:backup:restore BACKUP=$BACKUP_NAME force=yes

	    if [ $? -eq 0 ]; then
		    log_green "Restore completed successfully"
            else
		    log_red "Restore failed"
		    exit 1
	    fi

	    log_yellow "Reconfiguring GitLab..."
	    gitlab-ctl reconfigure

	    log_yellow "Restarting GitLab services..."
	    gitlab-ctl restart
}

# --------------------------
# Main logic
# --------------------------

if [ -z "$BACKUP_NAME" ]; then
    log_red "No backup name provided"
    usage
fi

#log_green "$BACKUP_NAME"

if [ -f $file_name ]; then
	log_yellow "$file_name exists"
	restore_db
else
	log_red "$file_name dose not exists"
	exit 1
fi
