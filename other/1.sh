#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/env"

source "${ENV_DIR}/1.env"


loop_n=1
n=0
total_n=20

while (( $loop_n > 0 )); do
	clear 2>/dev/null || true
	n=$((n+1))
	msg_yellow "=== Server Monitor at $(date +%Y%m%d)  ==="
	msg_green "=== This Round ${n}/${total_n}  ==="
	log "Starting Monitor Server Process"
	log "Hostname       : $(hostname)"	
	log "IP Address     : $(get_ip_address)"
	log "Domain name    : $(domainname)"
	log "YP Server      : $(ypwhich)"
	log "Memory         : $(get_memory_total)"
	log
	sleep ${INTERVAL}
	log "++++++ Checking Service ++++++"
	check_service
	sleep 5
	log
	show_top_cpu_processes
	sleep 5 
	log "++++++ Check END at $(date +%Y%m%d-%T) ++++++"
	log "Next Round After ${INTERVAL} seconds ..."
	sleep ${INTERVAL}
	log
	if (( n >= 20 )); then
		exit 0
	fi
done
