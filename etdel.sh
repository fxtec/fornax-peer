#!/bin/bash
curl -Ss $ETCD_ENDPOINT/v2/keys/$1?recursive=true -XDELETE 2>&1 | jq -r -e '.action'
