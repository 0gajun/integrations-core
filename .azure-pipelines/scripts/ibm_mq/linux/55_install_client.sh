#!/bin/bash

# This script installs IBM MQ development version on the CI machines to be able to
# * Compile pymqi image
# * Run integration tests on the machine

set -ex

source "$DDEV_COMMON_SCRIPTS/common.sh"

TMP_DIR=/tmp/mq
MQ_URL=https://ddintegrations.blob.core.windows.net/ibm-mq/mqadv_dev90_linux_x86-64.tar.gz

if [ -e /opt/mqm/inc/cmqc.h ]; then
  echo "cmqc.h already exists, exiting"
  set +ex
  exit 0
fi

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  bash \
  bc \
  coreutils \
  curl \
  debianutils \
  findutils \
  gawk \
  gcc \
  grep \
  libc-bin \
  mount \
  passwd \
  procps \
  rpm \
  sed \
  tar \
  util-linux

mkdir -p $TMP_DIR
pushd $TMP_DIR

  with_retry curl --verbose -LO $MQ_URL

  tar -zxvf ./*.tar.gz
  pushd MQServer
    sudo ./mqlicense.sh -text_only -accept
    sudo rpm -ivh --force-debian *.rpm
    sudo /opt/mqm/bin/setmqinst -p /opt/mqm -i
  popd

popd

ls /opt/mqm
ls /opt/mqm/inc/

set +ex
