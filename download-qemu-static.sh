#!/bin/bash -ex

set -eux

if [ "$(uname -m)" == "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi

rm -f qemu-*-static

version='8.1.2'
build='ds-1'
curl -sL \
    "http://ftp.debian.org/debian/pool/main/q/qemu/qemu-user-static_${version}+${build}_amd64.deb" |
    dpkg-deb --extract - ./deb-tmp
for arch in aarch64 arm ppc64le s390x; do
    mv "./deb-tmp/usr/bin/qemu-${arch}-static" ./
done
rm -rf ./deb-tmp
sha256sum --check << 'EOF'
f5c0f9f9e1499c6907bb293a250d9a015ea99e304654e0ab9fb38fd72efad7ce  qemu-aarch64-static
d7d7dcbaf1a2a58fc3a42465ae5a253b1cef1bcb08c6e8bb8dd22be8cfdaadeb  qemu-arm-static
79a95114ab8b6f7d6d570bd6eeb81d8ed57f4d5210503a826a13fa26502a3bee  qemu-ppc64le-static
e9c1ee2d9bf7e9aea9f59fd39837084f2c223676e656a5261f893b2de1b4e7bb  qemu-s390x-static
EOF
