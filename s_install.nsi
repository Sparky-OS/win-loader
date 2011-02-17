Section "Installer Loader"

; ******************************************************************************
; ***************************************** THIS IS WHERE THE REAL ACTION STARTS
; ******************************************************************************

  ; Up to this point, we haven't modified host system.  The first modification
  ; we want to do is preparing the Uninstaller (so that in case something went
  ; wrong, our half-install can be undone).
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "${REGSTR_UNINST}" "DisplayName" $(program_name)
  WriteRegStr HKLM "${REGSTR_UNINST}" "UninstallString" "$INSTDIR\Uninstall.exe"
  ; Add more branding (see branding.nsi)
  WriteRegStr HKLM "${REGSTR_UNINST}" "Publisher" "${_COMPANY_NAME}"
  WriteRegStr HKLM "${REGSTR_UNINST}" "DisplayIcon" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "${REGSTR_UNINST}" "NoModify" "1"
  WriteRegStr HKLM "${REGSTR_UNINST}" "NoRepair" "1"
  WriteRegStr HKLM "${REGSTR_UNINST}" "DisplayVersion" "${VERSION_OPT}"
  WriteRegStr HKLM "${REGSTR_UNINST}" "ProductID" "${4DIGITS_DATE}"
  

!ifndef NOCD
  ${If} $kernel == "linux"
    ClearErrors
    StrCpy $0 "$EXEDIR\$linux"
    StrCpy $1 "$INSTDIR\linux"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
    StrCpy $0 "$EXEDIR\$initrd"
    StrCpy $1 "$INSTDIR\initrd.gz"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
  ${ElseIf} $kernel == "kfreebsd"
    # TODO: Check if kfreebsd will ever ship a media-based installed.
    # If so, make sure it works here.
    MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
    Quit
  ${EndIf}
!else
!ifdef PXE
 ${If} $pxe_mode == "false"
!endif ;PXE
  ; Download the MD5SUMS file
  Push "false"
  Push "false"
  Push "MD5SUMS"
  Push "$PLUGINSDIR"
  Push "$base_url_images"
  Call Download

  ${If} $kernel == "linux"
    Push "$PLUGINSDIR\MD5SUMS"
    Push "$base_url/linux"
    Call Get_MD5_ref
    ; MD5 is on stack
    Push "false"
    Push "linux"
    Push "$INSTDIR"
    Push "$base_url_images$base_url"
    Call Download
    
    Push "$PLUGINSDIR\MD5SUMS"
    Push "$base_url/initrd.gz"
    Call Get_MD5_ref
    ; MD5 is on stack
    Push "false"
    Push "initrd.gz"
    Push "$INSTDIR"
    Push "$base_url_images$base_url"
    Call Download
  ${ElseIf} $kernel == "kfreebsd"
    Push "$PLUGINSDIR\MD5SUMS"
    Push "$base_url/kfreebsd.gz"
    Call Get_MD5_ref
    ; MD5 is on stack
    Push "false"
    Push "kfreebsd.gz"
    Push "$INSTDIR"
    Push "$base_url_images$base_url"
    Call Download

    Push "$PLUGINSDIR\MD5SUMS"
    Push "$base_url/initrd.gz"
    Call Get_MD5_ref
    ; MD5 is on stack
    Push "false"
    Push "initrd.gz"
    Push "$INSTDIR"
    Push "$base_url_images$base_url"
    Call Download
  ${EndIf}
!ifdef PXE
 ${EndIf} ; $pxe_mode == "false"
!endif ;PXE
!endif

; We're about to write down our preseed line.  This would be a nice place
; to add post-install parameters.
  StrCpy $preseed_cmdline "$preseed_cmdline --"

; ********************************************** preseed quietness
  ${If} $expert == false
    StrCpy $preseed_cmdline "$preseed_cmdline quiet"
  ${Endif}

; ********************************************** grub.cfg
  StrCpy $0 "$INSTDIR\grub.cfg"
  DetailPrint "$(generating)"
  FileOpen $0 $INSTDIR\grub.cfg w
!ifdef PXE
 ${If} $pxe_mode == "true"
    FileWrite $0 "\
linux16 /win32-loader/pxe.lkrn$\n\
boot$\n"
 ${Else}
!endif ;PXE
  ${If} $kernel == "linux"
    FileWrite $0 "\
linux	/win32-loader/linux $preseed_cmdline$\n\
initrd	/win32-loader/initrd.gz$\n\
boot$\n"
  ${ElseIf} $kernel == "kfreebsd"
    FileWrite $0 "\
kfreebsd	/win32-loader/kfreebsd.gz$\n\
kfreebsd_module	/win32-loader/initrd.gz type=mfs_root$\n\
set kFreeBSD.vfs.root.mountfrom=ufs:/dev/md0$\n\
set kFreeBSD.hw.ata.ata_dma=0   # needed for qemu hard disk # TODO: delete$\n\
set kFreeBSD.hw.ata.atapi_dma=0 # needed for qemu cd # TODO: 1$\n\
boot$\n"
  ${EndIf}
!ifdef PXE
 ${EndIf} ; $pxe_mode == "true"
!endif ;PXE
  FileClose $0

!ifdef PXE
 ${If} $pxe_mode == "false"
!endif ; PXE
; ********************************************** cpio hack
  File /oname=$INSTDIR\cpio.exe /usr/share/win32/cpio.exe
  File /oname=$INSTDIR\gzip.exe /usr/share/win32/gzip.exe

  StrCpy $0 "$INSTDIR\initrd.gz"
  DetailPrint "$(appending_preseeding)"

  FileOpen $0 $INSTDIR\preseed.cfg w
  FileWrite $0 "$preseed_cfg$\n"
  FileClose $0

  ; cpio awkward CLI, meet Winf**k awkward CLI
  FileOpen $0 $INSTDIR\cpio_list w
  FileWrite $0 "preseed.cfg"
  FileClose $0

  ; IMPORTANT!!  All files accessed by this script must be in the same
  ; filesystem as the script itself, because cmd.exe/command.com gets
  ; confused when using absolute paths.  This is why $INSTDIR is used
  ; instead of $PLUGINSDIR.
  FileOpen $0 $INSTDIR\cpio.bat w
  FileWrite $0 "\
cpio.exe -o -H newc < cpio_list > newc_chunk$\r$\n\
attrib -r initrd.gz$\r$\n\
gzip.exe -1 < newc_chunk >> initrd.gz$\r$\n\
"
  FileClose $0
; TODO: FIX THIS FOR kFreeBSD
${If} $kernel == "linux"
  nsExec::Exec '"$INSTDIR\cpio.bat"'
  Pop $0
  ${If} $0 != 0
    StrCpy $0 "$INSTDIR\cpio.bat"
    MessageBox MB_OK|MB_ICONSTOP "$(error_exec)"
    Quit
  ${Endif}
${EndIf}
!ifdef PXE
 ${EndIf} ; $pxe_mode == "false"
!endif ; PXE

; ********************************************** Do bootloader last, because it's the most dangerous
  ${If} $windows_boot_method == ntldr
!ifdef NOCD
    !ifdef NETWORK_BASE_URL
        Push "false"
        Push "g2ldr"
        Push "$c"
        Push "${NETWORK_BASE_URL}"
        Call Download
        Push "false"
        Push "g2ldr.mbr"
        Push "$c"
        Push "${NETWORK_BASE_URL}"
        Call Download
    !else
       File /oname=$c\g2ldr g2ldr
       File /oname=$c\g2ldr.mbr g2ldr.mbr
      !ifdef PXE
       ${If} $pxe_mode == "true"
          File /oname=$INSTDIR\pxe.lkrn pxe.lkrn
       ${EndIf} ; $pxe_mode == "true"
      !endif ; PXE
    !endif
!else
    ClearErrors
    StrCpy $0 "$EXEDIR\$g2ldr"
    StrCpy $1 "$c\g2ldr"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
    StrCpy $0 "$EXEDIR\$g2ldr_mbr"
    StrCpy $1 "$c\g2ldr.mbr"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
!endif
    DetailPrint "$(registering_ntldr)"
    SetFileAttributes "$c\boot.ini" NORMAL
    SetFileAttributes "$c\boot.ini" SYSTEM|HIDDEN

    ; Sometimes timeout isn't set.  This may result in ntldr booting straight to
    ; Windows (bad) or straight to Debian-Installer (also bad)!  Force it to 30
    ; just in case. Store its eventual old value alongside
    ; Read the already defined timeout
    ReadIniStr $0 "$c\boot.ini" "boot loader" "timeout"
    IfErrors 0 no_boot_ini_timeout
       ClearErrors
       WriteIniStr "$c\boot.ini" "boot loader" "old_timeout_win32-loader" $0
    no_boot_ini_timeout:
    WriteIniStr "$c\boot.ini" "boot loader" "timeout" "30"
!ifdef PXE
   ${If} $pxe_mode == "true"
    WriteIniStr "$c\boot.ini" "operating systems" "$c\g2ldr.mbr" '"$(pxe_ntldr)"'
   ${Else}
!endif ; PXE
    WriteIniStr "$c\boot.ini" "operating systems" "$c\g2ldr.mbr" '"$(d-i_ntldr)"'
!ifdef PXE
   ${EndIf} ; $pxe_mode == "true"
!endif ; PXE
  ${Endif}

  ${If} $windows_boot_method == direct
    File /oname=$INSTDIR\loadlin.exe loadlin.exe
    File /oname=$INSTDIR\loadlin.pif loadlin.pif
  ${Endif}

  ${If} $windows_boot_method == bootmgr
!ifdef NOCD
    !ifdef NETWORK_BASE_URL
        Push "false"
        Push "g2ldr"
        Push "$c"
        Push "${NETWORK_BASE_URL}"
        Call Download
        Push "false"
        Push "g2ldr.mbr"
        Push "$c"
        Push "${NETWORK_BASE_URL}"
        Call Download
    !else
       File /oname=$c\g2ldr g2ldr
       File /oname=$c\g2ldr.mbr g2ldr.mbr
      !ifdef PXE
       ${If} $pxe_mode == "true"
          File /oname=$INSTDIR\pxe.lkrn pxe.lkrn
       ${EndIf} ; $pxe_mode == "true"
      !endif ; PXE
    !endif
!else
    ClearErrors
    StrCpy $0 "$EXEDIR\$g2ldr"
    StrCpy $1 "$c\g2ldr"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
    StrCpy $0 "$EXEDIR\$g2ldr_mbr"
    StrCpy $1 "$c\g2ldr.mbr"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
!endif
    ; FIXME: this blurb is duplicated in the uninstaller.  keep in sync!
    GetFullPathName $bcdedit $WINDIR\Sysnative\bcdedit.exe
    ${If} $bcdedit == ""
      StrCpy $bcdedit $SYSDIR\bcdedit.exe
    ${Endif}

    DetailPrint "$(registering_bootmgr)"
    ReadRegStr $0 HKLM "${REGSTR_WIN32}" "bootmgr"
    ${If} $0 == ""
!ifdef PXE
     ${If} $pxe_mode == "true"
      nsExec::ExecToStack '"$bcdedit" /create /d "$(pxe_ntldr)" /application bootsector'
     ${Else}
!endif ; PXE
      nsExec::ExecToStack '"$bcdedit" /create /d "$(d-i_ntldr)" /application bootsector'
!ifdef PXE
     ${EndIf} ; $pxe_mode == "true"
!endif ; PXE
      Pop $0
      ${If} $0 != 0
        StrCpy $0 $bcdedit
        MessageBox MB_OK|MB_ICONSTOP "$(error_exec)"
        Quit
      ${Endif}
      ; "The entry {id} was successfully created" is in top of stack now
      string::bcdedit_extract_id
      Pop $0
      ${If} $0 == "error"
        MessageBox MB_OK|MB_ICONSTOP "$(error_bcdedit_extract_id)"
        Quit
      ${Endif}
      ; $0 holds the boot id.  Write it down, both for installer idempotency
      ; and for uninstaller.
      WriteRegStr HKLM "${REGSTR_WIN32}" "bootmgr" "$0"
    ${Endif}
    nsExec::Exec '"$bcdedit" /set $0 device boot'
    nsExec::Exec '"$bcdedit" /set $0 path \g2ldr.mbr'
    nsExec::Exec '"$bcdedit" /set $0 device partition=$c'
    nsExec::Exec '"$bcdedit" /displayorder $0 /addlast'
  ${Endif}

; ********************************************** Needed for systems with compressed NTFS
  DetailPrint "$(disabling_ntfs_compression)"
  nsExec::Exec '"compact" /u $c\g2ldr $c\g2ldr.mbr $INSTDIR\grub.cfg'
  ; in my tests, uncompressing $INSTDIR\grub.cfg wasn't necessary, but better be safe than sorry
  ${If} $kernel == "linux"
    nsExec::Exec '"compact" /u $INSTDIR\linux $INSTDIR\initrd.gz'
  ${ElseIf} $kernel == "kfreebsd"
    nsExec::Exec '"compact" /u $INSTDIR\kfreebsd.gz $INSTDIR\initrd.gz'
  ${EndIf}
!ifdef PXE
  ${If} $pxe_mode == "true"
    nsExec::Exec '"compact" /u $INSTDIR\pxe.lkrn'
  ${EndIf}
!endif ;PXE

SectionEnd
