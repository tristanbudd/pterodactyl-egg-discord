#!/bin/bash

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

echo "> cd /home/container"
cd /home/container

echo "> corepack enable"
corepack enable

echo "> yarn set version stable"
yarn set version stable

echo "> yarn install --immutable --check-cache"
yarn install --immutable --check-cache

echo "-- Server started, waiting for ${STARTUP_FILE}..."

${MODIFIED_STARTUP}