#!/usr/bin/env bash

# Shell script scripts to install jetfalcon dependencies
# -------------------------------------------------------------------------
#Copyright © 2021 Wei-Chih Lin , kjoelovelife@gmail.com 

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
# -------------------------------------------------------------------------
# reference
# https://chtseng.wordpress.com/2019/05/01/nvida-jetson-nano-%E5%88%9D%E9%AB%94%E9%A9%97%EF%BC%9A%E5%AE%89%E8%A3%9D%E8%88%87%E6%B8%AC%E8%A9%A6/
#
# -------------------------------------------------------------------------

if [[ `id -u` -eq 0 ]] ; then
    echo "Do not run this with sudo (do not run random things with sudo!)." ;
    exit 1 ;
fi

# Parameters
sleep_time=3s
ubuntu_distro=$(grep RELEASE /etc/lsb-release | awk -F '=' '{print $2}')
ros_distro=$ROS_DISTRO
hardware_architecture=$(uname -i)
project_name="jetfalcon"

# Functions 
power_mode(){
    """Setup Jetson nano power mode
    Args:
      hardware: 
    """
    architecture=$1
    if [ "${architecture}" == "aarch64"  ] ; then
        sudo nvpmodel -m0
        sudo nvpmodel -q
    else 
        echo "You don't use Jeton-nano. Will not setup power mode."
    fi
}

apt_install(){
    '''Use apt install ros2 dependencies for this project
    Args:
      $1: project name
    '''
    _ros_distro=$1
    sudo apt install python-pip \
                     python-frozendict \
                     python-lxml \
	                 python-bs4 \
                     python-tables \
                     python-sklearn \
                     python-rospkg \
                     python-termcolor \
                     python-sklearn \
                     python-dev \
                     python-smbus \
                     git \
                     cmake \
                     libxslt-dev \
                     libxml2-dev \
                     apt-file \
                     iftop \
                     atop \
                     ntpdate \
                     libatlas-base-dev \
                     ipython \
                     libmrpt-dev \
                     mrpt-apps \
                     ros-${_ros_distro}-slam-gmapping \
                     ros-${_ros_distro}-map-server \
                     ros-${_ros_distro}-navigation \
                     ros-${_ros_distro}-vision-msgs \
                     ros-${_ros_distro}-image-transport \
                     ros-${_ros_distro}-image-publisher \
                     byobu \
                     terminator

}

setup_authority(){
    sudo usermod -aG i2c $USER
}

setup_ydlidar(){
    '''add udev rules for Ydlidar
    Args:
      $1: project name
    '''
    workspace="$HOME/$1/catkin_ws/src/ydlidar_ros"
    echo "Setup YDLidar X4 , and it information in ~/${workspace}/README.md "
    cd ~/${workspace}/startup
    sudo chmod 777 ./*
    sudo sh initenv.sh
    sudo udevadm control --reload-rules
    sudo udevadm trigger   
}

# Install
power_mode $hardware_architecture
apt_install $ros_distro
setup_authority
setup_ydlidar $project_name  
