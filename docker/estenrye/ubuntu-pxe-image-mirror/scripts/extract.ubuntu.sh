#!/bin/bash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

LIVE_KERNEL_ROOT='/tftp/live/ubuntu/live-server-amd64'
IMAGE_ROOT='/tftp/images/ubuntu'
VERSION_PATTERN='[0-9][0-9]\.[0-9][0-9]$'
ISO_PATTERN='live-server-amd64\.iso$'

for ISOFILE in `ls ${IMAGE_ROOT} | grep ${VERSION_PATTERN} | xargs -I% find ${IMAGE_ROOT}/%/ -print | grep ${ISO_PATTERN}`
do
  VERSION=`basename $(dirname $ISOFILE)`

  echo "Creating directory ${LIVE_KERNEL_ROOT}/${VERSION}"
  mkdir -p "${LIVE_KERNEL_ROOT}/${VERSION}"
  rm -f ${LIVE_KERNEL_ROOT}/${VERSION}/ubuntu-live-server-amd64.iso

  echo "Linking ${ISOFILE} to ${LIVE_KERNEL_ROOT}/${VERSION}/ubuntu-live-server-amd64.iso"
  ln -s ${ISOFILE} ${LIVE_KERNEL_ROOT}/${VERSION}/ubuntu-live-server-amd64.iso

  echo "Copying ${ISO_MNT_ROOT}/${VERSION}/casper to directory ${LIVE_KERNEL_ROOT}/${VERSION}"
  7z e -tiso -o/${LIVE_KERNEL_ROOT}/${VERSION} -i\!casper/initrd -i\!casper/vmlinuz ${ISOFILE}
done
