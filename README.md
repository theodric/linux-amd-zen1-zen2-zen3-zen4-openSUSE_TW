Kernel config files, tracking Arch packages [linux-amd-znver2](https://aur.archlinux.org/packages/linux-amd-znver2 "linux-amd-znver2") and [linux-amd-znver3](https://aur.archlinux.org/packages/linux-amd-znver3 "linux-amd-znver3"), with modifications to support Fedora 38 (with Zen2) and openSUSE Tumbleweed (with Zen3) - primarily modifications around EFI booting. (Using the Arch config files unmodified on Fedora and openSUSE will result in a kernel that cannot boot.)

In theory, these architecture-specific optimizations will net you a whole 1% performance improvement over generic, according to the patch notes. Given the price of power these days, I'll take that over paying more to overclock.

You can build with these configs against the kernel source archives available at [kernel.org](https://kernel.org).

A script (`gitter.sh`), the contents of which were wholly stolen from https://gist.github.com/adityaka/c173d241f03d69853c47b2937fd310c6 (and then corrected) is provided to `wget` the latest kernel source automatically. At some point I'll figure out why it doesn't work with `aria2c`.

**LATEST UPDATE**

_AS OF 2024-12-16 I have added support for Zen1/Zen1+ "Renoir" systems, since I am now dailying a Zen1+ device_

_AS OF 2024-12-16 I have dropped support for Fedora because I have finished evicting Fedora from my life. All configs now support openSUSE Tumbleweed **only**_

**NOTES SPECIFIC TO MY CHANGES**

The basis for these configs is the linux-amd-znver3 config file from Arch. I diff this against the shipped config from openSUSE, and then add features/modules specified in openSUSE's config until my system boots and works normally, as well as adding sensible generic features to aid in compatibility across devices. The config is therefore closer to Arch's than openSUSE's, but matches neither exactly.

For each subsequent update, I `make oldconfig` this against the previous kernel version's config, and apply common sense in updating the config for general use. I may add support for additional new features if they sound cool.

I test-boot the new kernel on my own system before shipping the config file, so you may rely on that it at least #worksforme on these devices, all running the latest openSUSE Tumbleweed:

* Zen3: Biostar B550T-Silver + Ryzen 5700G
* Zen2: ThinkPad E14 gen2 AMD, Ryzen 4700U
* Zen1+: ThinkPad C13 gen1 AMD, Ryzen 3500C (3500U)

As of kernel 6.11.x I enable the option to configure your preemption model at boot (`PREEMPT_DYNAMIC`) on all zen generations. The default mode if you do not specify a model is is PREEMPT_VOLUNTARY, suitable for desktop usage.

Simply specify one of these options in your cmdline to select the preemption model appropriate to your use case:

`preempt=none`

`preempt=voluntary`

`preempt=full`

More information about this option is available at the [LKDDB](https://cateee.net/lkddb/web-lkddb/PREEMPT_DYNAMIC.html).



**USAGE**

To support additional microarchitectures in the Linux kernel, you need to apply graysky2's patch *before* building, or you will lose out on those sick 1% gainZ!

I have included a copy of graysky2's kernel 6.8+ uarch patch in this repo.

If you don't trust me, which you shouldn't, you can obtain the patch directly from them, here:
https://github.com/graysky2/kernel_compiler_patch

Per the Arch PKGBUILD, simply download the relevant patch file into the root of your unpacked kernel source and run `git apply nameofpatchfile` to apply the patch, 
 e.g. `git apply more-ISA-levels-and-uarches-for-kernel-6.8-rc4+.patch`

Copy the appropriate config file to /path/to/kernelsourcedirectory/.config, optionally configure the kernel further normally if you like (`make nconfig`), then build it with the `-march` flag appropriate to your system: znver1, znver2, znver3; e.g. `-march=znver3 -mtune=znver3`.

set:
`CXXFLAGS=-march=znver3 -mtune=znver3`
`CFLAGS="-march=znver3 -mtune=znver3"`
`KCFLAGS="-march=znver3 -mtune=znver3"` 

Build the kernel:
`make; make modules_install; make install`

then update /etc/default/grub if you want, and finally run 
`grub2-mkconfig -o /boot/grub2/grub.cfg`
to add the new kernel to your bootloader.

I have included a 'maker.sh' which I recommend you don't use, but have a look at it. I am an insaniac and build my kernels with `-Ofast -pipe -march=znver3 -mtune=znver3 -fstack-protector-strong`. So far, I'm getting away with it. \

------------

**QnA**


    Q: Why does my Ryzen 7 4700U refuse to clock over 1.4GHz on any kernel 6.7.x, 
       but the same .config used on 6.6.x works fine?

    A: Scaling seems to be fucked up by default for Zen2 on 6.7.x. 
       `cpupower frequency-set -f 2000000` should temporarily resolve this. 
       (You can check `cpupower frequency-info` to confirm.)

       On my system, for some reason, TLP does not work on boot, but requires either the power
       cable to be disconnected and reconnected, or else the service to be restarted to apply
       the configured frequency range and governor settings. Since the latter can be scripted,
       I've simply put this into my /etc/crontab: `@reboot sleep 5; sudo systemctl restart tlp`

       Why the above *isn't* an issue on 6.6.1 through 6.6.21 remains one of life's mysteries.

    Q: Will you provide other builds to support other combinations of architectures/distributions?
    A: Yes! If you buy me the computer to do it with.

    Q: I don't want to buy you a computer. Why won't you do it anyway?
    A: Pay me.

    Q: Hey, you kinda sound like an asshole, man!
    A: You catch on quickly. Your mother would be very proud.

-----------

You may also find this useful:

A script to [get Latest linux kernel path from kernel.org](https://gist.github.com/adityaka/c173d241f03d69853c47b2937fd310c6)
