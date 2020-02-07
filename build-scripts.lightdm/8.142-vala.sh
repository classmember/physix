#!/bin/bash
source /physix/include.sh || exit 1
PATH=$PATH:/opt/rustc/bin/
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr'
chroot_check $? 'configure'

su physix -c 'make'
chroot_check $? 'make'

make install
chroot_check $? 'make install'

