#!/bin/sh

if [ $# -ne 1 ]; then
    echo "install-aur: ERROR: Must have exactly one argument"
    exit 1
fi

echo "install-aur: Installing $1"

pushd .
git clone --quiet --depth 1 "https://aur.archlinux.org/$1.git" "/home/build/$1"
cd "/home/build/$1"
runuser -u nobody -- makepkg -si --noconfirm --nocheck
popd
