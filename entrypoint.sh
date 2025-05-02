#!/bin/bash

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

echo "$ cd /home/container"
cd /home/container

echo "$ yarn install --check-cache"
yarn install --check-cache

echo "-- Server started, waiting for ${STARTUP_FILE}..."

${MODIFIED_STARTUP}