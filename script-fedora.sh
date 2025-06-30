#!/bin/bash

# The script works only on Fedora and can be forked for it to run on other distros. 
# This is also made for the Surface Pro 7+, though running the script might also
# work on your computer. Good luck, and enjoy

# clone the repositories
git clone https://github.com/quo/ithc-linux
# git clone https://github.com/linux-surface/iptsd

# add the Linux Surface repository
sudo dnf config-manager addrepo --from-repofile=https://pkg.surfacelinux.com/fedora/linux-surface.repo

# install dkms and meson
sudo dnf install dkms meson build gcc-c++ sdl2-compat-devel.x86_64 -y

# cd into ithc-linux and run make dkms-install
cd ~/ithc/ithc-linux
sudo make dkms-install

# add ithc to modprobe
if ! [ -f /etc/modules-load.d/ithc.conf]; then
	echo "ithc" | sudo tee -a /etc/modules-load.d/ithc.conf
fi

# install kernel needed
sudo dnf install --allowerasing kernel-surface iptsd libwacom-surface

# adding secure boot
sudo dnf install surface-secureboot

# cd into iptsd and run meson build, then ninja -C build
cd iptsd
meson build
ninja -C build

echo "Please calibrate the touchscreen for finger size with sudo iptsd-calibrate /dev/hidraw0"
echo "and activate palm rejection in /etc/iptsd.conf"
