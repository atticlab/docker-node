#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "Usage get.sh HOST BUCKET KEY FILE"
    exit 1
fi

KEY=$(echo -n $3 | sha256sum | cut -c -64)
curl -v $1/buckets/$2/keys/$KEY -o $4
exit
