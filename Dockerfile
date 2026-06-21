FROM osrf/ros:humble-desktop

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    cmake \
    libboost-system-dev \
    libboost-thread-dev \
    libeigen3-dev \
    ros-humble-ur \
    ros-humble-ur-* \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:sdurobotics/ur-rtde -y \
    && apt-get update && apt-get install -y \
    librtde \
    librtde-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN wget https://download.pytorch.org/libtorch/cu132/libtorch-shared-with-deps-2.12.1%2Bcu132.zip \
    && unzip -q libtorch.zip \
    && rm libtorch.zip

WORKDIR /skrl
COPY ./src ./src

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /skrl/install/setup.bash" >> ~/.bashrc
RUN source /opt/ros/humble/setup.bash && colcon build --packages-select skrl_msgs
RUN source /opt/ros/humble/setup.bash && source /skrl/install/setup.bash && colcon build