#!/bin/bash -ex

set -xe
if [ "$(uname -m)" == "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi

export QEMU_STATIC_VERSION=v5.1.0-8
qemu_aarch64_sha256=58f25aa64f433225145226cc03a10b1177da8ece5c4a6b0fe38626c29093804a
qemu_arm_sha256=fa2d1f9794eac9c069b65d27b09ee0a12c82d2abac54434c531b9c8a497a611a
qemu_ppc64le_sha256=9f19aaf037a992dcfdb87eb8dafc03189d5b238398a2c2014e166c06a8586e4f

set +e
rm qemu-*-static
set -e

wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-aarch64-static
wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-arm-static
wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-ppc64le-static

sha256sum qemu-*-static

sha256sum qemu-aarch64-static | grep -F "${qemu_aarch64_sha256}"
sha256sum qemu-arm-static | grep -F "${qemu_arm_sha256}"
sha256sum qemu-ppc64le-static | grep -F "${qemu_ppc64le_sha256}"

chmod +x qemu-aarch64-static
chmod +x qemu-arm-static
chmod +x qemu-ppc64le-static
