FROM archlinux:base-devel

# Copy installation scripts
COPY scripts /scripts

# Workaround for Arch Linux images not liking older Docker versions
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xvf "$patched_glibc"

# Installation of basic packages
# Git, Clang, Aututools, pre-commit are generally required
# LibEV and Boost are required for the Spider project
# patch is required for installing Criterion later on
RUN sudo pacman -Syu --noconfirm git clang autoconf-archive libev boost python-pre-commit python-pytest patch figlet && sudo pacman -Scc

RUN /scripts/setup-nobody.sh
RUN /scripts/install-aur.sh libcsptr
RUN /scripts/install-aur.sh criterion
