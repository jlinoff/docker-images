#!/bin/ash
cd /mnt/share
export BOTO_CONFIG=/etc/boto.cfg
eval $*
