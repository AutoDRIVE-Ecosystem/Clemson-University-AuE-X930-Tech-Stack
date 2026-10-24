# Docker Container Limitations and Workarounds

1. Docker has issues accessing device (host) GPUs with some non-native Linux environments, especially for Vulkan graphics API. We recommend one of the following workarounds:

    - Download and use the provided bare-metal Windows or macOS executable of the AutoDRIVE Simulator (as applicable) with the [`autodrive_neoracer_api`](https://hub.docker.com/r/autodriveecosystem/autodrive_neoracer_api) container. It should work similarly.

    - From the [`autodrive_neoracer_sim`](https://hub.docker.com/r/autodriveecosystem/autodrive_neoracer_sim) container, launch AutoDRIVE Simulator in `no-graphics` mode (all rendering including vehicle camera will be disabled) by passing the IP address of the machine running the AutoDRIVE Devkit (use loopback `127.0.0.1` if running both on the same machine) as AutoDRIVE CLI arguments:
        ```bash
        ./AutoDRIVE\ Simulator.x86_64 -batchmode -nographics -ip 127.0.0.1 -port 4567
        ```

2. There is a known Docker issue on macOS that prevents RViz from rendering via containers. We suggest using [Foxglove](https://foxglove.dev/download) as an alternative data visualization tool to circumvent this constraint.

3. Some non-native Linux environments (e.g., WSL) do not allow host IPv4 network sharing with Docker containers. This would prevent users from using the AutoDRIVE Simulator (or AutoDRIVE Testbed via hardware-in-the-loop setup) and AutoDRIVE Devkit on two separate computing nodes (e.g., two different PCs) connected via a common network (wired or wireless). We suggest using a single compute node or a native Linux installation to circumvent this constraint.

4. Some non-native Linux environments (e.g., WSL) block network ports for Docker containers. We suggest explicitly forcing the port requests using `-p 4567:4567 -p 8080-8087:8080-8087 -p 8888:8888 -p 3000:3000 -p 5900:5900 -p 8765:8765` arguments instead of using host network/IPC arguments `--network=host --ipc=host` when executing the container with `docker run` command.
