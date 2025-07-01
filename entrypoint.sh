#!/bin/bash

timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

log() {
    echo "$(timestamp) $*"
}

# Fix: set HOME and cache path explicitly
export HOME=/home/container
export XDG_CACHE_HOME="$HOME/.cache"
mkdir -p "$XDG_CACHE_HOME/node/corepack/v1"

export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
log "Info | Enabling Corepack..."
corepack enable

log "Info | Changing directory to /home/container"
cd /home/container || { log "Error | Failed to change directory to /home/container"; exit 1; }

# Git update step here if needed...

log "Info | Setting Yarn linker to node-modules"
yarn config set nodeLinker node-modules

log "Info | Installing dependencies with Yarn..."
yarn install || { log "Error | Yarn install failed"; exit 1; }

log "Info | Server startup sequence initiated. Waiting for ${STARTUP_FILE}..."

set -x  # For debugging

bash -c "$STARTUP"
