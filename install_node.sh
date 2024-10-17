#!/bin/bash

## Install Node
NODE_VERSION=20.18.0
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bash_profile
nvm install $NODE_VERSION 
nvm use $NODE_VERSION
nvm alias default ${NODE_VERSION}
nvm cache clear