docker build -t fxtec/fornax-peer .
docker system prune -f
docker volume prune -f
docker push fxtec/fornax-peer:latest
