# Classroom OnDemand Resource on Palmetto Cluster

We have worked with the [ACDS team (RCDE group at CCIT)](https://www.clemson.edu/ccit/research/service-areas/acds.html) to set up a Classroom OnDemand resource within the [Palmetto 2 Cluster](https://docs.rcd.clemson.edu/palmetto/about) to conveniently launch a desktop session for the class via a preconfigured environment (as an alternative to your own laptops if you are facing technical issues/limitations).

## Access the Resource:

1. Browse to https://classroom.rcd.clemson.edu and log in with your credentials.

2. Click on `Classroom Desktop` on the main page. The form should automatically populate with `AuE 4930/6930`.

3. You can select up to `extra-large` (8 CPU cores, 32 GB of RAM) and up to 6 hours of walltime. There is a checkbox to request a GPU; you must check it for the AutoDRIVE Simulator to work with GUI.

4. AutoDRIVE is installed at `/opt/autodrive/{simulator, devkit}`, and ROS 2 environment is already configured.

## Few Things to Note:

1. The jobs are submitted to the regular `Palmetto` queues, so there is not really a limit to how many users it can run, but jobs may wait longer in the queue.

2. The GPUs allocated for classrooms are either a `P100` or a `V100`. You can check the GPU model using the `nvidia-smi` command in a terminal window.

3. All `Palmetto` nodes are behind a firewall, so they can only be accessed through `Open OnDemand`.

4. Each job launched is a `Slurm` job on `Palmetto`, so each user only has access to their own /home, /scratch, and any project directories they have permission to access.

5. The container(s) are a read-only filesystem, so you cannot make any changes to them.

6. `/home`, `/scratch`, and `/project` are mounted in the container, so if you delete any file there, it is gone.

7. `Palmetto` has backups for `/home` and `/project`, but not for `/scratch` (see the [documentation on snapshots](https://docs.rcd.clemson.edu/indigo/snapshots/overview)).

8. Each student should complete the [onboarding](https://docs.rcd.clemson.edu/palmetto/onboarding) and read through the [documentation](https://docs.rcd.clemson.edu/palmetto) to become familiar with the cluster's policies.