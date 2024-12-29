#!/bin/bash

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

cd /home/container

yarn install --check-cache --production

echo "-- Server started, waiting for ${STARTUP_FILE}..."

${MODIFIED_STARTUP}