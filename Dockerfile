FROM archlinux:base-devel

# Copy installation scripts
COPY scripts /scripts

# Installation process
# - Install various packages
# - Set up the "nobody" user
# - Install libcsptr (dependency of criterion) and criterion via the AUR
# - siege returns JSON data on stdout, but also prints a message on the first run.
#   We run siege -C first to make it display its message -- the next uses of siege
#   will only return the json
# - Cleanup the pacman cache to save on image size
RUN sudo pacman -Syu --noconfirm git clang autoconf-archive cmake libev boost gtest \
                                 siege mkcert caddy \
                                 python-pre-commit python-pytest python-pytest-xdist python-pytest-timeout python-requests \
                                 patch figlet && \
    /scripts/setup-nobody.sh && \
    /scripts/install-aur.sh libcsptr && \
    /scripts/install-aur.sh criterion && \
    siege -C && \
    sudo pacman -Scc --noconfirm
