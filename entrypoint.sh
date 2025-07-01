#!/bin/bash

timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

log() {
    echo "$(timestamp) $*"
}

# Replace {{VAR}} with ${VAR} so environment variables get expanded by bash -c
MODIFIED_STARTUP=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')

export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
log "Info | Enabling Corepack..."
corepack enable

log "Info | Changing directory to /home/container"
cd /home/container || { log "Error | Failed to change directory to /home/container"; exit 1; }

log "Info | Setting Yarn linker to node-modules"
yarn config set nodeLinker node-modules

log "Info | Installing dependencies with Yarn..."
yarn install

log "Info | Server startup sequence initiated. Waiting for ${STARTUP_FILE}..."

# Directly execute the startup command in bash -c (no echo, no eval echo)
exec bash -c "$MODIFIED_STARTUP"