##############
# install.sh #
##############

#!/bin/bash

# update apt cache
apt-get update

# create hemistereo user
apt-get install -y openssl
echo "Please provide the default password for the jetson user:"
PASSWORD=$(openssl passwd -crypt)
useradd -m -p $PASSWORD -s /bin/bash jetson
usermod -aG sudo jetson

# install openssh
apt-get install -y openssh-server

# remove old docker version
#apt-get remove \
#    docker \
#    docker-engine \
#    docker.io \
#    containerd \
#    runc

# install dependencies
apt-get install -y \
    apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
    device-tree-compiler python net-tools iputils-ping vim ethtool udev hwinfo \
    pciutils isc-dhcp-client libegl1-mesa-dev* libexpat1-dev libxkbcommon0 libasound2 \
    libdatrie1 libfontconfig1 libgstreamer1.0-0 libgstreamer-plugins-bad1.0-0 \
    libgstreamer-plugins-base1.0-0 libharfbuzz0b libpango-1.0-0 libpangocairo-1.0-0 \
    libpangoft2-1.0-0 libpixman-1-0 libxrender1 sudo ifupdown zlib1g-dev \
    libcairo2 libevdev2 libinput10 libjpeg-turbo8 libpng16-16 libunwind8 \
    libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev resolvconf

apt-get install -y \
    zlib1g-dev libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev python3-pip qt5* \
    xserver-xorg-core xinit

pip3 install --upgrade pip

# add docker gpg key
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
#apt-key fingerprint 0EBFCD88

# add docker repo and install
#add-apt-repository \
#   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) \
#   stable"
#apt-get update
#apt-get install -y \
#    docker-ce \
#    docker-ce-cli \
#    containerd.io

# add hemistereo user to docker group
#usermod -aG docker jetson

systemctl set-default multi-user.target
