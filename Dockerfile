#https://github.com/yeasy/docker-hyperledger-fabric-peer/blob/master/v1.2.0/Dockerfile
FROM hyperledger/fabric-peer:1.2.0
EXPOSE 7051
EXPOSE 7053

ENV CORE_VM_ENDPOINT unix:///host/var/run/docker.sock
ENV CORE_PEER_ID peer0.org1.blockchain.com
ENV CORE_VM_DOCKER_ATTACHSTDOUT true
# FIXME colocar nivel info
ENV CORE_LOGGING_PEER debug
ENV CORE_CHAINCODE_LOGGING_LEVEL info
ENV CORE_PEER_LOCALMSPID Org1MSP
ENV CORE_CHAINCODE_EXECUTETIMEOUT 300s
ENV CORE_CHAINCODE_DEPLOYTIMEOUT 300s
#ENV CORE_PEER_MSPCONFIGPATH /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.blockchain.com/peers/peer0.org1.blockchain.com/msp
ENV CORE_PEER_MSPCONFIGPATH /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.blockchain.com
ENV CORE_PEER_ADDRESS peer0.org1.blockchain.com:7051
ENV CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE fornax-genesis
ENV CORE_LEDGER_STATE_STATEDATABASE CouchDB
ENV CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS couchdb:5984
ENV CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME admin
ENV CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD adminpw

#pre-req etcd's.sh
RUN apt-get update && \
    apt-get install -y jq curl && \
    rm -rf /var/cache/apt

# fornax-peer
LABEL maintainer="davimesquita@gmail.com"
ENV ETCD_ENDPOINT http://etcd:2379
COPY et.sh /bin/et
COPY etset.sh /bin/etset
COPY etdel.sh /bin/etdel
COPY etfile.sh /bin/etfile
COPY etoutput.sh /bin/etoutput
COPY fornax-peer.sh /bin/fornax-peer
ENTRYPOINT ["/bin/bash"]