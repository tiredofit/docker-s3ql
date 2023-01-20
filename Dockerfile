ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.17

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG S3QL_VERSION

ENV S3QL_VERSION=release-4.0.0 \
    S3QL_REPO_URL=https://github.com/s3ql/s3ql \
    IMAGE_NAME="tiredofit/s3ql" \
    IMAGE_REPO_URL="https://github.com/tiredofit/s3ql/"

RUN source assets/functions/00-container && \
    set -x && \
    \
    package update && \
    package upgrade && \
    package install .s3ql-build-deps \
                    attr-dev \
                    build-base \
                    cython \
                    fuse-dev \
                    fuse3-dev  \
                    git \
                    linux-headers \
                    openssl-dev \
                    python3-dev \
                    py3-pip \
                    py3-setuptools \
                    sqlite-dev \
                    && \
    \
    package install .s3ql-run-deps \
                    fuse3 \
                    python3 \
                    && \
    \
    pip3 install \
                apsw \
                cryptography \
                defusedxml \
                dugong \
                google-auth \
                google-auth-oauthlib \
                llfuse \
                pyfuse3 \
                pytest \
                requests \
                && \
    \
    clone_git_repo "${S3QL_REPO_URL}" "${S3QL_VERSION}" && \
    ./setup.py \
                build_cython \
                build_ext \
                --inplace \
                install \
                && \
    \
    mkdir -p /usr/share/s3ql && \
    cp -R contrib /usr/share/s3ql && \
    \
    package remove .s3ql-build-deps && \
    package cleanup && \
    rm -rf /root/.cache \
           /root/.cache \
           /usr/src/*

COPY install /
