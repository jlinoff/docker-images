#!/bin/ash
cd /mnt/share
export BOTO_CONFIG=/etc/boto.cfg
if [ -f /etc/boto.cfg ] ; then
    mkdir ~/.aws
    cp /etc/boto.cfg ~/.aws/credentials
fi
eval $*
