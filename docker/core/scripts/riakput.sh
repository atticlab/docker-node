#!/bin/bash

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
RIAK_COMMAND="buckets/${RIAK_BUCKET}/keys/${DEST_PATH}?returnbody=false"
HEADER="Content-Type: multipart/mixed"

FULL_CMD="curl -v -XPUT  --data-binary @${FILE_TO_SEND} -H \"${HEADER}\" ${RIAK_HOST}${RIAK_COMMAND}"

#set bucket props
(curl -v -XPUT ${RIAK_HOST}/buckets/${RIAK_BUCKET}/props -H "Content-Type: application/json" -d '{"props":{"allow_mult":'false'}}') > /dev/null 2>&1

#run the command
(eval "${FULL_CMD}") > /dev/null 2>&1