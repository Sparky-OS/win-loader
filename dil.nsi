; Debian-Installer Loader
; Copyright © 2007  Robert Millan <rmh@aybabtu.com>
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along
; with this program; if not, write to the Free Software Foundation, Inc.,
; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

; SetCompressor must _always_ be the first command
SetCompressor /SOLID lzma
Name "Debian-Installer Loader"
Icon "swirl.ico"
UninstallIcon "swirl.ico"
XPStyle on
OutFile "debian.exe"

; will need this for vista
;RequestExecutionLevel highest

!include LogicLib.nsh
!include FileFunc.nsh
!insertmacro GetRoot
!insertmacro un.GetRoot

!addplugindir cpuid
!include checkspacefree.nsh

; First is default
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Albanian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Arabic.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Basque.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Belarusian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Bosnian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Breton.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Bulgarian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Catalan.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Croatian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Czech.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Danish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Dutch.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Estonian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Farsi.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Finnish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\French.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\German.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Greek.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Hebrew.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Hungarian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Icelandic.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Indonesian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Irish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Italian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Japanese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Korean.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Kurdish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Latvian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Lithuanian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Luxembourgish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Macedonian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Malay.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Mongolian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Norwegian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Polish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\PortugueseBR.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Portuguese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Romanian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SerbianLatin.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Serbian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Slovak.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Slovenian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Spanish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Swedish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Thai.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\TradChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Turkish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Ukrainian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Welsh.nlf"

; License
; Please see license/DO-NOT-TRANSLATE

LicenseLangString license ${LANG_ALBANIAN} license\en.txt
LicenseLangString license ${LANG_ARABIC} license\en.txt
LicenseLangString license ${LANG_BASQUE} license\en.txt
LicenseLangString license ${LANG_BELARUSIAN} license\en.txt
LicenseLangString license ${LANG_BOSNIAN} license\en.txt
LicenseLangString license ${LANG_BRETON} license\en.txt
LicenseLangString license ${LANG_BULGARIAN} license\en.txt
LicenseLangString license ${LANG_CATALAN} license\ca.txt
LicenseLangString license ${LANG_CROATIAN} license\en.txt
LicenseLangString license ${LANG_CZECH} license\en.txt
LicenseLangString license ${LANG_DANISH} license\en.txt
LicenseLangString license ${LANG_DUTCH} license\en.txt
LicenseLangString license ${LANG_ENGLISH} license\en.txt
LicenseLangString license ${LANG_ESTONIAN} license\en.txt
LicenseLangString license ${LANG_FARSI} license\en.txt
LicenseLangString license ${LANG_FINNISH} license\en.txt
LicenseLangString license ${LANG_FRENCH} license\en.txt
LicenseLangString license ${LANG_GERMAN} license\en.txt
LicenseLangString license ${LANG_GREEK} license\en.txt
LicenseLangString license ${LANG_HEBREW} license\en.txt
LicenseLangString license ${LANG_HUNGARIAN} license\en.txt
LicenseLangString license ${LANG_ICELANDIC} license\en.txt
LicenseLangString license ${LANG_INDONESIAN} license\en.txt
LicenseLangString license ${LANG_IRISH} license\en.txt
LicenseLangString license ${LANG_ITALIAN} license\en.txt
LicenseLangString license ${LANG_JAPANESE} license\en.txt
LicenseLangString license ${LANG_KOREAN} license\en.txt
LicenseLangString license ${LANG_KURDISH} license\en.txt
LicenseLangString license ${LANG_LATVIAN} license\en.txt
LicenseLangString license ${LANG_LITHUANIAN} license\en.txt
LicenseLangString license ${LANG_LUXEMBOURGISH} license\en.txt
LicenseLangString license ${LANG_MACEDONIAN} license\en.txt
LicenseLangString license ${LANG_MALAY} license\en.txt
LicenseLangString license ${LANG_MONGOLIAN} license\en.txt
LicenseLangString license ${LANG_NORWEGIAN} license\en.txt
LicenseLangString license ${LANG_POLISH} license\en.txt
LicenseLangString license ${LANG_PORTUGUESEBR} license\en.txt
LicenseLangString license ${LANG_PORTUGUESE} license\en.txt
LicenseLangString license ${LANG_ROMANIAN} license\en.txt
LicenseLangString license ${LANG_RUSSIAN} license\en.txt
LicenseLangString license ${LANG_SERBIANLATIN} license\en.txt
LicenseLangString license ${LANG_SERBIAN} license\en.txt
LicenseLangString license ${LANG_SIMPCHINESE} license\en.txt
LicenseLangString license ${LANG_SLOVAK} license\en.txt
LicenseLangString license ${LANG_SLOVENIAN} license\en.txt
LicenseLangString license ${LANG_SPANISH} license\es.txt
LicenseLangString license ${LANG_SWEDISH} license\en.txt
LicenseLangString license ${LANG_THAI} license\en.txt
LicenseLangString license ${LANG_TRADCHINESE} license\en.txt
LicenseLangString license ${LANG_TURKISH} license\en.txt
LicenseLangString license ${LANG_UKRAINIAN} license\en.txt
LicenseLangString license ${LANG_WELSH} license\en.txt
LicenseData $(license)
LicenseForceSelection checkbox

;--------------------------------

; Pages

Page license
Page custom ShowGraphics
Page instfiles
Page custom ShowWarning LeaveWarning

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

Var /GLOBAL c
Var /GLOBAL preseed

Function ShowGraphics
  InitPluginsDir

  ; Initialise $preseed
  StrCpy $preseed "interface=auto"

  ; Initialise $c
  ; FIXME: this blurb is duplicated in the uninstaller.  keep in sync!
  ${GetRoot} $WINDIR $c

  StrCpy $INSTDIR "$c\debian"
  SetOutPath $INSTDIR

  ; we need 3 GiB to install debian
  ; FIXME: maybe we should ask whether user wants dual boot or nuking windoze completely first
  StrCpy $0 3145728 ; == 3 GiB
  StrCpy $1 $c
  Call CheckSpaceFunc
  IntCmp $2 1 +2
  MessageBox MB_OK "You do not seem to have enough free disk space in drive $c.  For a complete \
desktop install, it is recommended that you have at least 3 GB of free disk.  If you already have a \
separate disk or partition to install Debian, or if you plan to replace Windows completely, you can \
safely ignore this warning."

  ; and we refuse to start the installer with less than 30 MiB
  StrCpy $0 30720 ; == 30 MiB
  StrCpy $1 $c
  Call CheckSpaceFunc
  IntCmp $2 1 +3
  MessageBox MB_OK "Error: not enough free disk space.  Aborting install."
  Quit

  ; Write the uninstall keys for Windows
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Debian-Installer Loader" "DisplayName" "Debian-Installer Loader"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Debian-Installer Loader" "UninstallString" "$INSTDIR\uninstall.exe"

  File /oname=$PLUGINSDIR\graphics.ini graphics.ini
  ; FIXME: I don't know how to refer to $PLUGINSDIR from graphics.ini, so let's install them in $INSTDIR
  File gtk.bmp gtk.bmp
  File text.bmp text.bmp
  File /oname=$PLUGINSDIR\warning.ini warning.ini

  WriteINIStr $PLUGINSDIR\graphics.ini "Field 2" "Text" "$c\debian\gtk.bmp"
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 3" "Text" "$c\debian\text.bmp"
  InstallOptions::dialog $PLUGINSDIR\graphics.ini
FunctionEnd

Section "Debian-Installer Loader"
  test64::get_arch
  Var /GLOBAL arch
  StrCpy $arch $0

  Var /GLOBAL fellow_hacker
  ${If} $arch == "i386"
    StrCpy $fellow_hacker "joeyh"
  ${Else}
    StrCpy $fellow_hacker "aba"
  ${EndIf}

  Var /GLOBAL gtk
  ReadINIStr $0 $PLUGINSDIR\graphics.ini "Field 4" "State"
  ${If} $0 == "1"
    StrCpy $gtk "gtk/"
    StrCpy $preseed "$preseed video=vesa:ywrap,mtrr vga=788"
  ${Else}
    StrCpy $preseed "$preseed vga=normal"
  ${EndIf}


  Var /GLOBAL base_url
  StrCpy $base_url "http://people.debian.org/~$fellow_hacker/d-i/images/daily/netboot/$gtkdebian-installer/$arch"

  Var /GLOBAL proxy
  StrCpy $proxy "/NOIEPROXY"
  StrCpy $preseed "$preseed mirror/http/proxy="
  ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyEnable
  IntCmp $0 1 0 proxyless
  ReadRegStr $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyServer
  StrCmp $0 "" proxyless
  StrCpy $proxy "/PROXY $0"
  StrCpy $preseed "$preseedhttp://$0/"
proxyless:

  NSISdl::download $proxy $base_url/linux $INSTDIR\linux
  Pop $R0
  ${If} $R0 != "success"
    ${If} $R0 != "cancel"
       MessageBox MB_OK "Error: $R0"
    ${EndIf}
    Quit
  ${EndIf}

  NSISdl::download $proxy $base_url/initrd.gz $INSTDIR\initrd.gz
  Pop $R0
  ${If} $R0 != "success"
    ${If} $R0 != "cancel"
       MessageBox MB_OK "Error: $R0"
    ${EndIf}
    Quit
  ${EndIf}

  File /oname=$c\grldr "grub\grldr"
  File /oname=$c\grub "grub\grub"

  ; preseed hostname
  System::Call "kernel32.dll::GetComputerNameExW(i 1,w .r0,*i ${NSIS_MAX_STRLEN} r1)i.r2"
  ${If} $2 != 0
    ${If} $0 == ""
      StrCpy $0 "debian"
    ${Endif}
    StrCpy $preseed "$preseed hostname=$0"
  ${EndIf}

  ; preseed domain
  System::Call "kernel32.dll::GetComputerNameExW(i 2,w .r0,*i ${NSIS_MAX_STRLEN} r1)i.r2"
  ${If} $2 != 0
    ${If} $0 == ""
      StrCpy $0 "localdomain"
    ${Endif}
    StrCpy $preseed "$preseed domain=$0"
  ${EndIf}

  ; preseed timezone
  File /oname=$PLUGINSDIR\maps.ini maps.ini
  ReadRegStr $0 HKLM SYSTEM\CurrentControlSet\Control\TimeZoneInformation StandardName
  ReadINIStr $0 $PLUGINSDIR\maps.ini "timezones" "$0"
  ${If} $0 != ""
    StrCpy $preseed "$preseed time/zone=$0"
  ${Endif}

  FileOpen $0 $c\menu.lst w
  FileWrite $0 "\
find	--set-root /debian/initrd.gz$\n\
kernel	/debian/linux $preseed --$\n\
initrd	/debian/initrd.gz$\n"
  FileClose $0

  ${Unless} ${FileExists} "$c\boot.ini"
    MessageBox MB_OK "Error: $c\boot.ini not found.  Your version of Windows might be too old, or damaged."
    Quit
  ${Endif}

  SetFileAttributes "$c\boot.ini" NORMAL
  SetFileAttributes "$c\boot.ini" SYSTEM|HIDDEN
  WriteIniStr "$c\boot.ini" "operating systems" "$c\grldr" '"Debian Installer"'
SectionEnd

Function ShowWarning
  InstallOptions::dialog $PLUGINSDIR\warning.ini
FunctionEnd

Function LeaveWarning
  MessageBox MB_YESNO|MB_ICONQUESTION "Do you want to reboot now?" IDNO +2
  Reboot
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
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Debian-Installer Loader"
  Delete $c\grldr
  Delete $c\grub
  Delete $c\menu.lst
  Delete $INSTDIR\gtk.bmp
  Delete $INSTDIR\text.bmp
  Delete $INSTDIR\linux
  Delete $INSTDIR\initrd.gz
  Delete /REBOOTOK $INSTDIR\Uninstall.exe
  RMDir /REBOOTOK $INSTDIR
SectionEnd
