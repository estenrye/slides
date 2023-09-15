#!/bin/bash
# LIVE_KERNEL_ROOT='/var/lib/pxeroot/live/ubuntu/live-server-amd64'
LIVE_KERNEL_ROOT='/tmp/live/ubuntu/live-serbver-amd64'
# ISO_MNT_ROOT=/mnt/iso
ISO_MNT_ROOT=/tmp/iso
# IMAGE_ROOT='/var/lib/pxeroot/images/ubuntu'
IMAGE_ROOT='/tmp/images/ubuntu'
VERSION_PATTERN='[0-9][0-9]\.[0-9][0-9]$'
ISO_PATTERN='live-server-amd64\.iso$'

for ISOFILE in `ls ${IMAGE_ROOT} | grep ${VERSION_PATTERN} | xargs -I% find ${IMAGE_ROOT}/% -print | grep ${ISO_PATTERN}`
do
  VERSION=`basename $(dirname $ISOFILE)`

  if [ -d "${LIVE_KERNEL_ROOT}/${VERSION}" ]; then
    echo "${LIVE_KERNEL_ROOT}/${VERSION} already exists, skipping..."
    continue
  fi

  echo "Creating directory ${LIVE_KERNEL_ROOT}/${VERSION}"
  mkdir -p "${LIVE_KERNEL_ROOT}/${VERSION}"

  echo "Creating directory ${ISO_MNT_ROOT}/${VERSION}"
  mkdir -p "${ISO_MNT_ROOT}/${VERSION}"

  echo "Mounting ${ISOFILE} to directory ${ISO_MNT_ROOT}/${VERSION}"
  mount -o loop,ro ${ISOFILE} ${ISO_MNT_ROOT}/${VERSION}

  echo "Copying ${ISO_MNT_ROOT}/${VERSION}/casper to directory ${LIVE_KERNEL_ROOT}/${VERSION}"
  cp -r ${ISO_MNT_ROOT}/${VERSION}/casper ${LIVE_KERNEL_ROOT}/${VERSION}

  echo "Unmounting ${ISO_MNT_ROOT}/${VERSION}"
  umount ${ISO_MNT_ROOT}/${VERSION}
done
