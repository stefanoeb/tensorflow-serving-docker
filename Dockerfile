FROM ubuntu:16.04

MAINTAINER Stefano E. Bourscheid <stefano.bourscheid@gmail.com>

## Install all dependencies for tensorflow-serving
RUN apt-get update && apt-get install -y \
        build-essential \
        curl \
        git \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        mlocate \
        pkg-config \
        python-dev \
        python-numpy \
        python-pip \
        software-properties-common \
        swig \
        zip \
        zlib1g-dev \
        libcurl3-dev \
        openjdk-8-jdk\
        openjdk-8-jre-headless \
        wget \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install mock grpcio

ENV BAZELRC /root/.bazelrc
ENV BAZEL_VERSION 0.9.0

WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    curl -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE && \
    chmod +x bazel-*.sh && \
    ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    cd / && \
    rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    git clone --recursive https://github.com/stefanoeb/serving && \
    cd serving/tensorflow && \
    ./configure -n

## Bazel build
RUN cd serving && \
    bazel build -c opt //tensorflow_serving/...

CMD ["/bin/bash", "bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server"]