#!/bin/bash

if [ -z "$1" ]
  then
    echo "Usage put.sh FILENAME KEY"
    exit 0
fi

if [ -z "$2" ]
  then
    echo "Usage put.sh FILENAME KEY"
    exit 0
fi

DEST_PATH=$(echo $2 | base64)

# run the command
curl -sf -XPUT --data-binary @$1 -H "Content-Type: multipart/mixed" $RIAK_HOST/buckets/$RIAK_BUCKET/keys/$DEST_PATH?returnbody=false
exit
