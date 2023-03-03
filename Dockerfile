# This is an image that takes the AWS Amplify Docker file and just adds libvips. How I built it:
# - Get the Dockerfile in AWS Amplify Console
# - Add the libvips commands
# - Create a Docker package and publish it to Amazon ECR public (see https://docs.aws.amazon.com/AmazonECR/latest/public/public-getting-started.html).
#   Note that to build the Linux image on Mac, you need to pass the platform flag: docker build --platform="linux/amd64"  -t amplify-with-libvips .

# Use the standard Amazon Linux base, provided by ECR/KaOS
# It points to the standard shared Amazon Linux image, with a versioned tag.
FROM amazonlinux:2

# https://docs.docker.com/engine/reference/builder/#maintainer-deprecated
LABEL maintainer="Amazon AWS"

# Framework Versions
ENV VERSION_NODE_8=8.12.0
ENV VERSION_NODE_10=10.16.0
ENV VERSION_NODE_12=12
ENV VERSION_NODE_14=14
ENV VERSION_NODE_16=16
ENV VERSION_NODE_17=17
ENV VERSION_NODE_DEFAULT=$VERSION_NODE_14
ENV VERSION_RUBY_2_4=2.4.6
ENV VERSION_RUBY_2_6=2.6.3
ENV VERSION_RUBY_3_0=3.0.1
ENV VERSION_BUNDLER=2.0.1
ENV VERSION_RUBY_DEFAULT=$VERSION_RUBY_2_4
ENV VERSION_HUGO=0.75.1
ENV VERSION_YARN=1.22.0
ENV VERSION_AMPLIFY=6.3.1

# UTF-8 Environment
ENV LANGUAGE en_US:en
ENV LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Install OS packages
RUN touch ~/.bashrc
RUN yum -y update && \
    yum -y install \
        alsa-lib-devel \
        autoconf \
        automake \
        bzip2 \
        bison \
        bzr \
        cmake \
        expect \
        fontconfig \
        git \
        gcc-c++ \
        GConf2-devel \
        gtk2-devel \
        gtk3-devel \
        libnotify-devel \
        libpng \
        libpng-devel \
        libffi-devel \
        libtool \
        libX11 \
        libXext \
        libxml2 \
        libxml2-devel \
        libXScrnSaver \
        libxslt \
        libxslt-devel \
        libyaml \
        libyaml-devel \
        make \
        nss-devel \
        openssl-devel \
        openssh-clients \
        patch \
        procps \
        python3 \
        python3-devel \
        readline-devel \
        sqlite-devel \
        tar \
        tree \
        unzip \
        wget \
        which \
        xorg-x11-server-Xvfb \
        zip \
        zlib \
        zlib-devel \
    yum clean all && \
    rm -rf /var/cache/yum

## Install python3.9
RUN wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tgz
RUN tar xvf Python-3.9.0.tgz
WORKDIR Python-3.9.0
RUN ./configure --enable-optimizations --prefix=/usr/local
RUN make altinstall

## Install Node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
RUN /bin/bash -c ". ~/.nvm/nvm.sh && \
	nvm install $VERSION_NODE_14 && nvm use $VERSION_NODE_14 && \
	npm install -g yarn@${VERSION_YARN} sm grunt-cli bower vuepress && \
	nvm alias default ${VERSION_NODE_DEFAULT} && nvm cache clear"

# Handle yarn for any `nvm install` in the future
RUN echo "yarn@${VERSION_YARN}" > /root/.nvm/default-packages

## Install Ruby 3.0.x
## https://github.com/rvm/rvm/issues/5096 | https://rvm.io/rvm/security#install-our-keys - The old keyserver is no longer available
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && 	curl -sL https://get.rvm.io | bash -s -- --with-gems="bundler"

ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /bin/bash --login -c "\
	rvm install $VERSION_RUBY_3_0 && rvm use $VERSION_RUBY_3_0 && gem install bundler -v $VERSION_BUNDLER && gem install jekyll && \
	rvm cleanup all"

## Install awscli
# RUN /bin/bash -c "pip3.9 install awscli && rm -rf /var/cache/apk/*"

## Install SAM CLI
# RUN /bin/bash -c "pip3.9 install aws-sam-cli"

## Install AWS Amplify CLI for all node versions
# RUN /bin/bash -c ". ~/.nvm/nvm.sh && nvm use ${VERSION_NODE_8} && \
#     npm config set user 0 && npm config set unsafe-perm true && \
# 	npm install -g @aws-amplify/cli@${VERSION_AMPLIFY}"
# RUN /bin/bash -c ". ~/.nvm/nvm.sh && nvm use ${VERSION_NODE_10} && \
#     npm config set user 0 && npm config set unsafe-perm true && \
# 	npm install -g @aws-amplify/cli@${VERSION_AMPLIFY}"
# RUN /bin/bash -c ". ~/.nvm/nvm.sh && nvm use ${VERSION_NODE_12} && \
#     npm config set user 0 && npm config set unsafe-perm true && \
# 	npm install -g @aws-amplify/cli@${VERSION_AMPLIFY}"
# RUN /bin/bash -c ". ~/.nvm/nvm.sh && nvm use ${VERSION_NODE_14} && \
#     npm config set user 0 && npm config set unsafe-perm true && \
# 	npm install -g @aws-amplify/cli@${VERSION_AMPLIFY}"
# RUN /bin/bash -c ". ~/.nvm/nvm.sh && nvm use ${VERSION_NODE_16} && \
#     npm config set user 0 && npm config set unsafe-perm true && \
# 	npm install -g @aws-amplify/cli@${VERSION_AMPLIFY}"
# RUN /bin/bash -c ". ~/.nvm/nvm.sh && nvm use ${VERSION_NODE_17}  && \
#     npm config set user 0 && npm config set unsafe-perm true && \
# 	npm install -g @aws-amplify/cli@${VERSION_AMPLIFY}"

## Environment Setup
RUN echo export PATH="/usr/local/rvm/gems/ruby-${VERSION_RUBY_DEFAULT}/bin:\
/usr/local/rvm/gems/ruby-${VERSION_RUBY_DEFAULT}@global/bin:\
/usr/local/rvm/rubies/ruby-${VERSION_RUBY_DEFAULT}/bin:\
/usr/local/rvm/bin:\
/root/.nvm/versions/node/${VERSION_NODE_DEFAULT}/bin:\
$(python3.9 -m site --user-base)/bin:\
$PATH" >> ~/.bashrc && \
    echo export GEM_PATH="/usr/local/rvm/gems/ruby-${VERSION_RUBY_DEFAULT}" >> ~/.bashrc && \
     echo "nvm use ${VERSION_NODE_DEFAULT} 1> /dev/null" >> ~/.bashrc && \
     echo "export PATH=$PATH:/root/.dotnet/tools" >> ~/.bashrc

# Install libvips needed for latest versions of jekyll_picture_tag
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum -y install yum-utils
RUN yum-config-manager --enable remi
RUN yum -y install vips vips-devel vips-tools

ENTRYPOINT [ "bash", "-c" ]
