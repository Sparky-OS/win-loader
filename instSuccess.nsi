Function .onInstSuccess
  Var /GLOBAL warning2
  ${If} $windows_boot_method == direct
    StrCpy $warning2 $(warning2_direct)
  ${Else}
    StrCpy $warning2 $(warning2_reboot)
  ${Endif}
  MessageBox MB_OK '$(warning1)$warning2$(warning3)'
  ${If} $windows_boot_method == direct
    Exec '"$INSTDIR\loadlin.pif" linux $preseed_cmdline initrd=initrd.gz'
  ${Else}
    MessageBox MB_YESNO|MB_ICONQUESTION $(reboot_now) IDNO +2
    Reboot
  ${Endif}
FunctionEnd


