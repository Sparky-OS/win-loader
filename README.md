# win-loader

**For** people who use Windows: start Sparky Stereo OS from a Windows PC, safely and in your language.

**Status: forked, not changed yet.** Today this repository is Debian's win32-loader exactly as Debian left it.
Planned: renamed to win-loader and ported to 64-bit Windows, then the steps of [Try it on your Windows PC](https://github.com/Sparky-OS/sparky-stereo-os/blob/main/docs/guides/try-on-windows.en.md) in one program: save the BitLocker recovery key first, suspend BitLocker for the restarts it needs, and start the live session or the installer in the language you choose.

## Where it comes from

win32-loader is the Debian-Installer loader for Windows, started by Robert Millan in 2007 and maintained by the Debian Install System Team, with Didier Raboud and Thomas Gaugler among its authors (see [THANKS](THANKS) and [debian/copyright](debian/copyright)).
Its source is [salsa.debian.org/installer-team/win32-loader](https://salsa.debian.org/installer-team/win32-loader); Debian's branches and tags are kept here unchanged, and this `win-loader` branch carries our work.
Debian removed it from testing on 1 June 2025, and a removal request is open ([#1102724](https://bugs.debian.org/1102724)).

## Licence

GPL-3.0-or-later, as Debian's win32-loader; the parts listed in [debian/copyright](debian/copyright) keep their own licences (Expat, Zlib).

Sparky Stereo OS, Daniel Ramos's edition of SparkyLinux (by Paweł "pavroo" Pijanowski).
