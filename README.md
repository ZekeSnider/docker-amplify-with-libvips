# AWS Amplify Dockerfile with Libvips

This is a docker file for AWS Amplify with libvips dependencies included. It's specifically built for my use case of compiling my Jekyll blog using the [jekyll_picture_tag](https://github.com/rbuchberger/jekyll_picture_tag) gem. If you're using this gem it could be useful as-is, or as a starting point for forking your own modifications.

This dockerfile installs the following dependencies:
+ [Required dependencies for an AWS Amplify build image](https://docs.aws.amazon.com/amplify/latest/userguide/custom-build-image.html).
+ [libvips](https://www.libvips.org) with relevant extensions for JPEGs.
+ Ruby version 3.3.5

## How to use

### Building
1. Install docker
2. Clone this repo
3. `docker build --platform="linux/amd64" -t yourusernamehere/amplify-with-libvips .`

### Uploading
You can use Docker Hub to host your image, however there are [rate limits](https://docs.docker.com/docker-hub/download-rate-limit/) which you may run into when building your app. To avoid these, you can host your image in ECR. You'll want to create a new public image in ECR. The console should display the relevant instructions for you, but for posterity, they should be similar to:

1. `docker tag yourusername/amplify-with-libvips:latest public.ecr.aws/idhere/imagenamehere:latest`
2. `docker push public.ecr.aws/idhere/imagenamehere:latest`

### Using in AWS Amplify
Follow the instructions from the [AWS Amplify docs](https://docs.aws.amazon.com/amplify/latest/userguide/custom-build-image.html#configuring-a-custom-build-image)

### Debugging 
Access bash on the dockerfile locally to avoid long debugging cycles for your build process:
`docker run -it --entrypoint /bin/bash yourusernamehere/amplify-with-libvips:latest`

If you're debugging issues with libvips, this command will show you which extensions are currently built/loaded. `vips --vips-config`

## Acknowledgements

+ This repo is forked from [thegrizzlylabs/docker-amplify-with-libvips](https://github.com/thegrizzlylabs/docker-amplify-with-libvips) which was a great starting point.
+ [This Github comment](https://github.com/amazonlinux/amazon-linux-2023/issues/295#issuecomment-2332962084) provided the libvips installation bash script.

