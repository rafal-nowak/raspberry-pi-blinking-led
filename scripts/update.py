import os
import subprocess
import requests
import json
import re

# Get the directory where this script is located
script_dir = os.path.dirname(os.path.realpath(__file__))

# Change to the directory where the docker-compose.yml file is located
os.chdir(script_dir)

# Define the Docker image name and repository
IMAGE_NAME = "raspberrypi-blinking-led"
REPOSITORY = "rafalnowak444"

# Get the latest version (tag) from the docker-compose.yml file
docker_compose_image = subprocess.check_output(["yq", '.services.myapp.image', "docker-compose.yml"]).decode("utf-8").split(":")[1].strip()
docker_compose_tag = re.sub(r'[^a-zA-Z0-9_-]', '', docker_compose_image)
docker_compose_tag = re.sub(r'(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})', r'\1.\2.\3.\4.\5.\6', docker_compose_tag)

# Use the Docker Hub API to get the tags for the image
response = requests.get(f"https://registry.hub.docker.com/v2/repositories/{REPOSITORY}/{IMAGE_NAME}/tags/")
tags_data = json.loads(response.text)
tags = [tag["name"] for tag in tags_data.get("results", [])]

# Find the newest version (tag)
newest_version = max(tags)

print(f"Newest version of {REPOSITORY}/{IMAGE_NAME} is: {newest_version}")
print(f"Current version of {REPOSITORY}/{IMAGE_NAME} is: {docker_compose_tag}")

# Check if the Docker Compose tag is different from the newest version
if docker_compose_tag != newest_version:
    print("Updating docker-compose.yml with the latest version...")

    # Update the docker-compose.yml file with the latest tag
    subprocess.run(["yq", "-i", "-y", f".services.myapp.image = \"{REPOSITORY}/{IMAGE_NAME}:{newest_version}\"", "docker-compose.yml"])

    # Recreate the container with the latest image
    subprocess.run(["docker-compose", "down"])
    # subprocess.run(["docker-compose", "up", "-d"])
else:
    print("Docker Compose is already using the latest version.")

# Clean up Docker resources (prune images and remove dangling volumes)
# subprocess.run(["docker", "system", "prune", "-a", "-f"])
# subprocess.run(["docker", "volume", "ls", "-qf", "dangling=true", "|", "xargs", "-r", "docker", "volume", "rm"])

subprocess.run(["docker-compose", "up", "-d"])
