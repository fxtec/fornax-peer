docker service rm peer
docker service create -d --name peer -e FORNAX_PEER={{.Task.Slot}} fxtec/fornax-peer
docker service ps peer
docker service logs -f peer
