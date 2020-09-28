FROM ubuntu:18.04
MAINTAINER jmonlong@ucsc.edu

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ARG THREADS=4

## seqwish
RUN apt-get update && \
        apt-get -qqy install zlib1g zlib1g-dev libomp-dev && \
        apt-get -qqy install build-essential software-properties-common && \
        add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
        apt-get update > /dev/null && \
        apt-get -qqy install gcc-snapshot && \
        apt-get update > /dev/null && \
        apt-get -qqy install gcc-8 g++-8 && \
        update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 80 --slave /usr/bin/g++ g++ /usr/bin/g++-8 && \
        apt-get -qqy install cmake git

ARG seqwish_git_revision=9bbfa70145e79777fc12cff6d0bad65d545f39fd

WORKDIR /build

RUN git clone --recursive https://github.com/ekg/seqwish.git && \
        cd seqwish && \
        git checkout "$seqwish_git_revision" && \
        cmake -H. -Bbuild && \
        cmake --build build -- -j $THREADS

RUN apt-get -qy autoremove

ENV PATH /build/seqwish/bin:$PATH

ENV SEQWISH_COMMIT $seqwish_git_revision

WORKDIR /home
