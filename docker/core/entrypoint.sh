#!/bin/bash

DB_NAME="stellar"

rm -f $HOME/core.cfg
echo "DATABASE=\"postgresql://dbname=$DB_NAME user=$PGUSER password=$PGPASSWORD host=$PGHOST\"" >> $HOME/core.cfg
echo "HTTP_PORT=$STELLAR_HTTP_PORT"                         >> $HOME/core.cfg
echo "PUBLIC_HTTP_PORT=false"                               >> $HOME/core.cfg
echo "BANK_MASTER_KEY=\"$BANK_MASTER_KEY\""                 >> $HOME/core.cfg
echo "BANK_COMMISSION_KEY=\"$BANK_COMMISSION_KEY\""         >> $HOME/core.cfg
echo "NETWORK_PASSPHRASE=\"$NETWORK_PASSPHRASE\""           >> $HOME/core.cfg
echo "NODE_SEED=\"$NODE_SEED self\""                        >> $HOME/core.cfg
echo "NODE_IS_VALIDATOR=$NODE_IS_VALIDATOR"                 >> $HOME/core.cfg
echo "FAILURE_SAFETY=0"                                     >> $HOME/core.cfg
echo "UNSAFE_QUORUM=true"                                   >> $HOME/core.cfg
if [ ! -z "$PREFERRED_PEERS" ]; then
    echo "PREFERRED_PEERS=$PREFERRED_PEERS"                 >> $HOME/core.cfg
fi

echo "[QUORUM_SET]"                                         >> $HOME/core.cfg
echo "THRESHOLD_PERCENT=65"                                 >> $HOME/core.cfg
if [ ! -z $VALIDATORS ]; then
    echo "VALIDATORS=$VALIDATORS"                           >> $HOME/core.cfg
elif [[ $NODE_IS_VALIDATOR == 'true' ]]; then
    echo "VALIDATORS=[\"\$self\"]"                          >> $HOME/core.cfg
fi

echo "[HISTORY.hist]"                                       >> $HOME/core.cfg
echo "get=\"cp /tmp/stellar-core/history/vs/{0} {1}\""      >> $HOME/core.cfg
echo "put=\"cp {0} /tmp/stellar-core/history/vs/{1}\""      >> $HOME/core.cfg
echo "mkdir=\"mkdir -p /tmp/stellar-core/history/vs/{0}\""  >> $HOME/core.cfg

TABLE_EXISTS=`psql -d $DB_NAME -A -c "SELECT count(*) from information_schema.tables WHERE table_name = 'accounts'" | head -2 | tail -1`
if [[ $TABLE_EXISTS == 1 ]]; then
    echo "STARTING STELLAR CORE"
    src/stellar-core --conf $HOME/core.cfg --forcescp
    src/stellar-core --conf $HOME/core.cfg
elif [[ $TABLE_EXISTS == 0 ]]; then
    echo "INITIALIZING STELLAR DB"
    src/stellar-core --conf $HOME/core.cfg --forcescp --newdb
    src/stellar-core --conf $HOME/core.cfg
else
    echo "ERROR"
fi
