#!/bin/bash
echo applying uarch patch:
git apply /usr/src/more-ISA-levels-and-uarches-for-kernel-6.16+.patch
echo done

echo extracting config:
zcat /proc/config.gz > .config
echo done

echo making oldconfig:
make oldconfig
echo done

echo entering kernel config:
make nconfig

echo setting compiler flags:
#export CXXFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong"
#export CFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong"
#export KCFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong"

export CXXFLAGS="-Ofast -pipe -march=native -mtune=native -fstack-protector-strong"
echo CXXFLAGS = "$CXXFLAGS"

export CFLAGS="-Ofast -pipe -march=native -mtune=native -fstack-protector-strong"
echo CFLAGS = "$CFLAGS"

export KCFLAGS="-Ofast -pipe -march=native -mtune=native -fstack-protector-strong"
echo KCFLAGS = "$KCFLAGS"

read -p "Build time. Ctrl-C now to break out, or press any key to build the kernel..."

time make -j $(($(nproc) + 1))
sudo make -j $(($(nproc) + 1)) modules_install
sudo make install

echo Updating bootloader config...
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo Done. Enjoy your new kernel. Happy computing.
echo.
