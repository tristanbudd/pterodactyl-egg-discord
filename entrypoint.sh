#!/bin/bash

timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

log() {
    echo "$(timestamp) $*"
}

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

# Execute the startup command string directly
set -x  # For debugging

bash -c "$STARTUP"
