#!/bin/bash

# Formatting functions for timestamps and logging.
timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

log() {
    echo "$(timestamp) $*"
}

# Replace '{{' with '${' and '}}' with '}' in STARTUP to allow variable expansion.
TEMP_STARTUP="${STARTUP//\{\{/\$\{}"
TEMP_STARTUP="${TEMP_STARTUP//\}\}/\}}"

# Evaluate variable interpolation into MODIFIED_STARTUP
eval "MODIFIED_STARTUP=\"$TEMP_STARTUP\""

# Disable Corepack download prompts and enable Corepack.
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
log "Info | Enabling Corepack..."
corepack enable

# Navigate to the working directory.
log "Info | Changing directory to /home/container"
cd /home/container || { log "Error | Failed to change directory to /home/container"; exit 1; }

# Set yarn to use node_modules linker.
log "Info | Setting Yarn linker to node-modules"
yarn config set nodeLinker node-modules

# Install project dependencies.
log "Info | Installing dependencies with Yarn..."
yarn install

log "Info | Server startup sequence initiated. Waiting for ${STARTUP_FILE}..."

# Start the server using the processed startup command.
exec bash -c "$MODIFIED_STARTUP"
