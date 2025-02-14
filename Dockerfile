# Use a base image with Java and PCL installed
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    tzdata \
    openjdk-17-jre \
    pcl-tools \
    wget \
    unzip \
    python3 \
    cmake \
    g++ \
    qtbase5-dev \
    qttools5-dev \
    qttools5-dev-tools \
    qtscript5-dev \
    libqt5svg5-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libboost-filesystem-dev \
    libglm-dev \
    libgdal-dev \
    libpcl-dev \
    libeigen3-dev \
    libqt5opengl5-dev \
    libqt5websockets5-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Download and install osm2world
RUN wget https://osm2world.org/download/files/0.3.1/OSM2World-0.3.1-bin.zip && \
    unzip OSM2World-0.3.1-bin.zip && \
    mv OSM2World.jar osm2world.jar && \
    rm OSM2World-0.3.1-bin.zip

# Clone and build CloudCompare
WORKDIR /app
RUN git clone --recursive https://github.com/CloudCompare/CloudCompare.git && \
    cd CloudCompare && \
    mkdir build && \
    cd build && \
    cmake .. -DPLUGIN_STANDARD_QPCL=ON && \
    cmake --build . && \
    cmake --install .

# Copy the processing script into the container
COPY process.sh /app/process.sh
COPY clean_mtl_file.py /app/clean_mtl_file.py

RUN chmod +x process.sh

# Set the entrypoint to run the script
ENTRYPOINT ["/bin/bash", "/app/process.sh"]
