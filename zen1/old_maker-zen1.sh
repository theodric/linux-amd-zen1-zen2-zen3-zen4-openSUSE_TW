#!/bin/bash
git apply /usr/src/linux-amd-zen1-zen2-zen3-openSUSE_TW/more-ISA-levels-and-uarches-for-kernel-6.8-rc4+.patch;
make oldconfig;
make nconfig;
read -p "Ctrl-C now to break out, or press any key to build the kernel..."

export CXXFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong"
export CFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong"
export KCFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong"

CXXFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong" CFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong" KCFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fstack-protector-strong" make -j $(($(nproc) + 1));
sudo make modules_install;
sudo make install;


OR

make -j$(($(nproc)+1)) \
  KCFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fno-stack-protector -ftree-vectorize -funroll-loops -fno-math-errno -g0 -fomit-frame-pointer -w" \
  KBUILD_CFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fno-stack-protector -ftree-vectorize -funroll-loops -fno-math-errno -g0 -fomit-frame-pointer -w" \
  CFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fno-stack-protector -ftree-vectorize -funroll-loops -fno-math-errno -g0 -fomit-frame-pointer -w" \
  CXXFLAGS="-Ofast -pipe -march=znver1 -mtune=znver1 -fno-stack-protector -ftree-vectorize -funroll-loops -fno-math-errno -g0 -fomit-frame-pointer -w" \
  HOSTCFLAGS="" HOSTCXXFLAGS=""
