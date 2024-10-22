# Use the standard Amazon Linux base, provided by ECR/KaOS
# It points to the standard shared Amazon Linux image, with a versioned tag.
FROM amazonlinux:2023.5.20241001.1

RUN dnf update -y
RUN dnf --quiet --assumeyes groupinstall "Development Tools"
RUN dnf install -y \
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
  libpng-devel \
  giflib-devel \
  libexif \
  libexif-devel \
  cmake \
  autoconf \
  libtool \
  nasm \
  turbojpeg \
  turbojpeg-devel \
  libjpeg-turbo \
  libjpeg-turbo-devel

RUN dnf swap gnupg2-minimal gnupg2-full -y

RUN touch ~/.bash_profile

COPY install_node.sh /tmp/install_node.sh
RUN /tmp/install_node.sh

COPY install_ruby.sh /tmp/install_ruby.sh
RUN /tmp/install_ruby.sh

COPY install_libvips.sh /tmp/install_libvips.sh
RUN /tmp/install_libvips.sh

ENTRYPOINT [ "bash", "-c" ]
