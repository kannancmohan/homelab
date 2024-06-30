# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update package list and install Python 3
RUN apt-get update \
    && apt-get install -y iproute2 python3  python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the default Python version
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Verify Python 3 installation
RUN python3 --version

# Set default command
CMD ["/bin/bash"]
