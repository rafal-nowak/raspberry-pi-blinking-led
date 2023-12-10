#!/bin/bash

# Pull the latest image from Docker Hub
docker-compose pull

# Stop and remove the existing container(s)
docker-compose down

# Start a new container with the latest image
docker-compose up -d
