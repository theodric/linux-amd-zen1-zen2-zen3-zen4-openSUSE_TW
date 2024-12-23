#!/bin/bash
git apply /usr/src/kernel_compiler_patch/more-ISA-levels-and-uarches-for-kernel-6.8-rc4+.patch;
make oldconfig;
make nconfig;
read -p "Ctrl-C now to break out, or press any key to build the kernel..."
sudo CXXFLAGS="-Ofast -pipe -march=znver2 -mtune=znver2 -fstack-protector-strong" CFLAGS="-Ofast -pipe -march=znver2 -mtune=znver2 -fstack-protector-strong" KCFLAGS="-Ofast -pipe -march=znver2 -mtune=znver2 -fstack-protector-strong" make -j $(($(nproc) + 1))
; make modules_install
; make install
