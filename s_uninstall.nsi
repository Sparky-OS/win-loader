Section "Uninstall"
  ; Initialise $c
  ReadRegStr $c HKLM "Software\Debian\Debian-Installer Loader" "system_drive"

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

  ReadRegStr $0 HKLM "Software\Debian\Debian-Installer Loader" "bootmgr"
  ${If} $0 != ""
    ; FIXME: this blurb is duplicated in the installer.  keep in sync!
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

  DeleteRegKey HKLM "Software\Debian\Debian-Installer Loader"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Debian-Installer Loader"
  Delete $c\g2ldr
  Delete $c\g2ldr.mbr
  RMDir /r /REBOOTOK $INSTDIR
SectionEnd
