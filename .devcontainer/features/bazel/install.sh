#!/bin/sh
set -e
set -x

echo "Activating feature 'Bazel''"

VERSION_LATEST_LTS="8.2.1"

VERSION=${VERSION:-${VERSION_LATEST_LTS}}
echo "Selected version: $VERSION"

mkdir -p /tmp/bazel
cd /tmp/bazel
BAZEL=${VERSION}
wget https://github.com/bazelbuild/bazel/releases/download/$BAZEL/bazel-$BAZEL-installer-linux-x86_64.sh
bash bazel-$BAZEL-installer-linux-x86_64.sh --prefix=/usr/local/
cd /
rm -rf /tmp/bazel
