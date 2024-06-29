# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# ENV DEBIAN_FRONTEND=noninteractive


# Update package list and install Python 3
RUN apt-get update \
    && apt-get install -y systemd systemd-sysv \
    && apt-get install -y python3  python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the default Python version
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Verify Python 3 installation
RUN python3 --version

# STOPSIGNAL SIGRTMIN+3

# Set default command
CMD ["/bin/bash"]
