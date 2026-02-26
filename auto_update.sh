#!/bin/bash

log () {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Session-1: add file"
git add .
log "Session-2: Commit"
git commit -m "$1"
log "Session-3: Push to Origin Reopsitry"
git push origin main
