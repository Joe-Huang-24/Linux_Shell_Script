#!/bin/bash

#set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/env"

source "${ENV_DIR}/sh_info.env"

main() {
    local round

    for ((round=1; round<=TOTAL_ROUNDS; round++)); do
        clear 2>/dev/null || true
        log "=== Server Monitor Round ${round}/${TOTAL_ROUNDS} at $(date '+%Y-%m-%d %H:%M:%S') ==="

        section "Basic Information"
        show_system_info

        section "Service Status"
        show_services_status

        section "Disk Usage Warning"
        show_disk_warnings

        show_top_cpu_processes
        show_top_mem_processes

        if [ "$round" -lt "$TOTAL_ROUNDS" ]; then
            log
            log "Next round after ${INTERVAL} seconds ..."
            sleep "$INTERVAL"
        fi
    done
}

main "$@"
