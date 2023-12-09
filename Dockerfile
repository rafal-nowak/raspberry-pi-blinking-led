# Use the official Raspberry Pi OS as the base image
FROM arm32v7/python:3

# Set the working directory
WORKDIR /app

# Update and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Install required dependencies
RUN apt-get install -y python3-rpi.gpio

# Copy the Python script to the container
COPY blink_led.py .

# Install the RPi.GPIO module
RUN pip3 install RPi.GPIO

# Run the Python script
CMD ["python3", "blink_led.py"]