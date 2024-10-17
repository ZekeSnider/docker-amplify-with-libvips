# This is an image that takes the AWS Amplify Docker file and just adds libvips. How I built it:
# - Get the Dockerfile in AWS Amplify Console
# - Add the libvips commands
# - Create a custom AWS Amplify Docker image (https://docs.aws.amazon.com/amplify/latest/userguide/custom-build-image.html) and publish it to Docker HUB (https://hub.docker.com/repository/docker/thegrizzlylabs/docker-amplify-with-libvips/general)
#   Note that to build the Linux image on Mac, you need to pass the platform flag: docker build --platform="linux/amd64"  -t amplify-with-libvips .
# - Point AWS Amplify to our Docker HUB image.

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
