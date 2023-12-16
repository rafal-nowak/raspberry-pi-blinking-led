#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the directory where the docker-compose.yml file is located
cd "$SCRIPT_DIR"

# Define the Docker image name and repository
IMAGE_NAME="raspberrypi-blinking-led"
REPOSITORY="rafalnowak444"

# Get the latest version (tag) from the docker-compose.yml file
DOCKER_COMPOSE_TAG=$(yq '.services.myapp.image' docker-compose.yml | awk -F ':' '{print $2}' | sed 's/[^a-zA-Z0-9_-]//g')

# Use the Docker Hub API to get the tags for the image
TAGS=$(curl -s "https://registry.hub.docker.com/v2/repositories/${REPOSITORY}/${IMAGE_NAME}/tags/" | jq -r '.results[].name')

# Find the newest version (tag)
NEWEST_VERSION=""
for TAG in $TAGS; do
    if [[ "$TAG" > "$NEWEST_VERSION" ]]; then
        NEWEST_VERSION="$TAG"
    fi
done

echo "Newest version of ${REPOSITORY}/${IMAGE_NAME} is: ${NEWEST_VERSION}"
echo "Current version of ${REPOSITORY}/${IMAGE_NAME} is: ${DOCKER_COMPOSE_TAG}"

# Check if the Docker Compose tag is different from the newest version
if [ "$DOCKER_COMPOSE_TAG" != "$NEWEST_VERSION" ]; then
    echo "Updating docker-compose.yml with the latest version..."

    # Update the docker-compose.yml file with the latest tag
    yq -i -y ".services.myapp.image = \"$REPOSITORY/$IMAGE_NAME:$NEWEST_VERSION\"" docker-compose.yml

    # Recreate the container with the latest image
    docker-compose down
    #docker-compose up -d
else
    echo "Docker Compose is already using the latest version."
fi

# Clean up Docker resources (prune images and remove dangling volumes)
#docker system prune -a -f
#docker volume ls -qf dangling=true | xargs -r docker volume rm

docker-compose up -d