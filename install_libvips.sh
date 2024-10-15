#!/bin/bash

## Install libvips
INSTALL_DIR=/usr/local
if [ ! -e ${INSTALL_DIR}/bin/vips ]; then
  VIPS_VERSION=8.15.2
  # MOZJPEG_VERSION=4.1.1
  # Optional dependencies
  dnf --quiet --assumeyes install 

  cd /tmp/
  wget https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz
  tar -xf vips-${VIPS_VERSION}.tar.xz
  cd vips-${VIPS_VERSION}
  meson setup build --prefix ${INSTALL_DIR}
  cd build
  meson compile # Takes ~2 mins on a t4g.micro
  meson install

  cd /tmp
  rm -rf /tmp/vips-${VIPS_VERSION}*

  echo "${INSTALL_DIR}/lib64" | tee /etc/ld.so.conf.d/local-lib64.conf
  ldconfig

  echo "Installed $(vips --version)"

  # dnf install nasm -y
  # cd /tmp/
  # wget https://github.com/mozilla/mozjpeg/archive/v${MOZJPEG_VERSION}.tar.gz
  # tar -xzf v${MOZJPEG_VERSION}.tar.gz
  # cd mozjpeg-${MOZJPEG_VERSION}
  # autoreconf -fiv
  # mkdir build && cd build
  # sh ../configure
  # make install
fi