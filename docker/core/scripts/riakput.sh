#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "Usage get.sh HOST BUCKET FILE KEY"
    exit 1
fi

KEY=$(echo -n $4 | sha256sum | cut -c -64)

# run the command
echo "curl -XPUT --data-binary @$3 -H \"Content-Type: multipart/mixed\" $1/buckets/$2/keys/$KEY?returnbody=false"

curl -XPUT $1/buckets/$2/props -H "Content-Type: application/json" -d '{"props":{"allow_mult":'false'}}'
curl -XPUT --data-binary @$3 -H "Content-Type: multipart/mixed" "$1/buckets/$2/keys/$KEY?returnbody=false"
exit