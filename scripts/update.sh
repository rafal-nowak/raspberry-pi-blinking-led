#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the directory where the docker-compose.yml file is located
cd "$SCRIPT_DIR"

# Name of your Docker Compose service
SERVICE_NAME="myapp"

# Use docker-compose to pull the latest images and capture the output
PULL_OUTPUT=$(docker-compose pull 2>&1)

# Check if the output contains the string "Image is up to date" or "Pull complete"
if [[ $PULL_OUTPUT == *"Image is up to date"* || $PULL_OUTPUT == *"Pull complete"* ]]; then
    # No changes in the images, no need to stop and recreate the container
    echo "No changes in images. Container is up to date."
else
    # There are changes in the images, stop and recreate the container
    echo "Changes detected in images. Stopping and recreating the container..."

    # Check if the container is running
    if docker-compose ps | grep -q "$SERVICE_NAME"; then
        # Stop the container if it's running
        docker-compose down
    fi

fi

docker-compose up -d