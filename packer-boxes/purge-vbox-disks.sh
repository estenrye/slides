#!/bin/bash

UUIDS=`vboxmanage list hdds | grep UUID | egrep -v Parent| awk '{print $2}'`
for u in $UUIDS
do
  vboxmanage closemedium disk $u --delete
done
