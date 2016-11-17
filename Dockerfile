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
# Switch to the workspace
WORKDIR ${workspace}
