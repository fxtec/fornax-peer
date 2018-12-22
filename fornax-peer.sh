#!/bin/bash
cd /etc/hyperledger
et fornax-genesis | base64 -d | xargs -L 1 etoutput
#cd $FABRIC_CA_SERVER_CA_KEYFILE
#export FABRIC_CA_SERVER_CA_KEYFILE=$FABRIC_CA_SERVER_CA_KEYFILE$(ls *_sk)
#cd ~
#fabric-ca-server start -b $FABRIC_CA_USER:$FABRIC_CA_PW
