# Use a base image with Java and PCL installed
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    pcl-tools \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Download and install osm2world
RUN wget https://osm2world.org/download/files/0.3.1/OSM2World-0.3.1-bin.zip && \
    unzip OSM2World-0.3.1-bin.zip && \
    mv OSM2World.jar osm2world.jar && \
    rm OSM2World-0.3.1-bin.zip

# Copy the processing script into the container
COPY process.sh /app/process.sh
RUN chmod +x process.sh

# Set the entrypoint to run the script
ENTRYPOINT ["/bin/bash", "/app/process.sh"]
