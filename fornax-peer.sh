#!/bin/bash

function main() {

log INFO PEER $FORNAX_PEER

precert
cpdir ./crypto-config/peerOrganizations/org1.blockchain.com/peers/peer$FORNAX_PEER.org1.blockchain.com/msp /etc/hyperledger/msp/peer
cpdir ./crypto-config/peerOrganizations/org1.blockchain.com/users /etc/hyperledger/msp/users
cpdir ./config /etc/hyperledger/configtx

export CORE_PEER_ID=peer$FORNAX_PEER.org1.blockchain.com
export CORE_PEER_ADDRESS=peer$FORNAX_PEER.org1.blockchain.com:7051

peer node start &

if [[ "$FORNAX_PEER" == "0" ]]
then
    et blockchain.block
    if [[ "$?" != "0" ]]
    then
        log INFO Genesis Peer
        criarGenesis
    fi
fi

waitGenesis
if [[ "$?" != "0" ]]
then
    log ERRO Genesis nao existe
    exit 1
fi

ancorar

heartbeat

};
function cpdir() {
    cd /etc/fornax/fabric
    mkdir -p $2
    cp -r $1/* $2
};
function precert() {
mkdir -p /etc/fornax
cd /etc/fornax
et fornax-genesis | base64 -d | xargs -L 1 etoutput
};
function criarGenesis() {
    cd $HOME_DIR
    export CORE_PEER_LOCALMSPID=Org1MSP
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.blockchain.com/msp
    peer channel create -o orderer.blockchain.com:7050 -c blockchain -f /etc/hyperledger/configtx/channel.tx
    etfile blockchain.block blockchain.block
}
function ancorar() {
    log INFO Ancorar
    cd $HOME_DIR
    export CORE_PEER_LOCALMSPID=Org1MSP
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.blockchain.com/msp
    etoutput blockchain.block > /dev/null
    peer channel join -b blockchain.block
}
function waitGenesis() {
    max=5
    for (( i=1; i <= $max; ++i ))
    do
        et blockchain.block > /dev/null
        if [[ "$?" == "0" ]]
        then
            return 0
        fi
        log INFO Waiting Genesis...
        sleep 10
    done
}
function heartbeat() {
    while true;
    do
        log INFO heartbeat OK
        sleep 10
    done
}
function log() {
    echo "$(date +"%s %FT%T") [$(hostname -A)|$(hostname -I)] $@"
};

main
