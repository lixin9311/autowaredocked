## ros+cuda docked

Run ROS Indigo / Ubuntu Trusty and cuda within Docker on Ubuntu Xenial or on any platform with a shared
username, home directory, and X11.

This enables you to build and run a persistent ROS Indigo workspace as long as
you can run Docker images.

Note that the Nvidia cuda library sometime downloads very slow, so I make another Dockerfile ros-cuda in case we need some modification
on the build script.

After the building, you may build Autoware as you like.

For more info on Docker see here: https://docs.docker.com/engine/installation/linux/ubuntulinux/

### Build

This will create the image with your user/group ID and home directory.

```
./build.sh IMAGE_NAME
```

### Run

This will run the docker image.

```
./dock.sh IMAGE_NAME
```

The image shares it's  network interface with the host, so you can run this in
multiple terminals for multiple hooks into the docker environment.

### Whale

🐳

### Install cuda-docker

See https://github.com/NVIDIA/nvidia-docker

```
# Install nvidia-docker and nvidia-docker-plugin
wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.0-rc.3/nvidia-docker_1.0.0.rc.3-1_amd64.deb
sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

# Test nvidia-smi
nvidia-docker run --rm nvidia/cuda nvidia-smi
```

### Enable X11 on host

```
xhost +local:root
```
