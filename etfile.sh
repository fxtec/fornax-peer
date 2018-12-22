#!/bin/bash
if [[ -f $2 ]]
then
    curl -Ss $ETCD_ENDPOINT/v2/keys/$1 -XPUT --data-urlencode value="$(base64 $2)" 2>&1 | jq -r -e '.action'
else
    curl -Ss $ETCD_ENDPOINT/v2/keys/$1 -XPUT -d dir=true 2>&1 | jq -r -e '.action'
fi
