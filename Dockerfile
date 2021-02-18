FROM archlinux:base-devel

# Copy installation scripts
COPY scripts /scripts

# Installation of basic packages
# Git, Clang, Aututools, pre-commit are generally required
# LibEV and Boost are required for the Spider project
# patch is required for installing Criterion later on
RUN sudo pacman -Syu --noconfirm git clang autoconf-archive libev boost python-pre-commit python-pytest patch figlet

RUN /scripts/setup-nobody.sh
RUN /scripts/install-aur.sh libcsptr
RUN /scripts/install-aur.sh criterion
