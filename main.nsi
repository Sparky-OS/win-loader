; Debian-Installer Loader
; Copyright (C) 2007  Robert Millan <rmh@aybabtu.com>
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

; SetCompressor must _always_ be the first command
SetCompressor /SOLID lzma

; First is default
!include l10n/templates/en.nsh
!include l10n/templates/bg.nsh
!include l10n/templates/cs.nsh
!include l10n/templates/de.nsh
!include l10n/templates/es.nsh
!include l10n/templates/fi.nsh
!include l10n/templates/fr.nsh
!include l10n/templates/he.nsh
!include l10n/templates/it.nsh
!include l10n/templates/ja.nsh
!include l10n/templates/nl.nsh
!include l10n/templates/pt.nsh
!include l10n/templates/ru.nsh
!include l10n/templates/sk.nsh
!include l10n/templates/sv.nsh
!include l10n/templates/tr.nsh

Name $(program_name)
Icon "swirl.ico"
UninstallIcon "swirl.ico"
XPStyle on
OutFile "win32-loader.exe"

!include LogicLib.nsh
!include FileFunc.nsh
!insertmacro GetRoot
!insertmacro un.GetRoot

!addplugindir cpuid
!addplugindir systeminfo
!include checkspacefree.nsh
!include getwindowsversion.nsh

;--------------------------------

LicenseData $(license)
LicenseForceSelection checkbox

;--------------------------------

; Pages

Page license
Page custom ShowExpert
Page custom ShowGraphics
Page custom ShowCustom
Page instfiles
Page custom ShowWarning

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

Var /GLOBAL c
Var /GLOBAL d
Var /GLOBAL preseed

Function .onInit
  InitPluginsDir

  ; needed by: timezones, keymaps, languages
  File /oname=$PLUGINSDIR\maps.ini maps.ini

  ; default to English
  StrCpy $LANGUAGE ${LANG_ENGLISH}

  ; Language selection dialog
  Push ""
  Push ${LANG_BULGARIAN}
  Push Bulgarian
  Push ${LANG_CZECH}
  Push Czech
  Push ${LANG_DUTCH}
  Push Dutch
  Push ${LANG_ENGLISH}
  Push English
  Push ${LANG_FINNISH}
  Push Finnish
  Push ${LANG_FRENCH}
  Push French
  Push ${LANG_ITALIAN}
  Push Italian
  Push ${LANG_JAPANESE}
  Push Japanese
  Push ${LANG_GERMAN}
  Push German
  Push ${LANG_HEBREW}
  Push Hebrew
  Push ${LANG_PORTUGUESE}
  Push Portuguese
  Push ${LANG_RUSSIAN}
  Push Russian
  Push ${LANG_SPANISH}
  Push Spanish
  Push ${LANG_SLOVAK}
  Push Slovak
  Push ${LANG_SWEDISH}
  Push Swedish
  Push ${LANG_TURKISH}
  Push Turkish
  Push unsupported
  Push "-- Not in this list --"

  Push A ; A means auto count languages
         ; for the auto count to work the first empty push (Push "") must remain
  LangDLL::LangDialog "Choose language" "Please choose the language used for \
the installation process. This language will be the default language for the \
final system."

  Pop $LANGUAGE
  ${If} $LANGUAGE == "cancel"
    Abort
  ${Endif}

  ; Note: Possible API abuse here.  Nsis *seems* to fallback sanely to English
  ; when $LANGUAGE == "unsupported", so we'll use that to decide wether to
  ; preseed later.

  Var /GLOBAL unsupported_language
  ${If} $LANGUAGE == "unsupported"
    StrCpy $unsupported_language true
    ; Translators: your language is supported by d-i, but not yet by nsis.
    ; Please get your translation in nsis before translating win32-loader.
    MessageBox MB_OK "Because your language is not supported by this \
stage of the installer, English will be used for now.  On the second \
(and last) stage of the install process, you will be offered a much \
wider choice, where your language is more likely to be present."
  ${Else}
    StrCpy $unsupported_language false
  ${Endif}
FunctionEnd

Function ShowExpert
; Do initialisations as early as possible, but not before license has been
; accepted unless absolutely necessary.

; ********************************************** Initialise $preseed
  StrCpy $preseed "interface=auto"
; ********************************************** Initialise $c
  ; FIXME: this blurb is duplicated in the uninstaller.  keep in sync!
  ${GetRoot} $WINDIR $c

  StrCpy $INSTDIR "$c\debian"
  SetOutPath $INSTDIR

  ; Do space checks soon, because they're an abort condition
  ; we refuse to start the installer with less than 30 MiB
  StrCpy $0 30720 ; == 30 MiB
  StrCpy $1 $c
  Call CheckSpaceFunc
  IntCmp $2 1 +3
  MessageBox MB_OK $(not_enough_space_for_loader)
  Quit

  ; we need 3 GiB to install debian
  ; FIXME: maybe we should ask whether user wants dual boot or nuking windoze completely first
  StrCpy $0 3145728 ; == 3 GiB
  StrCpy $1 $c
  Call CheckSpaceFunc
  IntCmp $2 1 +2
  MessageBox MB_OK $(not_enough_space_for_debian)

  ; Windows version is another abort condition
  Var /GLOBAL windows_version
  Var /GLOBAL windows_boot_method
  Var /GLOBAL nsisdl_is_broken
  StrCpy $nsisdl_is_broken false
  Call GetWindowsVersion
  Pop $windows_version
  StrCpy $1 $windows_version 3
  ${If} $1 == "NT "
    StrCpy $nsisdl_is_broken true
    StrCpy $windows_boot_method ntldr
    Goto windows_version_ok
  ${Endif}
  ${If} $windows_version == "95"
  ${OrIf} $windows_version == "98"
    StrCpy $nsisdl_is_broken true
    StrCpy $windows_boot_method direct
    Goto windows_version_ok
  ${Endif}
  ${If} $windows_version == "2000"
  ${OrIf} $windows_version == "XP"
  ${OrIf} $windows_version == "2003"
    StrCpy $windows_boot_method ntldr
    Goto windows_version_ok
  ${Endif}
  ${If} $windows_version == "Vista"
    StrCpy $windows_boot_method bootmgr
    Goto windows_version_ok
  ${Endif}
  MessageBox MB_OK $(unsupported_version_of_windows)
  Quit
windows_version_ok:

  File /oname=$PLUGINSDIR\expert.ini	templates/expert.ini
  WriteINIStr $PLUGINSDIR\expert.ini "Field 1" "Text" $(expert1)
  WriteINIStr $PLUGINSDIR\expert.ini "Field 2" "Text" $(expert2)
  WriteINIStr $PLUGINSDIR\expert.ini "Field 3" "Text" $(expert3)
  InstallOptions::dialog $PLUGINSDIR\expert.ini

  Var /GLOBAL expert
  ReadINIStr $0 $PLUGINSDIR\expert.ini "Field 3" "State"
  ${If} $0 == "1"
    StrCpy $expert true
  ${Else}
    StrCpy $expert false
  ${Endif}
FunctionEnd

Function ShowGraphics
  File /oname=$PLUGINSDIR\graphics.ini	templates/graphics.ini
  ${If} $expert == false
    Return
  ${Endif}
  File /oname=$PLUGINSDIR\gtk.bmp	templates/gtk.bmp
  File /oname=$PLUGINSDIR\text.bmp	templates/text.bmp
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 1" "Text" $(graphics1)
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 2" "Text" "$PLUGINSDIR\gtk.bmp"
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 3" "Text" "$PLUGINSDIR\text.bmp"
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 4" "Text" $(graphics2)
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 5" "Text" $(graphics3)
  InstallOptions::dialog $PLUGINSDIR\graphics.ini
FunctionEnd

Function ShowCustom
; Gather all the missing information before ShowCustom is displayed

; ********************************************** Initialise arch + Preseed vga mode
  test64::get_arch
  Var /GLOBAL arch
  StrCpy $arch $0
  Var /GLOBAL gtk
  ReadINIStr $0 $PLUGINSDIR\graphics.ini "Field 4" "State"
  ${If} $0 == "1"
    StrCpy $gtk "gtk/"
    StrCpy $preseed "$preseed video=vesa:ywrap,mtrr vga=788"
  ${Else}
    StrCpy $preseed "$preseed vga=normal"
  ${EndIf}

; ********************************************** CD-based install
  ${GetRoot} $EXEDIR $d
  Var /GLOBAL linux
  Var /GLOBAL initrd
  Var /GLOBAL use_network
  StrCpy $use_network true
  IfFileExists $d\win32-loader.ini 0 cdless
  ReadINIStr $linux $d\win32-loader.ini "installer" "$arch/$gtklinux"
  ReadINIStr $initrd $d\win32-loader.ini "installer" "$arch/$gtkinitrd"
  ${If} $linux == ""
    Goto cdless
  ${Endif}
  ${If} $initrd == ""
    Goto cdless
  ${Endif}
  StrCpy $use_network false
cdless:

; ********************************************** Initialise base_url
  Var /GLOBAL base_url
  ${If} $use_network == true
    StrCpy $base_url "http://ftp.nl.debian.org/debian/dists/etch/main/installer-$arch/current/images/netboot/$gtkdebian-installer/$arch"
  ${Endif}

; ********************************************** Initialise proxy
  Var /GLOBAL proxy
  StrCpy $proxy ""
  ${If} $use_network == false
    Goto proxyless
  ${Endif}
  ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyEnable
  IntCmp $0 1 0 proxyless
  ReadRegStr $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyServer
  StrCmp $0 "" proxyless
  StrCpy $proxy "$0"
proxyless:

; ********************************************** preseed locale
  ${If} $unsupported_language == false
    ReadINIStr $0 $PLUGINSDIR\maps.ini "languages" "$LANGUAGE"
    ReadRegStr $1 HKCU "Control Panel\International" sCountry
    ReadINIStr $1 $PLUGINSDIR\maps.ini "countries" "$1"
    ${If} $0 != ""
      ${If} $1 != ""
        StrCpy $0 "$0_$1"
      ${Endif}
      StrCpy $preseed "$preseed locale=$0"
    ${Endif}
  ${Endif}

; ********************************************** preseed domain
  systeminfo::domain
  Pop $2
  Pop $0
  ${If} $2 != 0
    ${If} $0 == ""
      StrCpy $0 "localdomain"
    ${Endif}
    StrCpy $preseed "$preseed domain=$0"
  ${EndIf}

; ********************************************** preseed timezone
  ReadRegStr $0 HKLM SYSTEM\CurrentControlSet\Control\TimeZoneInformation StandardName
  ReadINIStr $0 $PLUGINSDIR\maps.ini "timezones" "$0"
  ${If} $0 != ""
    StrCpy $preseed "$preseed time/zone=$0"
  ${Endif}

; ********************************************** preseed keymap
  systeminfo::keyboard_layout
  Pop $0
  ; lower word is the locale identifier (higher word is a handler to the actual layout)
  IntOp $0 $0 & 0x0000FFFF
  IntFmt $0 "0x%04X" $0
  ReadINIStr $0 $PLUGINSDIR\maps.ini "keymaps" "$0"
  ; FIXME: do we need to support non-AT keyboards here?
  ${If} $0 != ""
    StrCpy $preseed "$preseed console-keymaps-at/keymap?=$0"
  ${Endif}

; ********************************************** preseed hostname
  systeminfo::hostname
  Pop $2
  Pop $0
  ${If} $2 != 0
    ${If} $0 == ""
      StrCpy $0 "debian"
    ${Endif}
    StrCpy $preseed "$preseed hostname?=$0"
  ${EndIf}

; ********************************************** preseed priority
  ${If} $expert == true
    StrCpy $preseed "$preseed priority=low"
  ${Endif}

; ********************************************** Display customisation dialog now
  Var /GLOBAL boot_ini
  StrCpy $boot_ini "$c\boot.ini"
  ${If} $expert == true
    File /oname=$PLUGINSDIR\custom.ini templates/custom.ini
    WriteINIStr $PLUGINSDIR\custom.ini "Field 1" "Text" $(custom1)
    WriteINIStr $PLUGINSDIR\custom.ini "Field 2" "Text" $(custom2)
    WriteINIStr $PLUGINSDIR\custom.ini "Field 3" "Text" $(custom3)
    WriteINIStr $PLUGINSDIR\custom.ini "Field 4" "Text" $(custom4)
    WriteINIStr $PLUGINSDIR\custom.ini "Field 5" "Text" $(custom5)
    WriteINIStr $PLUGINSDIR\custom.ini "Field 6" "State" "$proxy"
    WriteINIStr $PLUGINSDIR\custom.ini "Field 7" "State" "$boot_ini"
    WriteINIStr $PLUGINSDIR\custom.ini "Field 8" "State" "$base_url"
    WriteINIStr $PLUGINSDIR\custom.ini "Field 9" "State" "$preseed"
    InstallOptions::dialog $PLUGINSDIR\custom.ini
    ReadINIStr $proxy		$PLUGINSDIR\custom.ini "Field 6" "State"
    ReadINIStr $boot_ini	$PLUGINSDIR\custom.ini "Field 7" "State"
    ReadINIStr $base_url	$PLUGINSDIR\custom.ini "Field 8" "State"
    ReadINIStr $preseed		$PLUGINSDIR\custom.ini "Field 9" "State"
  ${Endif}

; do this inmediately after custom.ini, because proxy settings can be
; overriden there
; ********************************************** Preseed proxy
  ${If} $proxy == ""
    StrCpy $preseed "$preseed mirror/http/proxy="
  ${Else}
    StrCpy $preseed "$preseed mirror/http/proxy=http://$proxy/"
  ${Endif}
FunctionEnd

Function Download
    ; Base URL
    Pop $0
    ; Target dir
    Pop $1
    ; Filename
    Pop $2
    ${If} $nsisdl_is_broken == true
      ; NSISdl segfaults on this platform.  Untill it's fixed use wget.
      File /oname=$PLUGINSDIR\wget.exe "contrib/wget.exe"
      ; Do NOT, ever, let wget append its download to existing files!!
      Delete "$1\$2"
      SetOutPath "$1"
      ExecWait '"$PLUGINSDIR\wget.exe" -c $0/$2'
    ${Else}
      Var /GLOBAL nsisdl_proxy
      ${If} $proxy == ""
        StrCpy $nsisdl_proxy /NOIEPROXY
      ${Else}
        StrCpy $nsisdl_proxy "/PROXY $proxy"
      ${Endif}

      NSISdl::download /TRANSLATE $(nsisdl1) $(nsisdl2) $(nsisdl3) $(nsisdl4) $(nsisdl5) $(nsisdl6) $(nsisdl7) $(nsisdl8) $nsisdl_proxy $0/$2 $1\$2
      Pop $R0
      ${If} $R0 != "success"
        ${If} $R0 != "cancel"
           MessageBox MB_OK "$(error): $R0"
        ${EndIf}
        Quit
      ${EndIf}
    ${Endif}
FunctionEnd

Section "Debian-Installer Loader"

; ******************************************************************************
; ***************************************** THIS IS WHERE THE REAL ACTION STARTS
; ******************************************************************************

  ; Up to this point, we haven't modified host system.  The first modification
  ; we want to do is preparing the Uninstaller (so that in case something went
  ; wrong, our half-install can be undone).
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Debian-Installer Loader" "DisplayName" $(program_name)
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Debian-Installer Loader" "UninstallString" "$INSTDIR\uninstall.exe"

  ${If} $use_network == false
    ClearErrors
    StrCpy $0 "$EXEDIR\$linux"
    StrCpy $1 "$INSTDIR\linux"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK "$(error_copyfiles)"
      Quit
    StrCpy $0 "$EXEDIR\$initrd"
    StrCpy $1 "$INSTDIR\initrd.gz"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK "$(error_copyfiles)"
      Quit
  ${Else}
    Push "linux"
    Push "$INSTDIR"
    Push "$base_url"
    Call Download
    Push "initrd.gz"
    Push "$INSTDIR"
    Push "$base_url"
    Call Download
  ${Endif}

  FileOpen $0 $c\menu.lst w
  FileWrite $0 "\
find	--set-root /debian/initrd.gz$\n\
kernel	/debian/linux $preseed --$\n\
initrd	/debian/initrd.gz$\n"
  FileClose $0

; ********************************************** Needed for systems with compressed NTFS
  nsExec::Exec '"compact" /u $c\grldr $c\menu.lst $INSTDIR\linux $INSTDIR\initrd.gz'
  ; in my tests, uncompressing $c\menu.lst wasn't necessary, but better be safe than sorry

; ********************************************** Do bootloader last, because it's the most dangerous
  ${If} $windows_boot_method == ntldr
    File /oname=$c\grldr "contrib/grldr"
    ${Unless} ${FileExists} "$boot_ini"
      MessageBox MB_OK $(boot_ini_not_found)
      Quit
    ${Endif}
    SetFileAttributes "$boot_ini" NORMAL
    SetFileAttributes "$boot_ini" SYSTEM|HIDDEN
    WriteIniStr "$boot_ini" "operating systems" "$c\grldr" '"$(d-i)"'
  ${Endif}

  ${If} $windows_boot_method == direct
    File /oname=$INSTDIR\grub.exe "contrib/grub.exe"
    File /oname=$INSTDIR\grub.pif "contrib/grub.pif"
  ${Endif}

  ${If} $windows_boot_method == bootmgr
    File /oname=$c\grldr.mbr "contrib/grldr.mbr"
    File /oname=$c\grldr "contrib/grldr"
    ReadRegStr $0 HKLM "Software\Debian\Debian-Installer Loader" "bootmgr"
    ${If} $0 == ""
      nsExec::ExecToStack '"bcdedit" /create /d "$(d-i)" /application bootsector'
      Pop $0
      ${If} $0 != 0
        StrCpy $0 bcdedit.exe
        MessageBox MB_OK "$(error_exec)"
        Quit
      ${Endif}
      Pop $0 ; "The entry {id} was successfully created"
      StrCpy $0 $0 38 10
      ; $0 holds the boot id.  Write it down, both for installer idempotency
      ; and for uninstaller.
      WriteRegStr HKLM "Software\Debian\Debian-Installer Loader" "bootmgr" "$0"
    ${Endif}
    nsExec::Exec '"bcdedit" /set $0 device boot'
    nsExec::Exec '"bcdedit" /set $0 path \grldr.mbr'
    nsExec::Exec '"bcdedit" /displayorder $0 /addlast'
  ${Endif}
SectionEnd

Function ShowWarning
  Var /GLOBAL warning2
  ${If} $windows_boot_method == direct
    StrCpy $warning2 $(warning2_direct)
  ${Else}
    StrCpy $warning2 $(warning2_reboot)
  ${Endif}
  File /oname=$PLUGINSDIR\warning.ini templates/warning.ini
  WriteINIStr $PLUGINSDIR\warning.ini "Field 1" "Text" '$(warning1)$warning2$(warning3)'
  InstallOptions::dialog $PLUGINSDIR\warning.ini
FunctionEnd

Function .onInstSuccess
  ${If} $windows_boot_method == direct
    Exec '"$INSTDIR\grub.pif"'
  ${Else}
    MessageBox MB_YESNO|MB_ICONQUESTION $(reboot_now) IDNO +2
    Reboot
  ${Endif}
FunctionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  ; Initialise $c
  ; FIXME: this blurb is duplicated in the installer.  keep in sync!
  ${un.GetRoot} $WINDIR $c

  SetFileAttributes "$c\boot.ini" NORMAL
  SetFileAttributes "$c\boot.ini" SYSTEM|HIDDEN
  DeleteINIStr "$c\boot.ini" "operating systems" "$c\grldr"

  ReadRegStr $0 HKLM "Software\Debian\Debian-Installer Loader" "bootmgr"
  ${If} $0 != ""
    nsExec::Exec '"bcdedit" /delete $0'
    Pop $0
    ${If} $0 != 0
      StrCpy $0 bcdedit.exe
      MessageBox MB_OK "$(error_exec)"
    ${Endif}
  ${Endif}

  DeleteRegKey HKLM "Software\Debian\Debian-Installer Loader"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Debian-Installer Loader"
  Delete $c\grldr
  Delete $c\grldr.mbr
  Delete $c\menu.lst
  Delete $INSTDIR\grub.exe
  Delete $INSTDIR\grub.pif
  Delete $INSTDIR\linux
  Delete $INSTDIR\initrd.gz
  Delete /REBOOTOK $INSTDIR\Uninstall.exe
  RMDir /REBOOTOK $INSTDIR
SectionEnd
