#!/bin/bash

BUCKET_NAME="history"
LOGS_DIR="logs"
LOG_FILENAME="get.log"

if [ -z "$1" ]
  then
    echo "Usage get.sh PATH FILENAME"
    exit 0
fi

if [ -z "$2" ]
  then
    echo "Usage get.sh PATH FILENAME"
    exit 0
fi

FILE_TO_GET=$2
DEST_PATH=$(echo $1 | sed 's/\//\%2f/g')
RIAK_COMMAND="buckets/${BUCKET_NAME}/keys/${DEST_PATH}"

FULL_CMD="curl -sf ${RIAK_HOST}${RIAK_COMMAND} -o $2"

#create logs dir
mkdir -p ${LOGS_DIR}

#run the command
(eval "${FULL_CMD}") >> ./${LOGS_DIR}/${LOG_FILENAME} 2>&1