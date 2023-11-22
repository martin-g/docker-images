#!/bin/bash -ex

set -eux

if [ "$(uname -m)" = "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi

rm -f qemu-*-static

version='8.0.4'
build='dfsg-1ubuntu5'
curl -sL \
    "https://mirrors.edge.kernel.org/ubuntu/pool/universe/q/qemu/qemu-user-static_${version}%2B${build}_amd64.deb" |
    dpkg-deb --extract - ./deb-tmp
mv ./deb-tmp/usr/bin/qemu-*-static ./
rm -rf ./deb-tmp
sha256sum --check << 'EOF'
0312d58f7f2e5825c84d9c39e686da8a2714728c5ed5b872716f06e189e6bbaa  qemu-aarch64-static
6a9cc7d3d1a931811b1b91bbff83fb0bbfb0fb06cf8b7b980afad2ee55e3d06a  qemu-ppc64le-static
8cf7e22ce2038cb36d9d0a9c49118e76a7fe6ab5d9c27d595b6815acc4b3bfac  qemu-s390x-static
EOF
