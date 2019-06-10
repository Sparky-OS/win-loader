; Debian-Installer Loader - Installation
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

; Create boot entry and add it to display list of boot manager
; Parameter:
;   guid - global unique identifier of boot entry
;   label - brief description of boot entry
Function AddBootEntry
  System::Store 'S'
  Pop $3
  Pop $2

  System::Call 'kernel32::QueryDosDevice(t "$c", t .r4, \
    i${NSIS_MAX_STRLEN}) i.r0'

  ; guid=$2, label=$3, systempartition=$4
  ${If} $2 != ""
  ${AndIf} $0 != 0
    ${BOOTCFG_ConnectWMI} $R0 $R1 $0
    ${If} $0 == 0
      ${BOOTCFG_GetObject} $R1 "BcdStore" $R2 $0
      ${If} $0 == 0
        ${BOOTCFG_GetObject} $R1 "BcdObject" $R3 $0
        ${If} $0 == 0
          ${BOOTCFG_OpenDefaultBcdStore} $R1 $R2 $R4 $0
          ${If} $0 == 0
            ${BOOTCFG_CreateObject} $R1 $R2 $R4 \
              ${BOOTCFG_BOOT_SECTOR} $2 $5 $0
            ${If} $0 == 0
              ; Associate data with boot sector object
              ${BOOTCFG_SetDescription} $R1 $R3 $5 "$3" $1 $0
              ${If} $0 == 0
                ${BOOTCFG_SetPartition} $R1 $R3 $5 $4 $1 $0
                ${If} $0 == 0
                  ${BOOTCFG_SetPath} $R1 $R3 $5 "\g2ldr.mbr" $1 $0
                ${EndIf}
              ${EndIf}
              ; Release boot sector object and its associated data
              ${BOOTCFG_ReleaseObject} $5
              ${If} $0 == 0
                ; Append boot entry to list
                ${BOOTCFG_AppendBootEntry} $R1 $R2 \
                  $R4 $R3 $2 $1 $0
                ${If} $0 == 0
                  ; Release result
                  ${BOOTCFG_ReleaseObject} $1
                ${EndIf}
              ${EndIf}
            ${EndIf}
            ${BOOTCFG_ReleaseObject} $R4
          ${EndIf}
          ${BOOTCFG_ReleaseObject} $R3
        ${EndIf}
        ${BOOTCFG_ReleaseObject} $R2
      ${EndIf}
      ${BOOTCFG_ReleaseObject} $R1
      ${BOOTCFG_ReleaseObject} $R0
    ${EndIf}
  ${EndIf}

  ${If} $0 != 0
    IntFmt $2 "0x%08X" $0
    DetailPrint "$1: $2"
  ${EndIf}

  System::Store 'L'
FunctionEnd

Function CreateBootEntry
  ${If} $windows_boot_method == bootmgr
    ReadRegStr $0 HKLM "${REGSTR_WIN32}" "bootmgr"
    ${If} $0 == ""
      ${BOOTCFG_CreateGUID} $2
      ${If} $2 != ""
        Push "$2"
!ifdef PXE
        ${If} $pxe_mode == "true"
          Push "$(pxe)"
        ${Else}
!endif ; PXE
          Push "$(d-i)"
!ifdef PXE
        ${EndIf} ; $pxe_mode == "true"
!endif ; PXE
        Call AddBootEntry
        WriteRegStr HKLM "${REGSTR_WIN32}" "bootmgr" "$2"
      ${Else}
        MessageBox MB_OK|MB_ICONSTOP "$(error_bcdedit_extract_id)"
        Quit
      ${EndIf}
    ${Endif}
  ${Endif}
FunctionEnd

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
    ClearErrors
    StrCpy $0 "$EXEDIR\$kfreebsd"
    StrCpy $1 "$INSTDIR\kfreebsd.gz"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
    StrCpy $0 "$EXEDIR\$kfreebsd_module"
    StrCpy $1 "$INSTDIR\initrd.gz"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
  ${ElseIf} $kernel == "hurd"
    ClearErrors
    StrCpy $0 "$EXEDIR\$gnumach"
    StrCpy $1 "$INSTDIR\gnumach.gz"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
    StrCpy $0 "$EXEDIR\$ext2fs"
    StrCpy $1 "$INSTDIR\ext2fs.static"
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
    StrCpy $0 "$EXEDIR\$ld"
    StrCpy $1 "$INSTDIR\ld.so.1"
    CopyFiles /FILESONLY "$0" "$1"
    IfErrors 0 +3
      MessageBox MB_OK|MB_ICONSTOP "$(error_copyfiles)"
      Quit
  ${EndIf}
!else ;NOCD
!ifdef PXE
 ${If} $pxe_mode == "false"
!endif ;PXE
  ; Enable cancel button and make download controls visible
  EnableWindow $mui.Button.Cancel 1
  Push 1
  Call Download_ShowControls
  ${If} $base_path_hashes != ""
    ; Remove trailing / from $base_url
    StrCpy $1 "$base_url" -1
    ; Download the Release and Release.gpg files
    Push "false"
    Push "false"
    Push "Release"
    Push "$PLUGINSDIR"
    Push "$1"
    Call Download
    Pop $0
    Push "false"
    Push "false"
    Push "Release.gpg"
    Push "$PLUGINSDIR"
    Push "$1"
    Call Download
    Pop $0

    EnableWindow $mui.Button.Cancel 0
    ; Now check gpg validity of this
    File /oname=$PLUGINSDIR\gpgv.exe /usr/share/win32/gpgv.exe
    File /oname=$PLUGINSDIR\debian-archive-keyring.gpg /usr/share/keyrings/debian-archive-keyring.gpg
    File /oname=$PLUGINSDIR\debian-archive-removed-keys.gpg /usr/share/keyrings/debian-archive-removed-keys.gpg
    StrCpy $0 "Release"
    DetailPrint $(gpg_checking_release)
    Push "$OUTDIR"
    SetOutPath "$PLUGINSDIR"
    nsExec::Exec 'gpgv.exe --keyring ".\debian-archive-removed-keys.gpg" --keyring ".\debian-archive-keyring.gpg" Release.gpg Release'
    Pop $0
    ${If} $0 != 0
      StrCpy $0 "Release"
      MessageBox MB_OK|MB_ICONSTOP "$(unsecure_release)"
      Quit
    ${EndIf}
    Pop $0
    SetOutPath "$0"
    EnableWindow $mui.Button.Cancel 1

    ; Get SHA256SUMS file SHA1SUM
    Push "$PLUGINSDIR\Release"
    Push "$base_path_hashesSHA256SUMS"
    Call Get_SHA256_ref
    ; SHA-256 is on the stack.
  ${Else}
    Push "false" ; Don't try to compare the SHA1SUM (daily images don't have that).
  ${EndIf}
  
  ; Download the SHA256SUMS file
  ; SHA-1 or "false" is on the stack
  Push "false"
  Push "SHA256SUMS"
  Push "$PLUGINSDIR"
  Push "$base_url$base_path_hashes"
  Call Download
  Pop $0

  ${If} $kernel == "linux"
    Push "$PLUGINSDIR\SHA256SUMS"
    Push "$base_path_images/linux"
    Call Get_SHA256_ref
    ; SHA256 is on stack
    Push "false"
    Push "linux"
    Push "$INSTDIR"
    Push "$base_url$base_path_hashes$base_path_images"
    Call Download
    Pop $0
    
    Push "$PLUGINSDIR\SHA256SUMS"
    Push "$base_path_images/initrd.gz"
    Call Get_SHA256_ref
    ; SHA256 is on stack
    Push "false"
    Push "initrd.gz"
    Push "$INSTDIR"
    Push "$base_url$base_path_hashes$base_path_images"
    Call Download
    Pop $0
  ${ElseIf} $kernel == "kfreebsd"
    Push "$PLUGINSDIR\SHA256SUMS"
    Push "$base_path_images/kfreebsd.gz"
    Call Get_SHA256_ref
    ; SHA256 is on stack
    Push "false"
    Push "kfreebsd.gz"
    Push "$INSTDIR"
    Push "$base_url$base_path_hashes$base_path_images"
    Call Download
    Pop $0

    Push "$PLUGINSDIR\SHA256SUMS"
    Push "$base_path_images/initrd.gz"
    Call Get_SHA256_ref
    ; SHA256 is on stack
    Push "false"
    Push "initrd.gz"
    Push "$INSTDIR"
    Push "$base_url$base_path_hashes$base_path_images"
    Call Download
    Pop $0
  ${ElseIf} $kernel == "hurd"
    Push "$PLUGINSDIR\SHA256SUMS"
    Push "$base_path_images/gnumach.gz"
    Call Get_SHA256_ref
    ; SHA256 is on stack
    Push "false"
    Push "gnumach.gz"
    Push "$INSTDIR"
    Push "$base_url$base_path_hashes$base_path_images"
    Call Download
    Pop $0

    Push "$PLUGINSDIR\SHA256SUMS"
    Push "$base_path_images/ext2fs.static"
    Call Get_SHA256_ref
    ; SHA256 is on stack
    Push "false"
    Push "ext2fs.static"
    Push "$INSTDIR"
    Push "$base_url$base_path_hashes$base_path_images"
    Call Download
    Pop $0

    Push "$PLUGINSDIR\SHA256SUMS"
    Push "$base_path_images/initrd.gz"
    Call Get_SHA256_ref
    ; SHA256 is on stack
    Push "false"
    Push "initrd.gz"
    Push "$INSTDIR"
    Push "$base_url$base_path_hashes$base_path_images"
    Call Download
    Pop $0

    Push "$PLUGINSDIR\SHA256SUMS"
    Push "$base_path_images/ld.so.1"
    Call Get_SHA256_ref
    ; SHA256 is on stack
    Push "false"
    Push "ld.so.1"
    Push "$INSTDIR"
    Push "$base_url$base_path_hashes$base_path_images"
    Call Download
    Pop $0
  ${EndIf}
  ; Hide download controls and disable cancel button
  Push 0
  Call Download_ShowControls
  EnableWindow $mui.Button.Cancel 0
!ifdef PXE
 ${EndIf} ; $pxe_mode == "false"
!endif ;PXE
!endif

; We're about to write down our preseed line.  This would be a nice place
; to add post-install parameters.
  StrCpy $preseed_cmdline "$preseed_cmdline ---"

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
  ${ElseIf} $kernel == "hurd"
    FileWrite $0 "\
multiboot		/win32-loader/gnumach.gz root=gunzip:device:rd0 $preseed_cmdline$\n\
module --nounzip	/win32-loader/initrd.gz initrd '$$(ramdisk-create)'$\n\
module 			/win32-loader/ext2fs.static ext2fs \$\n\
			--multiboot-command-line='$${kernel-command-line}' \$\n\
			--host-priv-port='$${host-port}' \$\n\
			--device-master-port='$${device-port}' \$\n\
			--exec-server-task='$${exec-task}' -T typed '$${root}' \$\n\
			'$$(task-create)' '$$(task-resume)'$\n\
module			/win32-loader/ld.so.1 exec /hurd/exec '$$(exec-task=task-create)'$\n\
boot$\n"
  ${EndIf}
!ifdef PXE
 ${EndIf} ; $pxe_mode == "true"
!endif ;PXE
  FileClose $0

!ifdef PXE
 ${If} $pxe_mode == "false"
!endif ; PXE

; TODO: FIX THIS FOR kFreeBSD
${If} $kernel == "linux"
  ; ********************************************** cpio hack
  StrCpy $1 "preseed.cfg"
  StrCpy $2 "newc_chunk"
  StrCpy $3 "initrd.gz"
  StrCpy $4 "gzip.exe"
  File "/oname=$INSTDIR\$4" /usr/share/win32/gzip.exe

  StrCpy $0 "$INSTDIR\$3"
  DetailPrint "$(appending_preseeding)"

  ; IMPORTANT!!  All accessed files must be in the same
  ; filesystem as the script itself, because cmd.exe/command.com gets
  ; confused when using absolute paths.  This is why $INSTDIR is used
  ; instead of $PLUGINSDIR.

  StrCpy $0 "$1"
  ClearErrors
  FileOpen $5 "$1" w
  ${IfNot} ${Errors}
    FileWrite $5 "$preseed_cfg$\n"
    FileClose $5
    ${IfNot} ${Errors}
      StrCpy $0 "$2"
      FileOpen $5 "$2" w
      ${IfNot} ${Errors}
        ${CPIO_Write} $5 "$1" $0
        ${If} $0 == 0
          ${CPIO_Write} $5 "" $0
        ${EndIf}
        ${If} $0 != 0
          StrCpy $0 "$2"
        ${Else}
          ExpandEnvStrings $0 '"%COMSPEC%" "/C .\$4 -1 <$2 >>$3"'
          nsExec::Exec '$0'
          Pop $0
          ${If} $0 != 0
            StrCpy $0 "$INSTDIR\$4"
          ${Else}
            StrCpy $0 ""
          ${EndIf}
        ${EndIf}
        FileClose $5
      ${EndIf}
    ${EndIf}
  ${EndIf}

  ${If} $0 != ""
    MessageBox MB_OK|MB_ICONSTOP "$(error_exec)"
    Quit
  ${EndIf}
${EndIf}
!ifdef PXE
 ${EndIf} ; $pxe_mode == "false"
!endif ; PXE

; ********************************************** Do bootloader last, because it's the most dangerous
  ${If} $windows_boot_method == ntldr
!ifdef NOCD
       File /oname=$c\g2ldr "${BUILD_DIR}/g2ldr"
       File /oname=$c\g2ldr.mbr "${BUILD_DIR}/g2ldr.mbr"
      !ifdef PXE
       ${If} $pxe_mode == "true"
          File /oname=$INSTDIR\pxe.lkrn "${BUILD_DIR}/pxe.lkrn"
       ${EndIf} ; $pxe_mode == "true"
      !endif ; PXE
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
    StrCpy $1 "$(pxe)"
   ${Else}
!endif ; PXE
    StrCpy $1 "$(d-i)"
!ifdef PXE
   ${EndIf} ; $pxe_mode == "true"
!endif ; PXE
   System::Call "kernel32::WideCharToMultiByte(i 850, i 0, w r1, i -1, \
     m.r2, i${NSIS_MAX_STRLEN}, p 0, p 0) i.r0"
   WriteIniStr "$c\boot.ini" "operating systems" "$c\g2ldr.mbr" '"$2"'
  ${Endif}

  ${If} $windows_boot_method == direct
    File /oname=$INSTDIR\loadlin.exe "${BUILD_DIR}/loadlin.exe"
    File /oname=$INSTDIR\loadlin.pif "${BUILD_DIR}/loadlin.pif"
  ${Endif}

  ${If} $windows_boot_method == bootmgr
!ifdef NOCD
       File /oname=$c\g2ldr "${BUILD_DIR}/g2ldr"
       File /oname=$c\g2ldr.mbr "${BUILD_DIR}/g2ldr.mbr"
      !ifdef PXE
       ${If} $pxe_mode == "true"
          File /oname=$INSTDIR\pxe.lkrn "${BUILD_DIR}/pxe.lkrn"
       ${EndIf} ; $pxe_mode == "true"
      !endif ; PXE
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
    DetailPrint "$(registering_bootmgr)"
    Call CreateBootEntry
  ${Endif}

; ********************************************** Needed for systems with compressed NTFS
  DetailPrint "$(disabling_ntfs_compression)"
  nsExec::Exec '"compact" /u $c\g2ldr $c\g2ldr.mbr $INSTDIR\grub.cfg'
  ; in my tests, uncompressing $INSTDIR\grub.cfg wasn't necessary, but better be safe than sorry
  ${If} $kernel == "linux"
    nsExec::Exec '"compact" /u $INSTDIR\linux $INSTDIR\initrd.gz'
  ${ElseIf} $kernel == "kfreebsd"
    nsExec::Exec '"compact" /u $INSTDIR\kfreebsd.gz $INSTDIR\initrd.gz'
  ${ElseIf} $kernel == "hurd"
    nsExec::Exec '"compact" /u $INSTDIR\gnumach.gz $INSTDIR\ext2fs.static $INSTDIR\initrd.gz $INSTDIR\ld.so.1'
  ${EndIf}
!ifdef PXE
  ${If} $pxe_mode == "true"
    nsExec::Exec '"compact" /u $INSTDIR\pxe.lkrn'
  ${EndIf}
!endif ;PXE
SectionEnd
