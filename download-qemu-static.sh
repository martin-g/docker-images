#!/bin/bash -ex

set -xe
if [ "$(uname -m)" == "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi

export QEMU_STATIC_VERSION=v7.2.0-1
qemu_aarch64_sha256=dce64b2dc6b005485c7aa735a7ea39cb0006bf7e5badc28b324b2cd0c73d883f
qemu_arm_sha256=9f07762a3cd0f8a199cb5471a92402a4765f8e2fcb7fe91a87ee75da9616a806
qemu_ppc64le_sha256=a8855b9a9cdefbe2163d9f7851fb71c77207d816451237caed616eb9b03229ac
qemu_s390x_sha256=a438ab2f7c2e0f0ffe63992bccedaf60d789cfb1849e035c0764bda7d9e73a9a

set +e
rm qemu-*-static
set -e

wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-aarch64-static
wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-arm-static
wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-ppc64le-static
wget https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_STATIC_VERSION}/qemu-s390x-static

sha256sum qemu-*-static

sha256sum qemu-aarch64-static | grep -F "${qemu_aarch64_sha256}"
sha256sum qemu-arm-static | grep -F "${qemu_arm_sha256}"
sha256sum qemu-ppc64le-static | grep -F "${qemu_ppc64le_sha256}"
sha256sum qemu-s390x-static | grep -F "${qemu_s390x_sha256}"

chmod +x qemu-aarch64-static
chmod +x qemu-arm-static
chmod +x qemu-ppc64le-static
chmod +x qemu-s390x-static
