ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.18

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG S3QL_VERSION

ENV S3QL_VERSION=s3ql-5.1.3 \
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
                "apsw>=3.7.0" \
                cryptography \
                defusedxml \
                "dugong>=3.4,<4.0" \
                google-auth \
                google-auth-oauthlib \
                llfuse \
                "pyfuse3>=3.2.0,<4.0" \
                pytest \
                requests \
                "trio>=0.15" \
                && \
    \
   clone_git_repo "${S3QL_REPO_URL}" "${S3QL_VERSION}" && \
   export CI=true ; ./setup.py \
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
