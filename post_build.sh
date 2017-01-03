#!/usr/bin/env bash
echo "building opencv......"
cd "/opt/OpenCV/opencv-2.4.13"
mkdir build && cd build && \
cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON \
  -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON \
  -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON \
  -D WITH_OPENGL=ON -D WITH_VTK=ON \
  -D CUDA_GENERATION=Auto -D WITH_NVCUVID=ON \
  -D WITH_CUBLAS=ON -D WITH_CUDA=ON -D WITH_NVCUVID=ON \
  -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda/ \
  -D CUDA_CUDA_LIBRARY=/usr/local/nvidia/lib64/libcuda.so ..
make -j$(nproc)
sudo make install
sudo ldconfig

echo "building Autoware......"
cd "/opt/Autoware/ros/src" && catkin_init_workspace && \
cd ../ && ./catkin_make_release

