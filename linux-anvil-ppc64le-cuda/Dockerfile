# Note that this image doesn't cache cudatoolkit as it is not packaged by defaults.
# This docker image is meant for packages using CUDA driver and not for packages
# using the CUDA runtime.

ARG CUDA_VER
ARG CENTOS_VER
FROM nvidia/cuda-ppc64le:${CUDA_VER}-devel-centos${CENTOS_VER}

LABEL maintainer="conda-forge <conda-forge@googlegroups.com>"

# Add qemu in here so that we can use this image on regular linux hosts with qemu user installed
ADD qemu-ppc64le-static /usr/bin/qemu-ppc64le-static

# Set CUDA_VER during runtime.
ARG CUDA_VER
ARG CENTOS_VER
ENV CUDA_VER=${CUDA_VER} \
    CENTOS_VER=${CENTOS_VER}

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Set path to CUDA install.
ENV CUDA_HOME /usr/local/cuda

# bust the docker cache so that we always rerun the installs below
ADD http://www.randomtext.me/api/gibberish /opt/docker/etc/gibberish

# Remove outdated repo URLs
RUN rm -rf /etc/yum.repos.d/CentOS-*; fi
# Add the archived centos6 repo URL
ADD centos7-altarch-vault.repo /etc/yum.repos.d/vault.repo

# Resolves a nasty NOKEY warning that appears when using yum.
# Naming convention changed with cos8 - see:
# * https://lists.centos.org/pipermail/centos-devel/2019-September/017847.html
# * https://www.centos.org/keys/#project-keys
RUN if [ "$CENTOS_VER" -le "7" ]; then \
        rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${CENTOS_VER} && \
        rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-${CENTOS_VER}-ppc64le; \
    else \
        rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial; \
    fi

# Remove preinclude system compilers
RUN rpm -e --nodeps --verbose gcc gcc-c++

# Install basic requirements.
COPY scripts/yum_clean_all /opt/docker/bin/
RUN yum update -y --disablerepo=cuda && \
    yum install -y \
        bzip2 \
        sudo \
        tar \
        which \
        && \
    /opt/docker/bin/yum_clean_all

# Fix locale in CentOS8 images
# See https://github.com/CentOS/sig-cloud-instance-images/issues/154
RUN if [ "$CENTOS_VER" -ge "8" ]; then \
        yum install -y glibc-langpack-en \
        && \
        /opt/docker/bin/yum_clean_all; \
    fi

# Run common commands
COPY scripts/run_commands /opt/docker/bin/run_commands
RUN /opt/docker/bin/run_commands

# Download and cache new compiler packages.
# Should speedup installation of them on CIs.
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda activate && \
    conda create -n test --yes --quiet --download-only \
        conda-forge::binutils_impl_linux-ppc64le \
        conda-forge::binutils_linux-ppc64le \
        conda-forge::gcc_impl_linux-ppc64le \
        conda-forge::gcc_linux-ppc64le \
        conda-forge::gfortran_impl_linux-ppc64le \
        conda-forge::gfortran_linux-ppc64le \
        conda-forge::gxx_impl_linux-ppc64le \
        conda-forge::gxx_linux-ppc64le \
        conda-forge::libgcc-ng \
        conda-forge::libgfortran-ng \
        conda-forge::libstdcxx-ng && \
    conda remove --yes --quiet -n test --all && \
    conda clean -tiy && \
    chgrp -R lucky /opt/conda && \
    chmod -R g=u /opt/conda

# Download and cache CUDA related packages.
RUN if [[ "$CUDA_VER" == "9.2" || "$CUDA_VER" == "10.0" || "$CUDA_VER" == "10.1" ]]; then \
        echo "`cudatoolkit` not available for CUDA_VER<10.2"; \
    else \
        source /opt/conda/etc/profile.d/conda.sh && \
        conda activate && \
        conda create -n test --yes --quiet --download-only \
            conda-forge::cudatoolkit=${CUDA_VER} \
            && \
        conda remove --yes --quiet -n test --all && \
        conda clean -tiy && \
        chgrp -R lucky /opt/conda && \
        chmod -R g=u /opt/conda; \
    fi

# Add a file for users to source to activate the `conda`
# environment `root`. Also add a file that wraps that for
# use with the `ENTRYPOINT`.
COPY linux-anvil-ppc64le/entrypoint_source /opt/docker/bin/entrypoint_source
COPY scripts/entrypoint /opt/docker/bin/entrypoint

# Ensure that all containers start with tini and the user selected process.
# Activate the `conda` environment `root`.
# Provide a default command (`bash`), which will start if the user doesn't specify one.
ENTRYPOINT [ "/opt/conda/bin/tini", "--", "/opt/docker/bin/entrypoint" ]
CMD [ "/bin/bash" ]
