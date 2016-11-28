#!/bin/bash

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
RIAK_COMMAND="buckets/${RIAK_BUCKET}/keys/${DEST_PATH}"

FULL_CMD="curl -sf ${RIAK_HOST}${RIAK_COMMAND} -o $2"

#run the command
(eval "${FULL_CMD}") > /dev/null 2>&1