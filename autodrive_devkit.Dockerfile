################################################################################

# Copyright (c) 2026, Tinker Twins, AutoDRIVE Ecosystem
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#################################################################################

# AutoDRIVE Devkit Dockerfile for NeoRacer
#
# This Dockerfile builds the AutoDRIVE-NeoRacer Devkit container based on Ubuntu
# 22.04 and ROS 2 Humble. It installs necessary dependencies, configures the user
# environment, and sets up services for AutoDRIVE-NeoRacer and related components.
#
# Usage: docker build -t autodrive_neoracer_api -f autodrive_devkit.Dockerfile .

#################################################################################

# Set base image
FROM ros:humble

# Install Debian packages
RUN apt update \
    && apt install -y --no-install-recommends \
        sudo \
        git \
        build-essential \
        wget \
        gedit \
        nano \
        vim \
        curl \
        unzip \
        iproute2 \
        net-tools \
        psmisc \
        python3-pip \
        supervisor \
        evince \
    && rm -rf /var/lib/apt/lists/*

# Install tools for display
RUN apt update --fix-missing \
    && apt install -y xvfb ffmpeg libgdal-dev libsm6 libxext6

# Install VNC server
RUN apt update --fix-missing \
    && apt install -y x11vnc \
    && mkdir ~/.vnc \
    && x11vnc -storepasswd autodrive-neoracer ~/.vnc/passwd

# Install VS Code server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install Foxglove bridge
RUN apt update --fix-missing \
    && apt install -y ros-humble-foxglove-bridge

# Set up AutoDRIVE Devkit (ROS 2 API)
COPY autodrive_devkit/. /root/autodrive_devkit
RUN cd /root/autodrive_devkit \
    && sudo chmod +x autodrive_install.sh \
    && sudo bash autodrive_install.sh

# Set work directory and expose ports
WORKDIR /root
# VS Code server
EXPOSE 3000
# VNC server
EXPOSE 5900
# Foxglove
EXPOSE 8765
# Jupyter Lab
EXPOSE 8888
# AutoDRIVE
EXPOSE 4567
# NeoRacer
EXPOSE 8080-8087

# Set entrypoint 
COPY autodrive_devkit.sh /root/autodrive_devkit.sh
RUN chmod +x /root/autodrive_devkit.sh
ENTRYPOINT ["/bin/bash", "/root/autodrive_devkit.sh"]

# Keep the container alive and launch a terminal interface
CMD ["/bin/bash"]