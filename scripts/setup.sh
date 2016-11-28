#!/bin/bash

GENSEED="$(docker run --rm crypto/core src/stellar-core --genseed)"
SEED=${GENSEED:13:56}
PUBLIC=${GENSEED:78:56}
IS_VALIDATOR='false'
MASTER_KEY=''
COMISSION_KEY=''
PEERS=''

# Parse args
for i in "$@"
do
case $i in
    # -s=*|--searchpath=*)
    --is-validator)
    IS_VALIDATOR="true"
    shift
    ;;
    *)
        echo "Unknown option: $i"
        exit
    ;;
esac
done

strpos()
{
    local str=${1}
    local offset=${3}

    if [ -n "${offset}" ]; then
        str=`substr "${str}" ${offset}`
    else
        offset=0
    fi

    str=${str/${2}*/}

    if [ "${#str}" -eq "${#1}" ]; then
        return 0
    fi

    echo $((${#str}+${offset}))
}

while true
do
    read -ra key -p "Bank master key: "
    valid="$(docker run --rm crypto/core src/stellar-core --checkpub $key)"
    if [[ $valid == 1 ]]; then
        MASTER_KEY=$key
        break
    else
        echo "Error: key is invalid. Try again."
    fi
done

while true
do
    read -ra key -p "Comission key: "
    valid="$(docker run --rm crypto/core src/stellar-core --checkpub $key)"
    if [[ $key == $MASTER_KEY ]]; then
        echo "Error: comission key must be different from master key."
    elif [[ $valid == 1 ]]; then
        COMISSION_KEY=$key
        break
    else
        echo "Error: key is invalid. Try again."
    fi
done

regex='http(s?):\/\/((\w+\.)?\w+\.\w+|((2[0-5]{2}|1[0-9]{2}|[0-9]{1,2})\.){3}(2[0-5]{2}|1[0-9]{2}|[0-9]{1,2}))(\/)?(\:(\d){1,5})?'
while true
do
    read -ra peer -p "Add preferred peer (empty line to finish): "
    if [[ $peer == '' ]]; then
        if [[ $PEERS == '' ]]; then
            echo "You need to add at least one peer"
        else
            break
        fi
    fi

    peer=${peer,,}
    exists="$(strpos \"$PEERS\" \"$peer\")"

    if [[ ! $peer =~ $regex ]]
    then
        echo "Error: Peer address [$peer] is not valid!"
        continue
    elif [[ $exists != '' ]]; then
        echo "Error: Peer address [$peer] already added!"
        continue
    fi

    echo "$peer added to preferred!"
    PEERS+=\"${peer// }\",
done

if [[ $PEERS != '' ]]; then
    PEERS=${PEERS::-1}
fi

rm -f ./.core-cfg

echo "**************************************************************************"
echo "Node public key [$PUBLIC]"
echo "**************************************************************************"

echo "NODE_SEED=$SEED" >> ./.core-cfg
echo "NODE_IS_VALIDATOR=$IS_VALIDATOR" >> ./.core-cfg
echo "BANK_MASTER_KEY=$MASTER_KEY" >> ./.core-cfg
echo "BANK_COMMISSION_KEY=$COMISSION_KEY" >> ./.core-cfg

if [[ $PEERS != '' ]]; then
    echo "PREFERRED_PEERS=[$PEERS]" >> ./.core-cfg
fi