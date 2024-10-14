# This is an image that takes the AWS Amplify Docker file and just adds libvips. How I built it:
# - Get the Dockerfile in AWS Amplify Console
# - Add the libvips commands
# - Create a custom AWS Amplify Docker image (https://docs.aws.amazon.com/amplify/latest/userguide/custom-build-image.html) and publish it to Docker HUB (https://hub.docker.com/repository/docker/thegrizzlylabs/docker-amplify-with-libvips/general)
#   Note that to build the Linux image on Mac, you need to pass the platform flag: docker build --platform="linux/amd64"  -t amplify-with-libvips .
# - Point AWS Amplify to our Docker HUB image.

# Use the standard Amazon Linux base, provided by ECR/KaOS
# It points to the standard shared Amazon Linux image, with a versioned tag.
FROM amazonlinux:2023.5.20241001.1

# # Framework Versions
# ENV VERSION_NODE_8=8.12.0
# ENV VERSION_NODE_10=10.16.0
# ENV VERSION_NODE_12=12
# ENV VERSION_NODE_14=14
# ENV VERSION_NODE_16=16
# ENV VERSION_NODE_17=17
# ENV VERSION_NODE_DEFAULT=$VERSION_NODE_14
# ENV VERSION_RUBY_2_4=2.4.6
# ENV VERSION_RUBY_2_6=2.6.3
# ENV VERSION_RUBY_3_0=3.0.1
# ENV VERSION_BUNDLER=2.0.1
# ENV VERSION_RUBY_DEFAULT=$VERSION_RUBY_2_4
# ENV VERSION_HUGO=0.75.1
# ENV VERSION_YARN=1.22.0
# ENV VERSION_AMPLIFY=6.3.1

# # UTF-8 Environment
# ENV LANGUAGE en_US:en
# ENV LANG=en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

COPY install.sh /tmp/install.sh
RUN /tmp/install.sh

ENTRYPOINT [ "bash", "-c" ]
