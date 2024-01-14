# Stage 1: Caching dependencies
ARG FROM_IMAGE=ros:noetic-ros-core
ARG UNDERLAY_WS=/opt/underlay_ws
ARG OVERLAY_WS=/opt/overlay_ws
FROM $FROM_IMAGE AS cacher

# Install ros dependencies for caching
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y git python3-vcstool && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone underlay source
ARG UNDERLAY_WS
ENV UNDERLAY_WS $UNDERLAY_WS
WORKDIR $UNDERLAY_WS/src
COPY dockerfiles/noetic/assets/underlay.repos ../
RUN vcs import ./ < ../underlay.repos

# Copy manifests for caching
WORKDIR /opt
RUN find . -name "src" -type d \
      -mindepth 1 -maxdepth 2 -printf '%P\n' \
      | xargs -I % mkdir -p /tmp/opt/% && \
    find . -name "package.xml" \
      | xargs cp --parents -t /tmp/opt

# Stage 2: Building dependencies
FROM $FROM_IMAGE AS builder

# Install ros dependencies for building
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        python3-rosdep \
        python3-rosinstall \
        python3-rosinstall-generator \
        python3-wstool \
        python3-catkin-tools \
	ros-${ROS_DISTRO}-moveit \
        build-essential && \
    rosdep init && \
    rosdep update && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install underlay dependencies
ARG UNDERLAY_WS
ENV UNDERLAY_WS $UNDERLAY_WS
WORKDIR $UNDERLAY_WS
COPY --from=cacher /tmp/$UNDERLAY_WS ./
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt-get update && rosdep install -q -y \
      --from-paths src \
      --ignore-src \
    && rm -rf /var/lib/apt/lists/*

# Build underlay source
COPY --from=cacher $UNDERLAY_WS ./
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    catkin config --extend /opt/ros/$ROS_DISTRO && \
    catkin build

# Stage 3: Development environment
FROM builder AS devel

# Edit apt for caching
RUN mv /etc/apt/apt.conf.d/docker-clean /etc/apt/

# Install CMake
ARG CMAKE_VERSION=3.28.1
RUN git clone https://gitlab.kitware.com/cmake/cmake.git && \
    cd cmake && git checkout tags/v${CMAKE_VERSION} && \
    ./bootstrap --parallel=8 && make -j8 && make install && \
    cd .. && rm -rf cmake

# Install developer dependencies
RUN apt-get update && \
    apt-get install -y \
    --allow-downgrades --allow-remove-essential --allow-change-held-packages \
    bash-completion \
    git \
    vim \
    python3-pip \
    software-properties-common \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# add source folders
#ARG OVERLAY_WS
#WORKDIR $OVERLAY_WS/src
#COPY ./fetch_mtc ./fetch_mtc

# Build overlay source
#WORKDIR $OVERLAY_WS
#RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
#    apt-get update && rosdep install -q -y \
#        --from-paths src \
#        --ignore-src \
#    && rm -rf /var/lib/apt/lists/*
#RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
#    catkin config --extend /opt/ros/$ROS_DISTRO && \
#    catkin build
