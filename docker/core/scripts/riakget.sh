#!/bin/bash

if [ -z "$1" ]
  then
    echo "Usage get.sh KEY FILENAME"
    exit 0
fi

if [ -z "$2" ]
  then
    echo "Usage get.sh KEY FILENAME"
    exit 0
fi

DEST_PATH=$(echo $1 | base64)

curl -sf $RIAK_HOST/buckets/$RIAK_BUCKET/keys/$DEST_PATH -o $2
exit
