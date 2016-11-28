#!/bin/bash

BUCKET_NAME="history"
LOGS_DIR="logs"
LOG_FILENAME="put.log"

if [ -z "$1" ]
  then
    echo "Usage put.sh FILENAME PATH"
    exit 0
fi

if [ -z "$2" ]
  then
    echo "Usage put.sh FILENAME PATH"
    exit 0
fi

FILE_TO_SEND=$1
DEST_PATH=$(echo $2 | sed 's/\//\%2f/g')
RIAK_COMMAND="buckets/${BUCKET_NAME}/keys/${DEST_PATH}?returnbody=false"
HEADER="Content-Type: multipart/mixed"

FULL_CMD="curl -v -XPUT  --data-binary @${FILE_TO_SEND} -H \"${HEADER}\" ${RIAK_HOST}${RIAK_COMMAND}"

#create logs dir
mkdir -p ${LOGS_DIR}

#set bucket props
(curl -v -XPUT ${RIAK_HOST}buckets/${BUCKET_NAME}/props -H "Content-Type: application/json" -d '{"props":{"allow_mult":'false'}}') >> ./${LOGS_DIR}/${LOG_FILENAME} 2>&1

#run the command
(eval "${FULL_CMD}") >> ./${LOGS_DIR}/${LOG_FILENAME} 2>&1