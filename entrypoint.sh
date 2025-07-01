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
    # Correct Git URL formation
    if [ -n "$USERNAME" ] && [ -n "$ACCESS_TOKEN" ]; then
        GIT_URL="${GIT_ADDRESS/https:\/\//https:\/\/$USERNAME:$ACCESS_TOKEN@}"
    else
        GIT_URL="$GIT_ADDRESS"
    fi

    if [ -z "$(ls -A)" ]; then
        log "Info | Directory empty, cloning repo..."

        if [ -z "$BRANCH" ]; then
            git clone "$GIT_URL" .
        else
            git clone --single-branch --branch "$BRANCH" "$GIT_URL" .
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
        TARGET=$(normalize "$GIT_URL")

        if [ "$ORIGIN" != "$TARGET" ]; then
            log "Warning | Git origin does not match target: $ORIGIN vs $TARGET"
            log "Info | Forcing update of git origin URL..."
            git remote set-url origin "$GIT_URL"
        fi

        log "Info | Pulling latest changes from git repo..."
        git fetch --all
        git reset --hard origin/${BRANCH:-master}
        git clean -fd

        if [ -n "$BRANCH" ]; then
            git checkout "$BRANCH"
        fi
    else
        log "Warning | Directory not a git repo but not empty, deleting contents and cloning fresh..."
        rm -rf ./* .[^.] .??* || { log "Error | Failed to clean directory"; exit 1; }

        if [ -z "$BRANCH" ]; then
            git clone "$GIT_URL" .
        else
            git clone --single-branch --branch "$BRANCH" "$GIT_URL" .
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

if [ -f "package-lock.json" ]; then
    log "Info | Removing package-lock.json to prevent npm/yarn conflict"
    rm package-lock.json
fi

log "Info | Installing dependencies with Yarn..."
yarn install || { log "Error | Yarn install failed"; exit 1; }

log "Info | Server startup sequence initiated. Waiting for ${STARTUP_FILE:-index.js}..."

if [ -n "$STARTUP" ]; then
    bash -c "$STARTUP"
else
    node "${STARTUP_FILE:-index.js}"
fi
