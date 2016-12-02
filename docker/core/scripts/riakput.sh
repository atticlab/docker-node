#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "Usage get.sh HOST BUCKET FILE KEY"
    exit 1
fi


KEY=$(echo $4 | base64)

# run the command
curl -XPUT --data-binary @$3 -H "Content-Type: multipart/mixed" $1/buckets/$2/keys/$KEY?returnbody=false
exit