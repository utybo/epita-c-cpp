#!/bin/sh

# Workaround for Arch Linux images not liking older Docker versions
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562
set -e


patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst

if [ ! -f "$patched_glibc" ]; then
    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc"
fi

bsdtar -C / -xvf "$patched_glibc"
