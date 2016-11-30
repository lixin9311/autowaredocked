FROM ros-cuda

# Arguments
ARG user
ARG uid
ARG home
ARG workspace
ARG shell

# Basic Utilities
RUN apt-get -y update && apt-get install --no-install-recommends\
  -y zsh screen tree sudo ssh synaptic

# Latest X11 / mesa GL
RUN apt-get install -y --no-install-recommends\
  xserver-xorg-dev-lts-wily\
  libegl1-mesa-dev-lts-wily\
  libgl1-mesa-dev-lts-wily\
  libgbm-dev-lts-wily\
  mesa-common-dev-lts-wily\
  libgles2-mesa-lts-wily\
  libwayland-egl1-mesa-lts-wily\
  libopenvg1-mesa libcanberra-gtk* gnome-terminal

# Dependencies required to build rviz
RUN apt-get install -y --no-install-recommends\
  qt4-dev-tools\
  libqt5core5a libqt5dbus5 libqt5gui5 libwayland-client0\
  libwayland-server0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1\
  libxcb-render-util0 libxcb-util0 libxcb-xkb1 libxkbcommon-x11-0\
  libxkbcommon0

# The rest of ROS-desktop
RUN apt-get install -y  --no-install-recommends ros-indigo-desktop-full\
  ros-indigo-nmea-msgs ros-indigo-nmea-navsat-driver\
  ros-indigo-sound-play ros-indigo-jsk-visualization

# Additional development tools
RUN apt-get install -y --no-install-recommends x11-apps\
  python-pip build-essential git
RUN pip install catkin_tools

# Autoware
RUN apt-get install -y --no-install-recommends libnlopt-dev freeglut3-dev qtbase5-dev\
  libqt5opengl5-dev libssh2-1-dev libarmadillo-dev libpcap-dev\
  gksu mesa-common-dev libgl1-mesa-dev

# OpenCV
RUN echo "deb http://jp.archive.ubuntu.com/ubuntu trusty main multiverse" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends \
  libopencv-dev build-essential cmake git \
  libgtk2.0-dev pkg-config python-dev python-numpy libdc1394-22 \
  libdc1394-22-dev libjpeg-dev libpng12-dev libtiff4-dev libjasper-dev \
  libavcodec-dev libavformat-dev libswscale-dev libxine-dev \
  libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev \
  libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev \
  libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev \
  x264 v4l-utils unzip wget

# Make SSH available
EXPOSE 22

# Mount the user's home directory
VOLUME "${home}"

# Clone user into docker image and set up X11 sharing
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:${shell}" >> /etc/passwd && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}"

# Switch to user
USER "${user}"
# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1
ENV CATKIN_TOPLEVEL_WS="${workspace}/devel"

# Download and build OpenCV
RUN sudo mkdir "/opt/OpenCV" && sudo chown "${user}" "/opt/OpenCV"
RUN wget -O "/opt/OpenCV/opencv-2.4.13.zip" https://github.com/opencv/opencv/archive/2.4.13.zip
RUN cd "/opt/OpenCV/" && unzip "/opt/OpenCV/opencv-2.4.13.zip"
#RUN sudo ln -s "/usr/local/nvidia/lib64/libnvcuvid.so.1" "/usr/lib/libnvcuvid.so"
RUN echo "there is an issue with nvidia-docker, please build opencv and autoware on you own after docker build"

# Autoware
RUN sudo mkdir "/opt/Autoware" && sudo chown "${user}" "/opt/Autoware"
RUN git clone https://github.com/CPFL/Autoware.git "/opt/Autoware"

# Switch to the workspace
WORKDIR ${workspace}

