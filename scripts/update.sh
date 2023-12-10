#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the directory where the docker-compose.yml file is located
cd "$SCRIPT_DIR"

# Pull the latest image from Docker Hub
docker-compose pull

# Stop and remove the existing container(s)
docker-compose down

# Start a new container with the latest image
docker-compose up -d