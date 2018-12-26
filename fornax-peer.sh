#!/bin/bash
cd /etc/hyperledger
et fornax-genesis | base64 -d | xargs -L 1 etoutput

function criarGenesis() {
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.blockchain.com/users/Admin@org1.blockchain.com/msp
#    peer channel create -o orderer.org1.blockchain.com:7050 -c blockchain -f /etc/hyperledger/fabric/config/channel.tx
    peer channel create -o fornax-orderer:7050 -c blockchain -f /etc/hyperledger/fabric/config/channel.tx
    etfile blockchain.block
}

function ancorar() {
    echo ANCORAR
}

function waitGenesis() {
    while [[ 0 -lt 6 ]]
    do
        et blockchain.block
        if [[ "$?" == "0" ]]
        then
            return 0
        fi
        echo "Waiting Genesis..."
        sleep 5
    done
}

if [[ "$CORE_PEER_ID" == "peer0.org1.blockchain.com" ]]
then
    et blockchain.block
    if [[ "$?" != "0" ]]
    then
        echo Genesis Peer
        criarGenesis
    fi
fi

waitGenesis
if [[ "$?" != "0" ]]
then
    echo ERRO Genesis nao existe
    exit 1
fi

ancorar
