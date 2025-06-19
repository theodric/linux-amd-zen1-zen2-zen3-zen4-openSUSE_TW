#!/bin/bash
git apply /usr/src/kernel_compiler_patch/more-ISA-levels-and-uarches-for-kernel-6.8-rc4+.patch;
make oldconfig;
make nconfig;
read -p "Ctrl-C now to break out, or press any key to build the kernel..."

export CXXFLAGS="-Ofast -pipe -march=znver3 -mtune=znver3 -fstack-protector-strong"
export CFLAGS="-Ofast -pipe -march=znver3 -mtune=znver3 -fstack-protector-strong"
export KCFLAGS="-Ofast -pipe -march=znver3 -mtune=znver3 -fstack-protector-strong"
make -j $(($(nproc) + 1))
make modules_install
make install
