#!/bin/bash -ex

set -xe
if [ "$(uname -m)" == "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi

export QEMU_STATIC_VERSION=v6.1.0-6
qemu_aarch64_sha256=a46e431ce84a904fbce2f7c4e7017344ce507cdecc20e784edf9ab6806d08130
qemu_arm_sha256=e9579ab10fe5ed2a5e967bac71b7f20503e5849ab48b9e911b052a97d5dc273f
qemu_ppc64le_sha256=d914794967e3e514cff722df1602f89aa7c38ad59dcbadbc34904fe926e912e0
qemu_s390x_sha256=20d03b3bceaf07efafa0b626ea75dd7443ecbf645989f1d02ba398392c2b7003

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
