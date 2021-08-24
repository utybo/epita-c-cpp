FROM archlinux:base-devel-20210822.0.32033

# Copy installation scripts
COPY scripts /scripts

# Installation process
# - Install various packages
# - Set up the "nobody" user
# - Install libcsptr (dependency of criterion) and criterion via the AUR
# - siege returns JSON data on stdout, but also prints a message on the first run.
#   We run siege -C first to make it display its message -- the next uses of siege
#   will only return the json
# - Erase Pacman cache
RUN sudo pacman -Syu --noconfirm git clang autoconf-archive cmake libev boost python-pre-commit \
                                 python-pytest python-pytest-xdist python-pytest-timeout \
                                 python-requests patch figlet siege gtest gmock mkcert caddy && \
    /scripts/setup-nobody.sh && \
    /scripts/install-aur.sh libcsptr && \
    /scripts/install-aur.sh criterion && \
    siege -C && \
    sudo pacman -Scc --noconfirm
