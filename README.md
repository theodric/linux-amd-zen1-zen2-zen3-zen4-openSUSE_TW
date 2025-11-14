Kernel config files, originally based on Arch AUR packages [linux-amd-znver2](https://aur.archlinux.org/packages/linux-amd-znver2 "linux-amd-znver2") and [linux-amd-znver3](https://aur.archlinux.org/packages/linux-amd-znver3 "linux-amd-znver3"), with modifications to support openSUSE Tumbleweed on Zen1, Zen2, and Zen3 - primarily modifications around EFI booting. (Using the Arch config files unmodified on Fedora and openSUSE will result in a kernel that cannot boot.)

In theory, these architecture-specific optimizations will net you a whole 1% performance improvement over generic, according to the patch notes. Given the price of power these days, I'll take that over paying more to overclock.

You can build with these configs against the kernel source archives available at [kernel.org](https://kernel.org).

A script (`gitter.sh`), the contents of which were wholly stolen from https://gist.github.com/adityaka/c173d241f03d69853c47b2937fd310c6 (and then corrected) is provided to use `aria2c` (or `wget`, if you edit the script) to obtain the latest kernel source automatically.

**LATEST MAJOR CHANGES**

*IMPORTANT NOTE*

_AS OF 2025-11-14 I have finally got the damage from the migration from 6.14.11 to 6.15+ undone, and have begun shipping kernel configs based on the new source tree. graysky2's patches are essentially obsolete now, but they have continued to update them for 6.16+, and I've included the most recent patch in this repo. This is, as they say, primarily useful if you want to build an optimized kernel on a system with different hardware. Given the difference in build time between a 3700C and an 8840HS or 5700G, it's still useful to me.
Zen1 and Zen4 minconfigs are probably still useful for others, since I am targeting the Zen1 ThinkPad C13 Yoga (mrchromebox) and Zen4 ThinkPad P14s Gen5 AMD with those; both of which are stable targets. I include the necessary modules to enable docker (and therefore also iptables-nft *in legacy mode* [ffs docker, get your shit together]) and wireguard. I am currently building PREEMPT_RT because I got bored and decided to undermine performance on my systems, but you can switch that to something sensible before building.

_AS OF 2025-05-31 this is probably not useful to most people_ (apart from perhaps the zen4/ThinkPad P14s Gen5 AMD configs, since that is a commonly-available hardware set). I have redone the configs from scratch, starting with `make localmodconfig` as the foundation, then adding additional modules until I reach the required level of functionality for my use case. Additionally, 6.15.x breaks/obsoletes the patchset from graysky2 as 6.15 incorporates `-march=native` support. I will continue to back up my configs here.

_AS OF 2025-02-23 I have added support for zen4 and the ThinkPad P14s Gen5 AMD_

_AS OF 2024-12-16 I have added support for Zen1/Zen1+ "Renoir" systems, since I am now dailying a Zen1+ device_

_AS OF 2024-12-16 I have dropped support for Fedora because I have finished evicting Fedora from my life. All configs now support openSUSE Tumbleweed **only**_

**NOTES SPECIFIC TO MY CHANGES**

The basis for these configs is the linux-amd-znver3 config file from Arch. I diff this against the shipped config from openSUSE, and then add features/modules specified in openSUSE's config until my system boots and works normally, as well as adding sensible generic features to aid in compatibility across devices. The config is therefore closer to Arch's than openSUSE's, but matches neither exactly. All Intel-specific config that is not relevant to Intel devices on AMD platforms has been removed.

For each subsequent update, I `make oldconfig` this against the previous kernel version's config, and apply common sense in updating the config for general use. I may add support for additional new features if they sound cool.

I test-boot the new kernel on my own system before shipping the config file, so you may rely on that it at least #worksforme on these devices, all running the latest openSUSE Tumbleweed:

* Zen4: ThinkPad P14s Gen5 AMD, Ryzen 8840HS
* Zen3: Biostar B550T-Silver + Ryzen 5700G
* Zen2: ThinkPad E14 gen2 AMD, Ryzen 4700U
* Zen1: ThinkPad C13 gen1 AMD, Ryzen 3700C (3700U)

The Zen1 kernel has significant differences in available drivers due to the weird architecture of my Zen1 system, an ex-Chromebook, but should also work universally. If you'd like to run a 'MORPHIUS' Chromebook on openSUSE with the most optimized kernel possible, this is exactly what you need. The configs for Zen2 and Zen3 should be more-or-less interchangeable with each other, and are much closer to the Arch configs.

Unique to these kernel configs, I include everything in [CONFIG_PM_DEVFREQ](https://www.kernelconfig.io/config_pm_devfreq) which enables `powertop` to do its thing. Neither the openSUSE or Arch configs include this driver stack by default.

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

I have included a 'maker.sh' which I recommend you don't use, but have a look at it. I am an insaniac and build my kernels with `-Ofast -pipe -march=znver3 -mtune=znver3 -fstack-protector-strong`. So far, I'm getting away with it.

------------

**QnA**


    Q: Why does my Ryzen 7 4700U refuse to clock over 1.4GHz on any kernel 6.7.x, 
       but the same .config used on 6.6.x works fine?

    A: Scaling seems to be fucked up with schedutil. Switching to `ondemand` or another governor
       will work out better for you. I set `ondemand` by default in my configs as of 6.7-something.
       `cpupower frequency-set -f 2000000` should temporarily resolve this if you find yourself afflicted. 
       (You can check `cpupower frequency-info` to confirm.)

       On Fedora 38, for some reason, TLP does not always work on boot, but requires either the power
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
