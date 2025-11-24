#!/bin/bash
git apply /usr/src/linux-amd-zen1-zen2-zen3-openSUSE_TW/more-ISA-levels-and-uarches-for-kernel-6.8-rc4+.patch;
make oldconfig;
make nconfig;
read -p "Ctrl-C now to break out, or press any key to build the kernel..."
CXXFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong" CFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong" KCFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong" make -j $(($(nproc) + 1));
sudo make modules_install;
sudo make install;
