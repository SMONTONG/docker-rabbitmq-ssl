# RabbitMQ with SSL Configuration in Docker

## Required
docker compose

## Build image
```bash
docker compose build --pull --no-cache
docker compose up -d
```

## Test
```bash
openssl s_client -connect 127.0.0.1:5671
```
