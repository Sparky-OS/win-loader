export SHELL := bash

BUILD_DIR ?= build
MKDIR_P := mkdir -p
RMDIR := rmdir

# Targets that will always be run (as they depend on stuff from installed packages)
.PHONY: clean distclean test $(BUILD_DIR)/core.img $(BUILD_DIR)/g2ldr $(BUILD_DIR)/g2ldr.mbr $(BUILD_DIR)/loadlin.pif $(BUILD_DIR)/loadlin.exe $(BUILD_DIR)/pxe.lkrn

PACKAGE	:= win32-loader
VERSION	:= $(shell head -n 1 debian/changelog | sed -e "s/^$(PACKAGE) (\(.*\)).*/\1/g")
SOURCE_DATE_EPOCH	?= $(shell LC_ALL=C date +'%s')
FOUR_DIGITS_DATE	:= $(shell date -u +'%Y.%m.%d.%H%M' --date="@$(SOURCE_DATE_EPOCH)")

NSIS_CC		:= i686-w64-mingw32-gcc -Os -Xlinker --no-insert-timestamp
NSIS_STRIP	:= i686-w64-mingw32-strip
NSIS_CFLAGS	:= -Wl,--file-alignment,512 -Werror -D_WIN32_WINNT=0x0500

ICONSIZES       := 16 24 32 48 256

ifeq ($(wildcard /usr/i686-w64-mingw32/include/exdll.h), /usr/i686-w64-mingw32/include/exdll.h)
NSIS_CFLAGS	+= -DHAVE_EXDLL_H
else
NSIS_CFLAGS	+= -L/usr/i686-w64-mingw32/lib/nsis/ -lpluginapi-x86-ansi
endif

# Standard makensis call
MAKENSIS	:= makensis -V3

# Add to it some version'ing and date
MAKENSIS	+= -DVERSION=$(VERSION) -D4DIGITS_DATE=$(FOUR_DIGITS_DATE)

ifndef OUTFILE_NAME
OUTFILE_NAME	:= $(BUILD_DIR)/win32-loader.exe
endif
MAKENSIS	+= -D_OUTFILE_NAME=$(OUTFILE_NAME) -DBUILD_DIR=$(BUILD_DIR)

# Distributor/Company name (defaults to "The Debian Project")
ifdef COMPANY_NAME
MAKENSIS	+= -D_COMPANY_NAME=$(COMPANY_NAME)
endif

# Distribution name (ASCII only, please)
ifdef TARGET_DISTRO
MAKENSIS	+= -DTARGET_DISTRO=$(TARGET_DISTRO)
endif

# Standalone version : Not linked to a website with preseed.cfg
ifdef STANDALONE
MAKENSIS	+= -DNOCD=yes
OPTIONS_TXT	+= +net
endif

# Network version : Linked to a website with preseed.cfg
ifdef NETWORK_BASE_URL
# Embed the md5sum or sha1sum of the $(NETWORK_BASE_URL)/preseed.cfg file for enhanced security.
MAKENSIS	+= -DNETWORK_BASE_URL=$(NETWORK_BASE_URL) -DNOCD=yes -DNETWORK_BASE_URL_CHECKSUM=$(NETWORK_BASE_URL_CHECKSUM)
OPTIONS_TXT	+= +url
endif

# PXE version (which is standalone too)
ifdef PXE
MAKENSIS	+= -DPXE=yes -DNOCD=yes
OPTIONS_TXT	+= +pxe
endif

# Disabling the kFreeBSD download
ifndef NOT_ALLKERNELS
MAKENSIS	+= -DALLKERNELS=yes
OPTIONS_TXT	+= +kernels
endif

# Allowing the branch selection
ifdef DAILIES
MAKENSIS	+= -DDAILIES=yes
OPTIONS_TXT	+= +dailies
endif

ifdef OPTIONS_TXT
MAKENSIS	+= -DOPTIONS_TXT="$(OPTIONS_TXT)"
endif

# hard disk
GRUB_MODULES	+= biosdisk
# partmap
GRUB_MODULES	+= part_msdos part_gpt
# fs
GRUB_MODULES	+= fat ntfs ntfscomp
# used in our grub.cfg
GRUB_MODULES	+= search linux bsd multiboot vbe boot
# might be useful for debugging
GRUB_MODULES	+= minicmd cat cpuid chain halt help ls reboot
# useful for loading files from ISO images
GRUB_MODULES	+= loopback iso9660
ifndef NOT_ALLKERNELS
# gzio is needed for kFreeBSD
GRUB_MODULES    += gzio
endif
ifdef PXE
# Booting the pxe.lkrn requires linux16
GRUB_MODULES	+= linux16
endif

all: $(OUTFILE_NAME) $(BUILD_DIR)/g2ldr $(BUILD_DIR)/g2ldr.mbr

$(BUILD_DIR):
	$(MKDIR_P) $(BUILD_DIR)

core.img:
	grub-mkimage --output=$@ --prefix=/win32-loader --format=i386-pc $(GRUB_MODULES)

$(BUILD_DIR)/g2ldr: /usr/lib/grub/i386-pc/g2hdr.bin core.img | $(BUILD_DIR)
	cat $^ > $@

$(BUILD_DIR)/g2ldr.mbr: /usr/lib/grub/i386-pc/g2ldr.mbr | $(BUILD_DIR)
	cp $^ $@

$(BUILD_DIR)/loadlin.pif: genpif | $(BUILD_DIR)
	bash $^ > $@

$(BUILD_DIR)/loadlin.exe: /usr/lib/loadlin/loadlin.exe.gz | $(BUILD_DIR)
	gunzip -c $^ > $@

$(BUILD_DIR)/pxe.lkrn: /usr/lib/ipxe/ipxe.lkrn | $(BUILD_DIR)
	cp $^ $@

ifdef PXE
PXE_TARGETS = $(BUILD_DIR)/pxe.lkrn templates/ternary_choice.ini
else
PXE_TARGETS =
endif

templates/gtk.bmp: templates/gtk_orig.png
	convert $^ -resize 107x80 BMP3:$@

# Build icons out of the SVG source, force them being square
$(BUILD_DIR)/icon/swirl-%.png: icon/swirl.svg
	$(MKDIR_P) $(BUILD_DIR)/icon
	rsvg-convert -f png -h $* -w $* $^ > $@

# Build the icon out of the PNG icons
$(BUILD_DIR)/win32-loader.ico: $(ICONSIZES:%=$(BUILD_DIR)/icon/swirl-%.png)
	icotool -c -o $@ $^

$(OUTFILE_NAME): main.nsi maps.ini \
		templates/binary_choice.ini templates/graphics.ini templates/custom.ini templates/4_choices.ini \
		templates/gtk.bmp templates/text.bmp \
		$(BUILD_DIR)/plugins/cpuid/test64.dll \
		$(BUILD_DIR)/plugins/systeminfo/systeminfo.dll \
		$(BUILD_DIR)/plugins/string.dll \
		$(BUILD_DIR)/plugins/libgcrypt_hash.dll \
		$(PXE_TARGETS) $(BUILD_DIR)/win32-loader.ico \
		$(BUILD_DIR)/loadlin.pif $(BUILD_DIR)/loadlin.exe \
		$(BUILD_DIR)/g2ldr $(BUILD_DIR)/g2ldr.mbr
	find $^ -newermt "@$(SOURCE_DATE_EPOCH)" -print0 | xargs -0r touch --date="@$(SOURCE_DATE_EPOCH)"
	$(MKDIR_P) $(BUILD_DIR)/l10n
	$(MAKE) -C $(BUILD_DIR)/l10n -f $(CURDIR)/l10n/Makefile VPATH=$(CURDIR)/l10n
	$(MAKENSIS) main.nsi
	du -h $(OUTFILE_NAME)

test:
	for arch in win32 win64; do \
		$(CURDIR)/tests/run.sh $(realpath $(BUILD_DIR)) \
			$${arch} $(realpath $(BUILD_DIR)); \
	done

$(BUILD_DIR)/plugins:
	$(MKDIR_P) $@

$(BUILD_DIR)/plugins/cpuid/test64.dll: plugins/cpuid/cpuid.c plugins/cpuid/plugin.c
	$(MKDIR_P) $(dir $@)
	$(NSIS_CC) $^ $(NSIS_CFLAGS) -shared -o $@
	$(NSIS_STRIP) $@

$(BUILD_DIR)/plugins/systeminfo/systeminfo.dll: plugins/systeminfo/systeminfo.c
	$(MKDIR_P) $(dir $@)
	$(NSIS_CC) $^ $(NSIS_CFLAGS) -shared -o $@
	$(NSIS_STRIP) $@

$(BUILD_DIR)/plugins/string.dll: plugins/string.c | $(BUILD_DIR)/plugins
	$(NSIS_CC) $^ $(NSIS_CFLAGS) -shared -o $@
	$(NSIS_STRIP) $@

$(BUILD_DIR)/plugins/libgcrypt_hash.dll: plugins/libgcrypt_hash.c | $(BUILD_DIR)/plugins
	$(NSIS_CC) $^ $(NSIS_CFLAGS) -shared -static-libgcc /usr/i686-w64-mingw32/lib/libgcrypt.a /usr/i686-w64-mingw32/lib/libgpg-error.a /usr/i686-w64-mingw32/lib/libwsock32.a -o $@
	$(NSIS_STRIP) $@

iso: $(BUILD_DIR)/stable.iso $(BUILD_DIR)/daily.iso
$(BUILD_DIR)/stable.iso: \
  $(BUILD_DIR)/netboot/download-stable-stamp \
  $(BUILD_DIR)/netboot/stable/win32-loader.exe \
  $(BUILD_DIR)/netboot/stable/g2ldr \
  $(BUILD_DIR)/netboot/stable/g2ldr.mbr \
  $(BUILD_DIR)/netboot/stable/autorun.inf \
  $(BUILD_DIR)/netboot/stable/win32-loader.ini \
  $(NULL) | $(BUILD_DIR)
	genisoimage -r -J -o $@ $(BUILD_DIR)/netboot/stable

$(BUILD_DIR)/daily.iso: \
  $(BUILD_DIR)/netboot/download-daily-stamp \
  $(BUILD_DIR)/netboot/daily/win32-loader.exe \
  $(BUILD_DIR)/netboot/daily/g2ldr $(BUILD_DIR)/netboot/daily/g2ldr.mbr \
  $(BUILD_DIR)/netboot/daily/autorun.inf \
  $(BUILD_DIR)/netboot/daily/win32-loader.ini \
  $(NULL) | $(BUILD_DIR)
	genisoimage -r -J -o $@ $(BUILD_DIR)/netboot/daily

BASE_URL=http://deb.debian.org/debian/dists/stable/main
$(BUILD_DIR)/netboot/download-stable-stamp:
	$(MKDIR_P) $(BUILD_DIR)/netboot/stable/install.{386,amd}/gtk
	wget $(BASE_URL)/installer-i386/current/images/netboot/debian-installer/i386/linux \
		-O $(BUILD_DIR)/netboot/stable/install.386/vmlinuz
	wget $(BASE_URL)/installer-i386/current/images/netboot/debian-installer/i386/initrd.gz \
		-O $(BUILD_DIR)/netboot/stable/install.386/initrd.gz
	wget $(BASE_URL)/installer-i386/current/images/netboot/gtk/debian-installer/i386/initrd.gz \
		-O $(BUILD_DIR)/netboot/stable/install.386/gtk/initrd.gz
	wget $(BASE_URL)/installer-amd64/current/images/netboot/debian-installer/amd64/linux \
		-O $(BUILD_DIR)/netboot/stable/install.amd/vmlinuz
	wget $(BASE_URL)/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz \
		-O $(BUILD_DIR)/netboot/stable/install.amd/initrd.gz
	wget $(BASE_URL)/installer-amd64/current/images/netboot/gtk/debian-installer/amd64/initrd.gz \
		-O $(BUILD_DIR)/netboot/stable/install.amd/gtk/initrd.gz
	touch $@

$(BUILD_DIR)/netboot/download-daily-stamp:
	$(MKDIR_P) $(BUILD_DIR)/netboot/daily/install.{386,amd}/gtk
	wget https://d-i.debian.org/daily-images/i386/daily/netboot/debian-installer/i386/linux \
		-O $(BUILD_DIR)/netboot/daily/install.386/vmlinuz
	wget https://d-i.debian.org/daily-images/i386/daily/netboot/debian-installer/i386/initrd.gz \
		-O $(BUILD_DIR)/netboot/daily/install.386/initrd.gz
	wget https://d-i.debian.org/daily-images/i386/daily/netboot/gtk/debian-installer/i386/initrd.gz \
		-O $(BUILD_DIR)/netboot/daily/install.386/gtk/initrd.gz
	wget https://d-i.debian.org/daily-images/amd64/daily/netboot/debian-installer/amd64/linux \
		-O $(BUILD_DIR)/netboot/daily/install.amd/vmlinuz
	wget https://d-i.debian.org/daily-images/amd64/daily/netboot/debian-installer/amd64/initrd.gz \
		-O $(BUILD_DIR)/netboot/daily/install.amd/initrd.gz
	wget https://d-i.debian.org/daily-images/amd64/daily/netboot/gtk/debian-installer/amd64/initrd.gz \
		-O $(BUILD_DIR)/netboot/daily/install.amd/gtk/initrd.gz
	touch $@

$(BUILD_DIR)/netboot/stable/autorun.inf $(BUILD_DIR)/netboot/daily/autorun.inf: autorun.inf
	$(MKDIR_P) $(BUILD_DIR)/netboot/{stable,daily}
	todos < $< > $@

$(BUILD_DIR)/netboot/stable/win32-loader.ini $(BUILD_DIR)/netboot/daily/win32-loader.ini: win32-loader.ini
	$(MKDIR_P) $(BUILD_DIR)/netboot/{stable,daily}
	todos < $< > $@

$(BUILD_DIR)/netboot/stable/win32-loader.exe $(BUILD_DIR)/netboot/daily/win32-loader.exe: $(OUTFILE_NAME)
	$(MKDIR_P) $(BUILD_DIR)/netboot/{stable,daily}
	cp $^ $@

$(BUILD_DIR)/netboot/stable/% $(BUILD_DIR)/netboot/daily/%: $(BUILD_DIR)/%
	$(MKDIR_P) $(BUILD_DIR)/netboot/{stable,daily}
	cp $< $@

clean:
	if [ -d $(BUILD_DIR)/l10n ]; then $(MAKE) -C $(BUILD_DIR)/l10n -f ../../l10n/Makefile clean; $(RMDIR) $(BUILD_DIR)/l10n; fi
	rm -f $(BUILD_DIR)/plugins/cpuid/*.dll \
		$(BUILD_DIR)/plugins/cpuid/*.exe \
		$(BUILD_DIR)/plugins/systeminfo/*.dll \
		$(BUILD_DIR)/plugins/*.dll $(OUTFILE_NAME) \
		$(BUILD_DIR)/*.iso $(BUILD_DIR)/*~ $(BUILD_DIR)/*/*~ \
		$(BUILD_DIR)/core.img \
		$(BUILD_DIR)/g2ldr $(BUILD_DIR)/g2ldr.mbr \
		$(BUILD_DIR)/loadlin.pif $(BUILD_DIR)/loadlin.exe \
		$(BUILD_DIR)/pxe.lkrn $(BUILD_DIR)/icon/*.png \
		$(BUILD_DIR)/win32-loader.ico
	if [ -d $(BUILD_DIR)/icon ]; then $(RMDIR) $(BUILD_DIR)/icon; fi
	if [ -d $(BUILD_DIR)/plugins/cpuid ]; then $(RMDIR) $(BUILD_DIR)/plugins/cpuid; fi
	if [ -d $(BUILD_DIR)/plugins/systeminfo ]; then $(RMDIR) $(BUILD_DIR)/plugins/systeminfo; fi
	if [ -d $(BUILD_DIR)/plugins ]; then $(RMDIR) $(BUILD_DIR)/plugins; fi

distclean: clean
	rm -rf $(BUILD_DIR)/netboot
	if [ -d $(BUILD_DIR) ]; then $(RMDIR) $(BUILD_DIR); fi
