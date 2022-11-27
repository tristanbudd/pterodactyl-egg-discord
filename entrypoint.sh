#!/bin/bash
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
yarn install
${MODIFIED_STARTUP}