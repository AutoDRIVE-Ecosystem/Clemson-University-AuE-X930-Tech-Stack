#!/bin/bash

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

################################################################################

# AutoDRIVE Devkit Entrypoint Script for NeoRacer
#
# This script is the entrypoint for the AutoDRIVE-NeoRacer Devkit container. It
# sets up the environment, starts necessary services, and launches development
# tools such as VS Code server, VNC server, and Foxglove bridge.

################################################################################

set -e

# Source ROS 2 Humble
source /opt/ros/humble/setup.bash

# Start necessary services with supervisor
if [ -f /etc/supervisor/conf.d/neoracer.conf ]; then
    /usr/local/sbin/neoracer-supervisor-start
fi

# Emulate Jetson thermal management system
mount --bind /jetson_thermal /sys/class/thermal

# Launch VS Code server in the background
code-server --bind-addr "0.0.0.0:3000" --auth "none" > /var/log/vscode.log 2>&1 &
echo "code-server: started (connect to VS Code on port 3000)"

# Launch VNC server in the background
x11vnc -forever -usepw -create > /var/log/x11vnc.log 2>&1 &
echo "x11vnc-server: started (connect to VNC on port 5900)"

# Launch Foxglove bridge in the background
ros2 launch foxglove_bridge foxglove_bridge_launch.xml > /var/log/foxglove.log 2>&1 &
echo "foxglove-bridge: started (connect to Foxglove on port 8765)"

# Launch AutoDRIVE Devkit with RViz configuration
# ros2 run rviz2 rviz2 -d $(ros2 pkg prefix autodrive_neoracer)/share/autodrive_neoracer/rviz/vehicle.rviz
# ros2 run rviz2 rviz2 -d $(ros2 pkg prefix autodrive_neoracer)/share/autodrive_neoracer/rviz/sensors.rviz
# ros2 run rviz2 rviz2 -d $(ros2 pkg prefix autodrive_neoracer)/share/autodrive_neoracer/rviz/mapping.rviz
# ros2 run rviz2 rviz2 -d $(ros2 pkg prefix autodrive_neoracer)/share/autodrive_neoracer/rviz/navigation.rviz

# Announce that the AutoDRIVE Devkit is ready
sleep 2
echo "AutoDRIVE Devkit for NeoRacer is ready."

# Pass execution to the Docker CMD or any command passed at runtime
exec "$@"
