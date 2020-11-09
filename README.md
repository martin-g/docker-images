[![CircleCI](https://circleci.com/gh/conda-forge/docker-images/tree/master.svg?style=shield)](https://circleci.com/gh/conda-forge/docker-images/tree/master)
[![Travis CI Build Status](https://travis-ci.com/conda-forge/docker-images.svg?branch=master)](https://travis-ci.com/conda-forge/docker-images)

# docker-images
Repository to host the Docker images files used in conda-forge

## Building and testing locally
It can be useful to build and test these images locally. For many images
this can be done by running `docker build` from the root-level of this
repo and passing in the path to the Dockerfile that you wish to build.
For example:

```sh
docker build --rm --build-arg CENTOS_VER=6 -f linux-anvil-comp7/Dockerfile .
```

However, certain images, such as those building CUDA, will need to have
environment variables passed in to be able to build. In this case, you
will want to use a command similar to the following:

```sh
docker build --rm --build-arg CENTOS_VER=6 --build-arg CUDA_VER=10.2 -f linux-anvil-cuda/Dockerfile .
```

## Environment variables

* `$CUDA_VER`: This is the cuda & cudatoolkit version that will be used. The
  value of this variable should be in major-minor for, e.g. `9.2`.
* `CENTOS_VER`: This is version of CentOS that the image should be built with.
  This is the major-only version number, e.g. `6` or `7`.  You'll usually want
  to build with the lowest working value for maximum compatibility.
