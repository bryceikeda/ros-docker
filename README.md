# Docker Setup

## Building the image
Add your personal preferences to the [tools dockerfile](dockerfiles/tools/preferences/dockerfile). You may also add your own underlay repositories here [underlay.repos](dockerfiles/noetic/assets/underlay.repos). These will be automatically cloned, built, and sourced in the /opt/underlay_ws folder. All other development will occur in /opt/overlay_ws, which is mounted from the workspace/src directory. 

To build the image, run the following command: 

```
make build_ros_noetic_full
```

## Running the image
```
make run_ros_noetic_full
```

## Starting a stopped container

Check the container ID first four digits
```
docker container ls -a
```

Then start the container
```
make start_ros_noetic [Container ID (first four digits)]
```

# Rocker (Under development)
Using Rocker is currently under development. It has an issue where tmp files are deleted when a container is stopped, preventing you from starting a container. It can still technically be used if you never stop the container.

If you would like to use [rocker](https://github.com/osrf/rocker.git), a tool to run doker images with customized local support injected. Then run the install script. 

```
source ./scripts/install_rockers.sh
```

Run container with rocker 
```
make run_rocker_noetic
```

## Reopening a container

If you used Rocker, reactivate the venv using the activate script.

```
source ./scripts/activate_rocker_venv.sh
```

In either workflow, check the container ID first four digits
```
docker container ls -a
```

Then start the container
```
make start_ros_noetic [Container ID (first four digits)]
```

## Acknowledgements
[ros-docker-gui](https://github.com/turlucode/ros-docker-gui.git)
[ruffsl docker implementation](https://github.com/ruffsl/navigation2/blob/main/Dockerfile)

