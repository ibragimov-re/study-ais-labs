#!/bin/bash

# Exit immediately if a command exits with a non-zero status (error)
set -e

# Setup and start the Docker containers in detached mode
docker compose up -d

# Start nginx in the container

docker compose exec ais-debian bash -c "nginx"

# Make iptables script executable inside the container
docker compose exec ais-debian chmod +x /home/Labs/Lab4_PacketFiltering/setup_iptables.sh

# Run iptables setup script inside the container
docker compose exec ais-debian /home/Labs/Lab4_PacketFiltering/setup_iptables.sh

# Open an interactive bash shell inside the container
docker compose exec ais-debian bash