#!/bin/bash -ex

set -eux

if [ "$(uname -m)" == "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi

rm -f qemu-*-static

set -- aarch64 arm ppc64le s390x

version='8.1.2'
build='ds-1'
curl -sL \
    "http://ftp.debian.org/debian/pool/main/q/qemu/qemu-user-static_${version}+${build}_amd64.deb" |
    dpkg-deb --extract - ./deb-tmp
for arch; do
    mv "./deb-tmp/usr/bin/qemu-${arch}-static" ./
done
rm -rf ./deb-tmp
sha256sum --check << 'EOF'
f5c0f9f9e1499c6907bb293a250d9a015ea99e304654e0ab9fb38fd72efad7ce  qemu-aarch64-static
d7d7dcbaf1a2a58fc3a42465ae5a253b1cef1bcb08c6e8bb8dd22be8cfdaadeb  qemu-arm-static
79a95114ab8b6f7d6d570bd6eeb81d8ed57f4d5210503a826a13fa26502a3bee  qemu-ppc64le-static
e9c1ee2d9bf7e9aea9f59fd39837084f2c223676e656a5261f893b2de1b4e7bb  qemu-s390x-static
EOF

## If the download from Debian above has issues, we can use the one from Fedora below.
## (This needs bsdtar installed.)
# version='8.1.2'
# build='1.fc40'
# for arch; do
#     curl -sL \
#         "https://kojipkgs.fedoraproject.org//packages/qemu/${version}/${build}/x86_64/qemu-user-static-${arch/ppc64le/ppc}-${version}-${build}.x86_64.rpm" |
#         bsdtar -xf- --strip-components=3 ./usr/bin/qemu-${arch}-static
# done
# sha256sum --check << 'EOF'
# 955be1e1f1e0ed1f5180d35db92012be558bd860d90a189276b445b6ba9a46c9  qemu-aarch64-static
# 1cda1ab3586fb74ef99d7f1903a1cdf405432a41dd1da39841592f9cdc72aa44  qemu-arm-static
# 02b20dbf38e69a12d942c5fb1477160bab9da3fd428246e8fe011a2adced0fb6  qemu-ppc64le-static
# 9e7d91557640d5ff4209f5894d2e648373752bdb7b664038ceddc371044b79e4  qemu-s390x-static
# EOF
