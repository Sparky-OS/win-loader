; Debian-Installer Loader - Uninstallation
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


Section "Uninstall"
  ; Initialise $c
  ReadRegStr $c HKLM "${REGSTR_WIN32}" "system_drive"

  SetFileAttributes "$c\boot.ini" NORMAL
  SetFileAttributes "$c\boot.ini" SYSTEM|HIDDEN
  DeleteINIStr "$c\boot.ini" "operating systems" "$c\g2ldr.mbr"
    
  ReadIniStr $0 "$c\boot.ini" "boot loader" "old_timeout_win32-loader"
  IfErrors 0 no_saved_boot_ini_timeout
     ; Restore original timeout
     ClearErrors
     WriteIniStr "$c\boot.ini" "boot loader" "timeout" $0
     DeleteINIStr "$c\boot.ini" "boot loader" "old_timeout_win32-loader"
  no_saved_boot_ini_timeout:

  ReadRegStr $0 HKLM "${REGSTR_WIN32}" "bootmgr"
  ${If} $0 != ""
    ; FIXME: this blurb is duplicated in the installer (expert.nsi).  keep in sync!
    GetFullPathName $bcdedit $WINDIR\Sysnative\bcdedit.exe
    ${If} $bcdedit == ""
      StrCpy $bcdedit $SYSDIR\bcdedit.exe
    ${Endif}

    nsExec::Exec '"$bcdedit" /delete $0'
    Pop $0
    ${If} $0 != 0
      StrCpy $0 $bcdedit
      MessageBox MB_OK|MB_ICONSTOP "$(error_exec)"
    ${Endif}
  ${Endif}

  DeleteRegKey HKLM "${REGSTR_WIN32}"
  DeleteRegKey HKLM "${REGSTR_UNINST}"
  Delete $c\g2ldr
  Delete $c\g2ldr.mbr
  RMDir /r /REBOOTOK $INSTDIR
SectionEnd
