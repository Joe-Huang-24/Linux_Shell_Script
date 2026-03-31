#!/bin/bash

set -uo pipefail

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

source /mis_daily_check/tools/bin/daily_check_v2/function/path.env

show_srv_info="${FUNCTION_DIR}/show_srv_information"
simple_service_script="${FUNCTION_DIR}/simple_service_chk"
ping_host_script="${FUNCTION_DIR}/ping_host"
source "$show_srv_info"
source "$simple_service_script"
source "$ping_host_script"

#ls -ld "${show_srv_info}"
#ls -ld "${simple_service_script}"
#ls -ld "${ping_host_script}"

show_srv_main
service_check
#ping_hosts
