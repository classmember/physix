#!/bin/bash
source /opt/physix/include.sh || exit 1

cd nspr                                                     &&
sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in &&
sed -i 's#$(LIBRARY) ##'            config/rules.mk         &&
chroot_check $? "nspr : sed content "

su physix -c './configure --prefix=/usr \
            --with-mozilla \
            --with-pthreads \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit)'
chroot_check $? "nspr : configure"

su physix -c 'make'
chroot_check $? "nspr : make"

make install
chroot_check $? "nspr : make install"

