#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


su physix -c "./configure $XORG_CONFIG --with-appdefaultdir=/etc/X11/app-defaults"
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

