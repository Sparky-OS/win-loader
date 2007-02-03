all: debian.exe

debian.exe: dil.nsi warning.ini graphics.ini cpuid/test64.dll grub/grub grub/grldr swirl.ico
	makensis dil.nsi
	du -h debian.exe

cpuid/test64.dll: cpuid/cpuid.S cpuid/plugin.c
	i586-mingw32msvc-gcc -Os cpuid/cpuid.S cpuid/plugin.c -shared -o cpuid/test64.dll -I/usr/i586-mingw32msvc/include
	i586-mingw32msvc-strip cpuid/test64.dll

clean:
	rm -f cpuid/*.dll cpuid/*.exe debian.exe *~ */*~
