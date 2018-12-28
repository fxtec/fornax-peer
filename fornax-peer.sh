#!/bin/bash

function main() {

export TASK=$(expr $FORNAX_PEER - 1)
log INFO PEER $TASK

export CORE_PEER_ID=peer$TASK.org1.blockchain.com
export CORE_PEER_ADDRESS=peer$TASK.org1.blockchain.com:7051

prepararCert

if [[ "$TASK" == "0" ]]
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

};
function prepararCert() {
    cd /etc/hyperledger
    et fornax-genesis | base64 -d | xargs -L 1 etoutput

    mkdir -p /etc/hyperledger/msp/peer
    cp -R /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.blockchain.com/peers/peer$TASK.org1.blockchain.com/msp/* \
    /etc/hyperledger/msp/peer/

    mkdir -p /etc/hyperledger/msp/users
    cp -R /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.blockchain.com/users/* \
    /etc/hyperledger/msp/users/

    mkdir -p /etc/hyperledger/configtx
    cp -R /etc/hyperledger/fabric/config/* \
    /etc/hyperledger/configtx/
};
function criarGenesis() {
    env
    cd /etc/hyperledger/configtx
    export CORE_PEER_LOCALMSPID=Org1MSP
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.blockchain.com/msp
    ls /etc/hyperledger/msp/users/Admin@org1.blockchain.com/msp
    ls /etc/hyperledger/msp/users/Admin@org1.blockchain.com/msp/
    peer channel create -o fornax-orderer:7050 -c blockchain -f /etc/hyperledger/configtx/channel.tx
    # FIXME tirar ls
    #etfile blockchain.block blockchain.block
    ls
}
function ancorar() {
    log ERROR ANCORAR
}
function waitGenesis() {
    ## FIXME Colocar 5
    max=100
    for (( i=1; i <= $max; ++i ))
    do
        et blockchain.block
        if [[ "$?" == "0" ]]
        then
            return 0
        fi
        log INFO Waiting Genesis...
        sleep 10
    done
}
function log() {
    echo "$(date +"%s %FT%T") [$(hostname -A)|$(hostname -I)] $@"
};

main
