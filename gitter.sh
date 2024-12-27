#!/usr/bin/env bash
KERNEL_URI=$(wget http://kernel.org -O - | grep 'tar.xz' | head -1 | cut -d "=" -f2 | sed -e 's/\"//g' | sed -e 's/>.*//g')
KERNEL_FILE=$(echo $KERNEL_URI | sed -e 's/https.*\///g')
#wget $KERNEL_URI -O $KERNEL_FILE
aria2c -x16 --out=$KERNEL_FILE $KERNEL_URI
