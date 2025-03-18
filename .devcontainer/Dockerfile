ARG VARIANT=24.04
FROM ubuntu:${VARIANT}
RUN set -eux;\
    userdel -r ubuntu;\
    apt-get update;\
    export DEBIAN_FRONTEND=noninteractive; apt-get install -y --no-install-recommends\
  ca-certificates\
  curl\
  git\
  unzip\
  wget\
  xz-utils\
;\
    apt-get autoremove -y; apt-get clean -y ; apt-get clean; rm -rf /var/lib/apt/lists/*;\
    echo DONE
