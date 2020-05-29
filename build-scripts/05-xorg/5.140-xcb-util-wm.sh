#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


./configure $XORG_CONFIG
chroot_check $? "xcb-util-wm : config"
make
chroot_check $? "xcb-util-wm : make "
make install
chroot_check $? "xcb-util-wm : make install"

