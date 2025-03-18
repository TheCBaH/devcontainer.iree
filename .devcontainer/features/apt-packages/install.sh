#!/bin/sh
set -e
set -x

echo "Activating feature 'apt_packages'"

PACKAGES=${PACKAGES:-$@}
echo "Selected packages: $PACKAGES"

# From https://github.com/devcontainers/features/blob/main/src/git/install.sh
apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        if ! apt-get -o Acquire::Retries=3 -y install --no-install-recommends "$@"; then
            apt-get update -y
            apt-get -o Acquire::Retries=3 -y install --no-install-recommends "$@"
        fi
    fi
}

export DEBIAN_FRONTEND=noninteractive

# Source /etc/os-release to get OS info
. /etc/os-release

check_packages ${PACKAGES}

rm -rf /var/lib/apt/lists/*
