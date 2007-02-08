all: debian.exe

debian.exe: dil.nsi checkspacefree.nsh maps.ini \
		templates/graphics.ini templates/custom.ini templates/warning.ini \
		cpuid/test64.dll grub/grub grub/grldr swirl.ico
	makensis dil.nsi
	du -h debian.exe

cpuid/test64.dll: cpuid/cpuid.S cpuid/plugin.c
	i586-mingw32msvc-gcc -Os cpuid/cpuid.S cpuid/plugin.c -shared -o cpuid/test64.dll
	i586-mingw32msvc-strip cpuid/test64.dll

maps.ini: maps.ini.in /usr/share/iso-codes/iso_3166.tab
	cp maps.ini.in maps.ini
	echo -en "\n[countries]\n" >> maps.ini
	while read a b ; do echo "$$b=$$a" ; done < /usr/share/iso-codes/iso_3166.tab >> maps.ini

clean:
	rm -f cpuid/*.dll cpuid/*.exe debian.exe *~ */*~ maps.ini
