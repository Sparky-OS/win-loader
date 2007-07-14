
PACKAGE	:= win32-loader
VERSION	:= $(shell head -n 1 debian/changelog | sed -e "s/^$(PACKAGE) (\(.*\)).*/\1/g")

CC	:= i586-mingw32msvc-gcc -Os
STRIP	:= i586-mingw32msvc-strip

all: win32-loader.exe

win32-loader.exe: main.nsi checkspacefree.nsh maps.ini \
		templates/expert.ini templates/graphics.ini templates/custom.ini templates/warning.ini \
		cpuid/test64.dll systeminfo/systeminfo.dll swirl.ico license \
		contrib/grub.exe contrib/grub.pif contrib/grldr contrib/grldr.mbr \
		contrib/wget.exe
	$(MAKE) -C l10n
	makensis main.nsi
	du -h win32-loader.exe

contrib/grub.exe contrib/grub.pif contrib/grldr contrib/grldr.mbr contrib/wget.exe:
	@echo "Get the contrib tarball from http://goodbye-microsoft.com/pub/"
	@exit 1

license: license.in
	sed -e "s/@VERSION@/$(VERSION)/g" < $^ > $@

cpuid/test64.dll: cpuid/cpuid.c cpuid/plugin.c
	$(CC) -Wl,--file-alignment,512 $^ -shared -o $@
	$(STRIP) $@

systeminfo/systeminfo.dll: systeminfo/systeminfo.c
	$(CC) -Wl,--file-alignment,512 $^ -shared -o $@
	$(STRIP) $@

maps.ini: maps.ini.in /usr/share/iso-codes/iso_3166.tab
	cp maps.ini.in maps.ini
	echo -en "\n[countries]\n" >> maps.ini
	while read a b ; do echo "$$b=$$a" ; done < /usr/share/iso-codes/iso_3166.tab >> maps.ini

iso: win32-loader.iso
win32-loader.iso: win32-loader.exe win32-loader.ini autorun.inf \
  netboot/install.386/vmlinuz netboot/install.386/initrd.gz netboot/install.386/gtk/initrd.gz \
  netboot/install.amd/vmlinuz netboot/install.amd/initrd.gz netboot/install.amd/gtk/initrd.gz
	mkisofs -r -J -o $@ win32-loader.exe win32-loader.ini autorun.inf netboot

netboot/install.386/vmlinuz:
	mkdir -p netboot/install.386
	wget http://ftp.nl.debian.org/debian/dists/etch/main/installer-i386/current/images/netboot/debian-installer/i386/linux -O $@
netboot/install.386/initrd.gz:
	mkdir -p netboot/install.386
	wget http://ftp.nl.debian.org/debian/dists/etch/main/installer-i386/current/images/netboot/debian-installer/i386/initrd.gz -O $@
netboot/install.386/gtk/initrd.gz:
	mkdir -p netboot/install.386/gtk
	wget http://ftp.nl.debian.org/debian/dists/etch/main/installer-i386/current/images/netboot/gtk/debian-installer/i386/initrd.gz -O $@
netboot/install.amd/vmlinuz:
	mkdir -p netboot/install.amd
	wget http://ftp.nl.debian.org/debian/dists/etch/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux -O $@
netboot/install.amd/initrd.gz:
	mkdir -p netboot/install.amd
	wget http://ftp.nl.debian.org/debian/dists/etch/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz -O $@
netboot/install.amd/gtk/initrd.gz:
	mkdir -p netboot/install.amd/gtk
	wget http://ftp.nl.debian.org/debian/dists/etch/main/installer-amd64/current/images/netboot/gtk/debian-installer/amd64/initrd.gz -O $@

clean:
	$(MAKE) -C l10n clean
	rm -f cpuid/*.dll cpuid/*.exe systeminfo/*.dll win32-loader.exe win32-loader.iso *~ */*~ maps.ini license

distclean: clean
	rm -f debian/compat
	rm -rf netboot
