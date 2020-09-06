#!/bin/bash
source ../include.sh || exit 1

prep() {

	sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg
	chroot_check $? 'sed 1'

	sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
           -i include/freetype/config/ftoption.h 
	chroot_check $? 'sed 2'
}

config() {
	./configure --prefix=/usr --enable-freetype-config --disable-static
	chroot_check $? 'configure'
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make install 
	chroot_check $? 'make install'
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

