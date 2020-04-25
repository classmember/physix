#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/opt/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

mv -v ../mpfr-4.0.2 mpfr
check $? "pull in mpfr"

mv -v ../gmp-6.2.0 gmp
check $? "pull in gmp"

mv -v ../mpc-1.1.0 mpc
check $? "pull in  mpc"

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $($BUILDROOT_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

sed -e '1161 s|^|//|' \
    -i libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc
check $? "sed: sanitizer_platform_limits_posix.cc"


mkdir -v build
cd       build

CC=$BUILDROOT_TGT-gcc                                    \
CXX=$BUILDROOT_TGT-g++                                   \
AR=$BUILDROOT_TGT-ar                                     \
RANLIB=$BUILDROOT_TGT-ranlib                             \
../configure                                       \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

check $? "GCC P2: Configure"

make -j8
check $? "GCC P2: make"

make install
check $? "GCC P2 make install"

ln -sfv gcc /tools/bin/cc
check $? "gcc P2: ln -sfv gcc /tools/bin/cc"



