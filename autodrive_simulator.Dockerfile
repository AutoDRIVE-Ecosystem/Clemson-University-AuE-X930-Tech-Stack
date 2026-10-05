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

# AutoDRIVE Simulator Dockerfile for NeoRacer
#
# This Dockerfile builds the AutoDRIVE-NeoRacer Simulator container based on Ubuntu
# 22.04. It installs necessary dependencies and configures the simulation environment.
#
# Usage: docker build -t autodrive_neoracer_sim -f autodrive_simulator.Dockerfile .

#################################################################################

# Set base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_DRIVER_CAPABILITIES=graphics,utility,compute,display
ENV XDG_RUNTIME_DIR=/tmp/runtime-root

# Install Debian packages
RUN apt update \
    && apt install -y --no-install-recommends \
        ca-certificates \
        sudo \
        wget \
        gedit \
        nano \
        vim \
        curl \
        unzip \
        net-tools \
        libvulkan1 \
        mesa-vulkan-drivers \
        vulkan-tools \
        libgl1 \
        libgl1-mesa-dri \
        libegl1 \
        libgbm1 \
        libdrm2 \
        libglvnd0 \
        mesa-utils \
        libglu1-mesa \
        libgtk-3-0 \
        libnss3 \
        libx11-6 \
        libxcursor1 \
        libxi6 \
        libxinerama1 \
        libxrandr2 \
        libxss1 \
        libxxf86vm1 \
        libasound2 \
        libpulse0 \
        libc++1 \
        libc++abi1 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p "${XDG_RUNTIME_DIR}" \
    && chmod 700 "${XDG_RUNTIME_DIR}"

# Install tools for display
RUN apt update --fix-missing \
    && apt install -y xvfb ffmpeg libgdal-dev libsm6 libxext6

# Set up AutoDRIVE Simulator
COPY autodrive_simulator/. /root/autodrive_simulator
RUN chmod +x /root/autodrive_simulator/AutoDRIVE\ Simulator.x86_64

# Set work directory
WORKDIR /root

# Set entrypoint
COPY autodrive_simulator.sh /root
RUN chmod +x /root/autodrive_simulator.sh
ENTRYPOINT ["/bin/bash", "/root/autodrive_simulator.sh"]

# Keep the container alive and launch a terminal interface
CMD ["/bin/bash"]