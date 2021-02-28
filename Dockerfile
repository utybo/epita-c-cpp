FROM archlinux:base-devel

# Copy installation scripts
COPY scripts /scripts

# Installation of basic packages
# Git, Clang, Autotools, pre-commit are generally required
# LibEV and Boost are required for the Spider project
# patch is required for installing Criterion later on
# Deploy patched-glibc *again* after the glibc update done in pacman -Syu
# Install libcsptr (dependency of criterion) and criterion
RUN /scripts/patched-glibc.sh && \
    sudo pacman -Syu --noconfirm git clang autoconf-archive libev boost python-pre-commit python-pytest python-requests python-pytest-xdist python-pytest-timeout patch figlet siege && \
    /scripts/patched-glibc.sh && \
    /scripts/setup-nobody.sh && \
    /scripts/install-aur.sh libcsptr && \
    /scripts/install-aur.sh criterion && \
    siege -C && \
    sudo pacman -Scc --noconfirm
