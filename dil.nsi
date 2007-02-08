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
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Bulgarian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Catalan.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Croatian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Czech.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Danish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Dutch.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Estonian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Finnish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\French.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\German.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Greek.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Hebrew.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Hungarian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Indonesian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Italian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Japanese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Korean.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Kurdish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Latvian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Lithuanian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Macedonian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Norwegian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\NorwegianNynorsk.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Polish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\PortugueseBR.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Portuguese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Romanian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Slovak.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Slovenian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Spanish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Swedish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Thai.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\TradChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Turkish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Ukrainian.nlf"

; License
; Please see license/DO-NOT-TRANSLATE

LicenseLangString license ${LANG_ALBANIAN} license\en.txt
LicenseLangString license ${LANG_ARABIC} license\en.txt
LicenseLangString license ${LANG_BASQUE} license\en.txt
LicenseLangString license ${LANG_BELARUSIAN} license\en.txt
LicenseLangString license ${LANG_BOSNIAN} license\en.txt
LicenseLangString license ${LANG_BULGARIAN} license\en.txt
LicenseLangString license ${LANG_CATALAN} license\ca.txt
LicenseLangString license ${LANG_CROATIAN} license\en.txt
LicenseLangString license ${LANG_CZECH} license\en.txt
LicenseLangString license ${LANG_DANISH} license\en.txt
LicenseLangString license ${LANG_DUTCH} license\en.txt
LicenseLangString license ${LANG_ENGLISH} license\en.txt
LicenseLangString license ${LANG_ESTONIAN} license\en.txt
LicenseLangString license ${LANG_FINNISH} license\en.txt
LicenseLangString license ${LANG_FRENCH} license\en.txt
LicenseLangString license ${LANG_GERMAN} license\en.txt
LicenseLangString license ${LANG_GREEK} license\en.txt
LicenseLangString license ${LANG_HEBREW} license\en.txt
LicenseLangString license ${LANG_HUNGARIAN} license\en.txt
LicenseLangString license ${LANG_INDONESIAN} license\en.txt
LicenseLangString license ${LANG_ITALIAN} license\en.txt
LicenseLangString license ${LANG_JAPANESE} license\en.txt
LicenseLangString license ${LANG_KOREAN} license\en.txt
LicenseLangString license ${LANG_KURDISH} license\en.txt
LicenseLangString license ${LANG_LATVIAN} license\en.txt
LicenseLangString license ${LANG_LITHUANIAN} license\en.txt
LicenseLangString license ${LANG_MACEDONIAN} license\en.txt
LicenseLangString license ${LANG_NORWEGIAN} license\en.txt
LicenseLangString license ${LANG_NORWEGIANNYNORSK} license\en.txt
LicenseLangString license ${LANG_POLISH} license\en.txt
LicenseLangString license ${LANG_PORTUGUESEBR} license\en.txt
LicenseLangString license ${LANG_PORTUGUESE} license\en.txt
LicenseLangString license ${LANG_ROMANIAN} license\en.txt
LicenseLangString license ${LANG_RUSSIAN} license\en.txt
LicenseLangString license ${LANG_SIMPCHINESE} license\en.txt
LicenseLangString license ${LANG_SLOVAK} license\en.txt
LicenseLangString license ${LANG_SLOVENIAN} license\en.txt
LicenseLangString license ${LANG_SPANISH} license\es.txt
LicenseLangString license ${LANG_SWEDISH} license\en.txt
LicenseLangString license ${LANG_THAI} license\en.txt
LicenseLangString license ${LANG_TRADCHINESE} license\en.txt
LicenseLangString license ${LANG_TURKISH} license\en.txt
LicenseLangString license ${LANG_UKRAINIAN} license\en.txt
LicenseData $(license)
LicenseForceSelection checkbox

;--------------------------------

; Pages

Page license
Page custom ShowGraphics
Page custom ShowCustom
Page instfiles
Page custom ShowWarning

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

Var /GLOBAL c
Var /GLOBAL preseed

Function .onInit
  InitPluginsDir

  ; needed by: timezones, keymaps, languages
  File /oname=$PLUGINSDIR\maps.ini maps.ini

  ; default to English
  StrCpy $LANGUAGE 1033

  ; Language selection dialog
  Push ""
  Push ${LANG_ALBANIAN}
  Push Albanian
  Push ${LANG_ARABIC}
  Push Arabic
  Push ${LANG_BASQUE}
  Push Basque
  Push ${LANG_BELARUSIAN}
  Push Belarusian
  Push unsupported
  Push Bengali
  Push ${LANG_BOSNIAN}
  Push Bosnian
  Push ${LANG_BULGARIAN}
  Push Bulgarian
  Push ${LANG_CATALAN}
  Push Catalan
  Push ${LANG_SIMPCHINESE}
  Push "Chinese (Simplified)"
  Push ${LANG_TRADCHINESE}
  Push "Chinese (Traditional)"
  Push ${LANG_CROATIAN}
  Push Croatian
  Push ${LANG_CZECH}
  Push Czech
  Push ${LANG_DANISH}
  Push Danish
  Push ${LANG_DUTCH}
  Push Dutch
  Push unsupported
  Push Dzongkha
  Push ${LANG_ENGLISH}
  Push English
  Push unsupported
  Push Esperanto
  Push ${LANG_ESTONIAN}
  Push Estonian
  Push ${LANG_FINNISH}
  Push Finnish
  Push ${LANG_FRENCH}
  Push French
  Push unsupported
  Push Galician
  Push unsupported
  Push Georgian
  Push ${LANG_GERMAN}
  Push German
  Push ${LANG_GREEK}
  Push Greek
  Push unsupported
  Push Gujarati
  Push ${LANG_HEBREW}
  Push Hebrew
  Push unsupported
  Push Hindi
  Push ${LANG_HUNGARIAN}
  Push Hungarian
  Push ${LANG_INDONESIAN}
  Push Indonesian
  Push ${LANG_ITALIAN}
  Push Italian
  Push ${LANG_JAPANESE}
  Push Japanese
  Push unsupported
  Push Khmer
  Push ${LANG_KOREAN}
  Push Korean
  Push ${LANG_KURDISH}
  Push Kurdish
  Push ${LANG_LATVIAN}
  Push Latvian
  Push ${LANG_LITHUANIAN}
  Push Lithuanian
  Push unsupported
  Push Malayalam
  Push ${LANG_MACEDONIAN}
  Push Macedonian
  Push unsupported
  Push Nepali
  Push unsupported
  Push "Northern Sami"
  Push ${LANG_NORWEGIAN}
  Push "Norwegian Bokmaal"
  Push ${LANG_NORWEGIANNYNORSK}
  Push "Norwegian Nynorsk"
  Push ${LANG_POLISH}
  Push Polish
  Push ${LANG_PORTUGUESEBR}
  Push "Portuguese (Brazil)"
  Push ${LANG_PORTUGUESE}
  Push Portuguese
  Push unsupported
  Push "Punjabi (Gurmukhi)"
  Push ${LANG_ROMANIAN}
  Push Romanian
  Push ${LANG_RUSSIAN}
  Push Russian
  Push ${LANG_SLOVAK}
  Push Slovak
  Push ${LANG_SLOVENIAN}
  Push Slovenian
  Push ${LANG_SPANISH}
  Push Spanish
  Push ${LANG_SWEDISH}
  Push Swedish
  Push unsupported
  Push Tagalog
  Push unsupported
  Push Tamil
  Push ${LANG_THAI}
  Push Thai
  Push ${LANG_TURKISH}
  Push Turkish
  Push ${LANG_UKRAINIAN}
  Push Ukrainian
  Push unsupported
  Push Vietnamese
  Push unsupported
  Push Wolof

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

  ${If} $LANGUAGE == "unsupported"
    ; Translators: your language is supported by d-i, but not yet by nsis.
    ; Please get your translation in nsis before translating win32-loader.
    MessageBox MB_OK "Because the language you have selected is not supported \
by this stage of the installer, English will be used for now.  On the second \
(and last) stage of the install process, you will be able to select it."
  ${Endif}
FunctionEnd

Function ShowGraphics
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

  File /oname=$PLUGINSDIR\graphics.ini	templates/graphics.ini
  File /oname=$PLUGINSDIR\gtk.bmp	templates/gtk.bmp
  File /oname=$PLUGINSDIR\text.bmp	templates/text.bmp
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 1" "Text" "Select install mode:"
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 2" "Text" "$PLUGINSDIR\gtk.bmp"
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 3" "Text" "$PLUGINSDIR\text.bmp"
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 4" "Text" "Graphical install (recommended)"
  WriteINIStr $PLUGINSDIR\graphics.ini "Field 5" "Text" "Text install"
  InstallOptions::dialog $PLUGINSDIR\graphics.ini
FunctionEnd

Function ShowCustom

; Gather all the missing information before ShowCustom is displayed

; Preseed proxy first, so that it'll be more visible in ShowCustom
; ********************************************** Initialise proxy and preseed it
  Var /GLOBAL proxy
  StrCpy $proxy ""
  ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyEnable
  IntCmp $0 1 0 proxyless
  ReadRegStr $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyServer
  StrCmp $0 "" proxyless
  StrCpy $proxy "$0"
proxyless:
  ${If} $proxy != ""
    StrCpy $preseed "$preseed mirror/http/proxy=http://$proxy/"
  ${Else}
    StrCpy $preseed "$preseed mirror/http/proxy="
  ${Endif}

; ********************************************** Initialise base_url + Preseed vga mode
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

; ********************************************** preseed locale
  ReadINIStr $0 $PLUGINSDIR\maps.ini "languages" "$LANGUAGE"
  ReadRegStr $1 HKCU "Control Panel\International" sCountry
  ReadINIStr $1 $PLUGINSDIR\maps.ini "countries" "$1"
  ${If} $0 != ""
    ${If} $1 != ""
      StrCpy $preseed "$preseed locale=$0_$1"
    ${Endif}
  ${Endif}

; ********************************************** preseed domain
  System::Call "kernel32.dll::GetComputerNameExW(i 2,w .r0,*i ${NSIS_MAX_STRLEN} r1)i.r2"
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

; ********************************************** IMPORTANT NOTE: after this point,
; preseeding only sets default, but doesn't hide templates from the user
  StrCpy $preseed "$preseed preseed/interactive=true"

; ********************************************** preseed keymap
  System::Call "user32.dll::GetKeyboardLayout(i 0)i.r0"
  ; lower word is the locale identifier (higher word is a handler to the actual layout)
  IntOp $0 $0 & 0x0000FFFF
  IntFmt $0 "0x%04X" $0
  ReadINIStr $0 $PLUGINSDIR\maps.ini "keymaps" "$0"
  ; FIXME: do we need to support non-AT keyboards here?
  ${If} $0 != ""
    StrCpy $preseed "$preseed console-keymaps-at/keymap=$0"
  ${Endif}

; ********************************************** preseed hostname
  System::Call "kernel32.dll::GetComputerNameExW(i 1,w .r0,*i ${NSIS_MAX_STRLEN} r1)i.r2"
  ${If} $2 != 0
    ${If} $0 == ""
      StrCpy $0 "debian"
    ${Endif}
    StrCpy $preseed "$preseed hostname=$0"
  ${EndIf}

; ********************************************** Display customisation dialog now
  Var /GLOBAL boot_ini
  File /oname=$PLUGINSDIR\custom.ini templates/custom.ini
  WriteINIStr $PLUGINSDIR\custom.ini "Field 1" "Text" "Debian-Installer Loader will be setup with the following parameters.  Do NOT change any of these unless you know what you're doing!"
  WriteINIStr $PLUGINSDIR\custom.ini "Field 2" "Text" "NSISdl proxy settings (host:port):"
  WriteINIStr $PLUGINSDIR\custom.ini "Field 3" "Text" "Location of boot.ini:"
  WriteINIStr $PLUGINSDIR\custom.ini "Field 4" "Text" "Debconf preseed line:"
  WriteINIStr $PLUGINSDIR\custom.ini "Field 5" "Text" "Base URL for netboot images (linux and initrd.gz):"
  WriteINIStr $PLUGINSDIR\custom.ini "Field 6" "State" "$proxy"
  WriteINIStr $PLUGINSDIR\custom.ini "Field 7" "State" "$c\boot.ini"
  WriteINIStr $PLUGINSDIR\custom.ini "Field 8" "State" "$base_url"
  WriteINIStr $PLUGINSDIR\custom.ini "Field 9" "State" "$preseed"
  InstallOptions::dialog $PLUGINSDIR\custom.ini
  ReadINIStr $proxy	$PLUGINSDIR\custom.ini "Field 6" "State"
  ReadINIStr $boot_ini	$PLUGINSDIR\custom.ini "Field 7" "State"
  ReadINIStr $base_url	$PLUGINSDIR\custom.ini "Field 8" "State"
  ReadINIStr $preseed	$PLUGINSDIR\custom.ini "Field 9" "State"
FunctionEnd

Section "Debian-Installer Loader"

; ******************************************************************************
; ***************************************** THIS IS WHERE THE REAL ACTION STARTS
; ******************************************************************************

  ; Up to this point, we haven't modified host system.  The first modification
  ; we want to do is preparing the Uninstaller (so that in case something went
  ; wrong, our half-install can be undone).
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Debian-Installer Loader" "DisplayName" "Debian-Installer Loader"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Debian-Installer Loader" "UninstallString" "$INSTDIR\uninstall.exe"

  ${If} $proxy == ""
    StrCpy $proxy /NOIEPROXY
  ${Else}
    StrCpy $proxy "/PROXY $proxy"
  ${Endif}

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

  FileOpen $0 $c\menu.lst w
  FileWrite $0 "\
find	--set-root /debian/initrd.gz$\n\
kernel	/debian/linux $preseed --$\n\
initrd	/debian/initrd.gz$\n"
  FileClose $0

; ********************************************** Do boot.ini last, because it's the most dangerous
  ${Unless} ${FileExists} "$boot_ini"
    MessageBox MB_OK "Error: $boot_ini not found.  Your version of Windows might be too old, or damaged."
    Quit
  ${Endif}

  SetFileAttributes "$boot_ini" NORMAL
  SetFileAttributes "$boot_ini" SYSTEM|HIDDEN
  WriteIniStr "$boot_ini" "operating systems" "$c\grldr" '"Debian Installer"'
SectionEnd

Function ShowWarning
  File /oname=$PLUGINSDIR\warning.ini templates/warning.ini
  WriteINIStr $PLUGINSDIR\warning.ini "Field 1" "Text" 'VERY IMPORTANT NOTICE:$\n$\nYou \
need to reboot in order to proceed with your Debian install.  During your next boot, you \
will be asked whether you want to start Windows or "Debian Installer".  Choose \
"Debian Installer" to continue the install process.$\n$\nDuring the install process, \
you will be offered the possibility of either reducing your Windows partition to install \
Debian or completely replacing it.  In both cases, it is STRONGLY RECOMMENDED that you \
have previously made a backup of your data.  Nor the authors of this loader neither the \
Debian project will take ANY RESPONSIBILITY in the event of data loss.$\n$\nOnce your \
Debian install is complete (and if you have chosen to keep Windows in your disk), you \
can uninstall the Debian-Installer Loader through the Windows Add/Remove Programs dialog \
in Control Panel.$\n$\nEnjoy!'
  InstallOptions::dialog $PLUGINSDIR\warning.ini
FunctionEnd

Function .onInstSuccess
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
  Delete $INSTDIR\linux
  Delete $INSTDIR\initrd.gz
  Delete /REBOOTOK $INSTDIR\Uninstall.exe
  RMDir /REBOOTOK $INSTDIR
SectionEnd
