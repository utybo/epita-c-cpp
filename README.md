# HEY! I've been Nix'd

EPITA has switched to using Nix and NixOS for all development purposes: this repository has no reason to exist anymore (and hasn't been updated in 3 years).

Original README below.

---

# C/C++ CI Image for EPITA

[![Docker Pulls](https://img.shields.io/docker/pulls/utybo/epita-c-cpp?logo=docker&logoColor=white&style=for-the-badge)](https://hub.docker.com/r/utybo/epita-c-cpp) [![Docker Tag](https://img.shields.io/docker/v/utybo/epita-c-cpp?label=tag&logo=docker&logoColor=white&style=for-the-badge)](https://hub.docker.com/r/utybo/epita-c-cpp)

C/C++ Docker image for using CI at EPITA.

This is a self-contained, no-dependence-on-school-servers CI setup, mostly made to speed up our own CI which uses all of this.

## Download & use

### Versions

Releases are available on [Docker Hub](https://hub.docker.com/r/utybo/epita-c-cpp). You can pull this image using the following command:

```
docker pull utybo/epita-c-cpp
```

Each version has an associated tag. There is also a `latest` tag, which corresponds to the latest version.

### Dev builds

The `main` branch is automatically deployed to the [GitHub Container Registry](https://ghcr.io/utybo/epita-c-cpp) under the `git-main` tag.

```
docker pull ghcr.io/utybo/epita-c-cpp:git-main
```

### CI/CD

This image is primarily intended for use in CI and other automated builds. You can use it as a regular Docker image. See below for an example on GitHub Actions.

## About epita-c-cpp

This is an Arch-based Docker image with various tools for testing C/C++ code at EPITA.

### Software

- All of the basic development tools from Arch
- **Compilation + dev:** Clang (including clang-format and clang-tidy), Git, autoconf, libev, boost
- **Checks:** Pre-commit
- **Functional testing:** Siege, Pytest (with xdist and timeout extensions), Requests
- **Unit testing:** Criterion, GTest, GMock
- **Others:** patch, figlet

You can check out the full list of packages by running:

```sh
# For the current unreleased version
$ docker run ghcr.io/utybo/epita-c-cpp:git-main bash -c "pacman -Q"
# For a released version, replace VERSION by the one you want (e.g. 0.2.0)
$ docker run utybo/epita-c-cpp:VERSION -c "pacman -Q"
```

### Scripts

If you want to install additional software, some are available in `/scripts`:

- `/scripts/setup-nobody` Sets up a `nobody` user, which is the used to install AUR packages. You should not call this, as it is already done.
- `/scripts/install-aur.sh` Manually installs an AUR package, e.g. `/scripts/install-aur criterion`.

### Alternatives

A few other alternatives are also available and, if this one does not do it for you, feel free to check them out:

- [`arch-toolchain`](https://github.com/chewie/arch-toolchain) by [Kévin 'Chewie' Sztern](https://github.com/chewie), the original image that gave me a starting point for this one. Also includes the `.clang-format` file used at EPITA (I'm not sure if I can redistribute it myself here)
- [`Epita-Container`](https://github.com/FrancoisDtm/Epita-Container) by [François Dtm](https://github.com/FrancoisDtm), a container image which is more intended for day-to-day use rather than CI. It also includes a `.devcontainer` file.

## Example

### GitHub Actions

Here is a starting point for a workflow in GitHub Actions.

```yaml
on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

jobs:
  check:
    # The name of our job
    name: Compiler + check
    # This is where docker is ran
    runs-on: ubuntu-20.04
    # Timeout in minutes. Criterion will sometimes freeze indefinitely while running tests.
    # Adjust this as needed
    timeout-minutes: 20
    # The steps
    steps:
      - uses: actions/checkout@v2 # Clones the repo
      # Add any step you want. Remember that you can use anything that is included in this repo!
      - name: Compile code
        runs: make all
      - name: Test code
        runs: make check
```

### GitHub Actions (manual patch)

<details>

<summary>Click to expand...</summary>

**This is no longer necessary, use the regular GitHub Actions file instead.** Previous issues required patching both the glibc inside the container *and* `runc` outside of it. These are no longer necessary (the script for patching the glibc has since then been removed), but the following is still left in case anyone needs it.

Here is a starting point for a workflow in GitHub Actions. Note that, due to [what is explained in this issue](https://github.com/actions/virtual-environments/issues/2658), we needed to manually patch the glibc in the container *and* update `runc` on the host while we waited for a new Docker release.

TL;DR, create a script in a `scripts/` folder in your repo (name it something like `ci.sh` or something) that does everything you want (compiling, etc.)

```yaml
on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

jobs:
  check:
    # The name of our job
    name: Compiler + check
    # This is where docker is ran
    runs-on: ubuntu-20.04
    # Timeout in minutes. Criterion will sometimes freeze indefinitely while running tests.
    # Adjust this as needed
    timeout-minutes: 20
    # The steps
    steps:
      # Update runc to a newer version in order to avoid a bug with Arch Linux
      # from https://github.com/zivid/zivid-python/blob/fc31e622161720e0422bfe1bb15d4d3c0be1f972/.github/workflows/main.yml
      - name: update runc
        run: |
          sudo apt-get install --assume-yes libseccomp-dev
          git clone https://github.com/opencontainers/runc
          cd runc && git checkout v1.0.0-rc93 && make -j`nproc` && sudo make install
          cd .. && rm --recursive runc
      # Clone our repo
      - uses: actions/checkout@v2
      # Run the script. Replace scripts/YOUR_SCRIPT_NAME_HERE with wherever your script is.
      - name: Run CI script
        run: |
          docker run \
              --volume $PWD:/host \
              --workdir /host \
              utybo/epita-c-cpp:latest \
              bash -c "scripts/YOUR_SCRIPT_NAME_HERE.sh"
```

This has the severe drawback of only having one step displayed on GitHub Actions for the entire compilation process. We unfortunately cannot do much about this, as we need to run stuff outside of the container (updating runc), then *in* the container (running our CI stuff). This is still a pretty nice workaround.

Here's an example of what the script could look like:

```sh
echo Compiling | figlet

make all

echo Run tests | figlet

make check
```

</details>

## Need help? Want to add something?

Feel free to open an issue if you want something else added to this image!
