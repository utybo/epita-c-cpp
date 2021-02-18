FROM archlinux:base-devel

# Copy installation scripts
COPY scripts /scripts

# Workaround for Arch Linux images not liking older Docker versions
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562
RUN /scripts/patched-glibc.sh

# Installation of basic packages
# Git, Clang, Autotools, pre-commit are generally required
# LibEV and Boost are required for the Spider project
# patch is required for installing Criterion later on
# Deploy patched-glibc *again* after the glibc update done in pacman -Syu
RUN sudo pacman -Syu --noconfirm git clang autoconf-archive libev boost python-pre-commit python-pytest patch figlet && \
    /scripts/patched-glibc.sh && \
    sudo pacman -Scc --noconfirm

RUN /scripts/setup-nobody.sh
RUN /scripts/install-aur.sh libcsptr
RUN /scripts/install-aur.sh criterion
