#!/bin/bash

dnf update -y
dnf --quiet --assumeyes groupinstall "Development Tools"
dnf install -y \
  gcc \
  make \
  bzip2 \
  openssl-devel \
  readline-devel \
  zlib-devel \
  git \
  wget \
  tar \
  libffi-devel \
  libyaml-devel \
  meson \
  pkgconf-pkg-config \
  expat-devel \
  glib2-devel \
  libjpeg-turbo-devel \
  libpng-devel \
  giflib-devel

## Install Node
NODE_VERSION=22.9.0
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bash_profile
source /root/.bash_profile
nvm install $VERSION_NODE_14 
nvm use $VERSION_NODE_14
# npm install -g yarn@${VERSION_YARN} sm grunt-cli bower vuepress
nvm alias default ${NODE_VERSION}
nvm cache clear

## Install Ruby
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
~/.rbenv/bin/rbenv init
source ~/.bash_profile
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

rbenv install 3.3.0
rbenv global 3.3.0
gem install bundler

## Install libvips
INSTALL_DIR=/usr/local
if [ ! -e ${INSTALL_DIR}/bin/vips ]; then
  VIPS_VERSION=8.15.2

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
fi