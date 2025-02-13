#!/bin/bash

## Install Ruby
RUBY_VERSION=3.3.5
gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh

rvm install ${RUBY_VERSION}
rvm global ${RUBY_VERSION}
gem install bundler