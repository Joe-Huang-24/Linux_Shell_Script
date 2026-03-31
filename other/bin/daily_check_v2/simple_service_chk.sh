#!/bin/bash

set -uo pipefail

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

readonly BASE_DIR="/mis_daily_check"
readonly FUNCTION_DIR="${BASE_DIR}/function"
readonly LOG_DIR="${BASE_DIR}/log"
readonly IPLIST_FILE="${FUNCTION_DIR}/iplist.txt"
readonly SERVICES_FILE="${FUNCTION_DIR}/services.txt"
readonly HOSTNAME_LC="$(hostname | tr '[:upper:]' '[:lower:]')"
readonly LOG_FILE="${LOG_DIR}/$(hostname)_$(date +%F-%H%M%S)_Daily_Check.log"

readonly C_RESET='\e[0m'
readonly C_RED='\e[1;31m'
readonly C_GREEN='\e[1;32m'
readonly C_YELLOW='\e[1;33m'
readonly C_PURPLE='\e[1;35m'
readonly C_CYAN='\e[1;36m'

msg()   { printf '%b\n' "$*"; }
info()  { msg "${C_CYAN}$*${C_RESET}"; }
title() { msg "${C_PURPLE}$*${C_RESET}"; }
ok()    { msg "${C_GREEN}$*${C_RESET}"; }
warn()  { msg "${C_YELLOW}$*${C_RESET}"; }
err()   { msg "${C_RED}$*${C_RESET}"; }

is_systemd() {
    command -v systemctl >/dev/null 2>&1 && [[ -d /run/systemd/system ]]
}

check_service_status() {
#	local services=`cat $SERVICES_FILE`
	local services="$1"
#	for s in ${services[@]}; do
	if is_systemd; then
		systemctl is-active "$s" >> /dev/null 2>&1
	else
		service "$s" status >> /dev/null 2>&1
	fi
#	done
}

service_check() {
	local services=`cat $SERVICES_FILE`
	for s in ${services[@]}; do
		if check_service_status $s; then
			ok "Service $s is active"
		else
			err "Service $s is Dead"
		fi
	done
}

service_check
