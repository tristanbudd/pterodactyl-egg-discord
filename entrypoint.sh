#!/bin/bash

timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

log() {
    echo "$(timestamp) $*"
}

export HOME=/home/container
export XDG_CACHE_HOME="$HOME/.cache"
mkdir -p "$XDG_CACHE_HOME/node/corepack/v1"

log "Info | Changing directory to /home/container"
cd /home/container || { log "Error | Failed to change directory to /home/container"; exit 1; }

if [ "$AUTO_UPDATE" = "1" ]; then
    if [ -z "$(ls -A)" ]; then
        log "Info | Directory empty, cloning repo..."

        if [ -z "$BRANCH" ]; then
            git clone "${USERNAME:+$USERNAME:$ACCESS_TOKEN@}$GIT_ADDRESS" .
        else
            git clone --single-branch --branch "$BRANCH" "${USERNAME:+$USERNAME:$ACCESS_TOKEN@}$GIT_ADDRESS" .
        fi

        if [ $? -ne 0 ]; then
            log "Error | Git clone failed"
            exit 1
        fi
    elif [ -d .git ]; then
        normalize() {
            url=$1
            url=${url%.git}
            echo "$url"
        }

        CURRENT=$(git config --get remote.origin.url || echo "")
        ORIGIN=$(normalize "$CURRENT")
        TARGET=$(normalize "${USERNAME:+$USERNAME:$ACCESS_TOKEN@}$GIT_ADDRESS")

        if [ "$ORIGIN" != "$TARGET" ]; then
            log "Warning | Git origin does not match target: $ORIGIN vs $TARGET"
            log "Info | Forcing update of git origin URL..."
            git remote set-url origin "${USERNAME:+$USERNAME:$ACCESS_TOKEN@}$GIT_ADDRESS"
        fi

        log "Info | Pulling latest changes from git repo..."
        git reset --hard
        git clean -fd
        git pull

        if [ -n "$BRANCH" ]; then
            git checkout "$BRANCH"
        fi
    else
        log "Warning | Directory not a git repo but not empty, deleting contents and cloning fresh..."
        rm -rf ./* .[^.] .??* || { log "Error | Failed to clean directory"; exit 1; }

        if [ -z "$BRANCH" ]; then
            git clone "${USERNAME:+$USERNAME:$ACCESS_TOKEN@}$GIT_ADDRESS" .
        else
            git clone --single-branch --branch "$BRANCH" "${USERNAME:+$USERNAME:$ACCESS_TOKEN@}$GIT_ADDRESS" .
        fi

        if [ $? -ne 0 ]; then
            log "Error | Git clone failed"
            exit 1
        fi
    fi
else
    log "Info | Auto update disabled."
fi

log "Info | Setting Yarn linker to node-modules"
yarn config set nodeLinker node-modules

log "Info | Installing dependencies with Yarn..."
yarn install || { log "Error | Yarn install failed"; exit 1; }

log "Info | Server startup sequence initiated. Waiting for ${STARTUP_FILE:-index.js}..."

if [ -n "$STARTUP" ]; then
    bash -c "$STARTUP"
else
    node "${STARTUP_FILE:-index.js}"
fi
