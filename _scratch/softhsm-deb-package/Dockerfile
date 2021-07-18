# Pull the Ubuntu 20.04 Focal image
FROM ubuntu:focal

# Specify Build Arguments
ARG version=2.6.1
ARG revision=0
ARG arch=amd64

# Had to ad this line to instal the tzdatta package dependency
# Solution found here:
# https://stackoverflow.com/questions/44331836/apt-get-install-tzdata-noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt update && apt install -y \
  ansible \
  autoconf \
  automake \
  botan \
  build-essential \
  libp11-kit-dev \
  libssl-dev \
  libtool \
  pkg-config \
  unzip

# Download zip archive of package source code
ADD https://github.com/opendnssec/SoftHSMv2/archive/refs/tags/${version}.zip /SoftHSM.zip

# Unzip Source Code
RUN unzip /SoftHSM.zip

# Change work diretory to unzipped source code
WORKDIR /SoftHSMv2-${version}

# Configure and Build Package files.
RUN sh ./autogen.sh \
  && ./configure \
    --disable-dependency-tracking \
    --prefix=/package/softhsm_${version}-${revision}_${arch} \
    --with-crypto-backend=openssl \
    --with-openssl=/usr \
  && make \
  && make install

WORKDIR /package

COPY templates /package/templates
COPY playbook.yml /package/playbook.yml

RUN ansible-playbook -i localhost, playbook.yml
