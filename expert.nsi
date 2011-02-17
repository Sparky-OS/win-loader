; Debian-Installer Loader - Expert selection and early detection
; 
; Copyright (C) 2007,2008,2009  Robert Millan <rmh@aybabtu.com>
; Copyright (C) 2010,2011       Didier Raboud <odyx@debian.org>
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

Function ShowExpert
; Do initialisations as early as possible

; ********************************************** Initialise $preseed_cmdline
  StrCpy $preseed_cmdline " "

!ifndef NOCD
; ********************************************** Initialise $d
  ${GetRoot} $EXEDIR $d

; ********************************************** Check win32-loader.ini presence
; before initialising $arch or $gtk
  IfFileExists $d\win32-loader.ini +3 0
    MessageBox MB_OK|MB_ICONSTOP "$(error_missing_ini)"
    Quit

; ********************************************** Display README.html if found
  ReadINIStr $0 $PLUGINSDIR\maps.ini "languages" "$LANGUAGE"
  IfFileExists $d\README.$0.html 0 +3
    StrCpy $0 README.$0.html
    Goto readme_file_found
  IfFileExists $d\README.html 0 readme_file_not_found
    StrCpy $0 README.html
    Goto readme_file_found

readme_file_found:
  ShowWindow $HWNDPARENT ${SW_MINIMIZE}
  ExecShell "open" "file://$d/$0"

readme_file_not_found:
!endif

; ********************************************** Initialise $arch
  test64::get_arch
  StrCpy $arch $0
!ifndef NOCD
  ReadINIStr $0 $d\win32-loader.ini "installer" "arch"
  ${If} "$0:$arch" == "amd64:i386"
    MessageBox MB_OK|MB_ICONSTOP $(amd64_on_i386)
    Quit
  ${Endif}
  ${If} "$0:$arch" == "i386:amd64"
    MessageBox MB_YESNO|MB_ICONQUESTION $(i386_on_amd64) IDNO +2
    Quit
    StrCpy $arch "i386"
  ${Endif}
!endif

  ; Windows version is another abort condition
  Var /GLOBAL windows_boot_method
  ${If} ${AtMostWinME}
    StrCpy $windows_boot_method direct
    ${If} ${IsNT}
      StrCpy $windows_boot_method ntldr
    ${Endif}
    Goto windows_version_ok
  ${Endif}
  ${If} ${AtMostWin2003}
    StrCpy $windows_boot_method ntldr
    Goto windows_version_ok
  ${Endif}
  ${If} ${AtMostWin7}
    StrCpy $windows_boot_method bootmgr
    ; FIXME: this blurb is duplicated in the uninstaller.  keep in sync!
    GetFullPathName $bcdedit $WINDIR\Sysnative\bcdedit.exe
    ${If} $bcdedit == ""
      StrCpy $bcdedit $SYSDIR\bcdedit.exe
    ${Endif}
    Goto windows_version_ok
  ${Endif}
  Var /GLOBAL windows_version
  ${WinVerGetMajor} $0
  ${WinVerGetMinor} $1
  ${WinVerGetBuild} $2
  ${WinVerGetServicePackLevel} $3
  StrCpy $windows_version "$0.$1.$2 SP$3"
  MessageBox MB_OK|MB_ICONSTOP $(unsupported_version_of_windows)
  Quit
windows_version_ok:

; ********************************************** Initialise $c
; We set it to the "System partition" (see http://en.wikipedia.org/wiki/System_partition_and_boot_partition)

  ${If} $windows_boot_method == ntldr
  ${OrIf} $windows_boot_method == bootmgr
    systeminfo::find_system_partition
    Pop $c
    ${If} $c == failed
      ${GetRoot} $WINDIR $c
      MessageBox MB_OK|MB_ICONEXCLAMATION $(cant_find_system_partition)
    ${Endif}
    Goto c_is_initialized
  ${Endif}
  ${If} $windows_boot_method == direct
    ; Doesn't really matter.
    ${GetRoot} $WINDIR $c
    Goto c_is_initialized
  ${Endif}
c_is_initialized:
  ; For the uninstaller
  WriteRegStr HKLM "${REGSTR_WIN32}" "system_drive" "$c"

  StrCpy $INSTDIR "$c\win32-loader"
  SetOutPath $INSTDIR

!ifdef PXE
  File /oname=$PLUGINSDIR\expert.ini	templates/ternary_choice.ini
  WriteINIStr $PLUGINSDIR\expert.ini "Field 4" "Text" $(expert4)
!else ;PXE
  File /oname=$PLUGINSDIR\expert.ini	templates/binary_choice.ini
!endif ;PXE
  WriteINIStr $PLUGINSDIR\expert.ini "Field 1" "Text" $(expert1)
  WriteINIStr $PLUGINSDIR\expert.ini "Field 2" "Text" $(expert2)
  WriteINIStr $PLUGINSDIR\expert.ini "Field 3" "Text" $(expert3)
  InstallOptions::dialog $PLUGINSDIR\expert.ini

  Var /GLOBAL expert
!ifdef PXE
  Var /GLOBAL pxe_mode
  ReadINIStr $0 $PLUGINSDIR\expert.ini "Field 4" "State"
  ${If} $0 == "1"
    StrCpy $pxe_mode true
    StrCpy $expert false
  ${Else}
    StrCpy $pxe_mode false
!endif ; PXE
    ReadINIStr $0 $PLUGINSDIR\expert.ini "Field 3" "State"
    ${If} $0 == "1"
      StrCpy $expert true
    ${Else}
      StrCpy $expert false
    ${Endif}
!ifdef PXE
  ${Endif} ; Field 4 (PXE) checked ?
!endif ;PXE
FunctionEnd
