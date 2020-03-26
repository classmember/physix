#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/opt/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

./configure --prefix=/tools
check $? "gawk: configure"

make
check $? "gawk: make"

make check
check $? "gawk: make check" NOEXIT

make install
check $? "gawk: make install"
