#!/bin/bash

LOGFILE="/var/log/xdl/citrix_service_restart.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

check_status() {
    SERVICE=$1
    if systemctl is-active --quiet $SERVICE; then
        log "$SERVICE is running."
    else
        log "ERROR: $SERVICE is NOT running."
    fi
}

log "===== Citrix Service Restart Script Started ====="

log "Restarting ctxjproxy..."
systemctl restart ctxjproxy
sleep 5
check_status ctxjproxy

log "Stopping ctxvda..."
systemctl stop ctxvda
sleep 5
check_status ctxvda

log "Restarting ctxhdx..."
systemctl restart ctxhdx
sleep 5
check_status ctxhdx

log "Starting ctxvda..."
systemctl start ctxvda
sleep 5
check_status ctxvda

log "===== Script Finished ====="

