Kernel config files, tracking Arch [linux-amd-znver2](https://aur.archlinux.org/packages/linux-amd-znver2 "linux-amd-znver2") and [linux-amd-znver3](https://aur.archlinux.org/packages/linux-amd-znver3 "linux-amd-znver3"), with modifications to support Zen2 on Fedora 38 and Zen3 on openSUSE Tumbleweed

**NOTE**
You will also need to obtain and apply the patch to support additional microarchitectures in the Linux kernel from graysky2

https://github.com/graysky2/kernel_compiler_patch

Per the Arch PKGBUILD, simply download the relevant patch file into the root of your unpacked kernel source and run `git apply nameofpatchfile` to apply the patch, 
 e.g. `git apply more-uarches-for-kernel-6.1.79-6.8-rc3.patch`

------------


**QnA**

    Q: Why does my Ryzen 7 4700U refuse to clock over 1.4GHz on any kernel 6.7.x, but the same .config used on 6.6.x works fine?
    A: Scaling seems to be fucked up by default. ` cpupower frequency-set -f 2000000 ` should temporarily resolve this.
       (You can check ` cpupower frequency-info ` to confirm)


    Q: Why Zen2 on Fedora 38 and Zen3 on openSUSE?
    A: Because my Zen2 laptop runs Fedora 38, and my Zen3 desktop runs openSUSE Tumbleweed.


    Q: Will you provide other builds to support other combinations of architectures/distributions?
    A: Yes! If buy me the computer to do it on.


    Q: I don't want to buy you a computer. Why not otherwise?
    A: Pay me.


    Q: Hey you kinda sound like an asshole, man.
    A: You catch on quickly. Your mother would be very proud.
