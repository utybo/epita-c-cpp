#!/bin/sh

# From http://allanmcrae.com/2015/01/replacing-makepkg-asroot/

mkdir /home/build
chgrp nobody /home/build
chmod g+ws /home/build
setfacl -m u::rwx,g::rwx /home/build
setfacl -d --set u::rwx,g::rwx,o::- /home/build

# Allows "nobody" to use passwordless sudo. This is necessary for makepkg
# to automatically install stuff with pacman
echo 'nobody ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
