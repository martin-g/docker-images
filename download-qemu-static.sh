#!/bin/bash -ex

set -xe
if [ "$(uname -m)" == "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi

export QEMU_STATIC_VERSION=v7.1.0-2
qemu_aarch64_sha256=5cf5d2cd8bc7a3ac9362c026b89f4bbce276ef59ddf73d3dfa02400acf607bc7
qemu_arm_sha256=1aca27a553410dd0cce1ec8e7df9acdc7a8c0df5cb93418662a1aec0cac76b60
qemu_ppc64le_sha256=f362bad43f8164a6ae12ea4fb8d058be3200ad6b28db1de65175b60c5b4227ca
qemu_s390x_sha256=9f95fd46e8017af02784e0d7a3f7a4ce10243c54bbbab2c2ed8a85b08311cb9a

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
