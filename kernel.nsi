Function ShowKernel
  Var /GLOBAL kernel 
!ifdef NOCD
 !ifdef KFREEBSD
  ${If} $expert == true
  ${AndIf} $windows_boot_method != direct ; loadlin can only load linux
    File /oname=$PLUGINSDIR\kernel.ini	templates/binary_choice.ini
    WriteINIStr $PLUGINSDIR\kernel.ini "Field 1" "Text" $(kernel1)
    WriteINIStr $PLUGINSDIR\kernel.ini "Field 2" "Text" $(kernel2)
    WriteINIStr $PLUGINSDIR\kernel.ini "Field 3" "Text" $(kernel3)
    InstallOptions::dialog $PLUGINSDIR\kernel.ini
 
    ReadINIStr $0 $PLUGINSDIR\kernel.ini "Field 3" "State"
    ${If} $0 == "1"
      StrCpy $kernel kfreebsd
    ${Else}
      StrCpy $kernel linux
    ${Endif}
  ${Else}
    ; ** Default to GNU/Linux
    StrCpy $kernel linux
  ${Endif}
 !else ; KFREEBSD
    StrCpy $kernel linux
 !endif ; KFREEBSD
!else
  ; TODO: detect the CD architecture
  StrCpy $kernel linux
!endif
  Var /GLOBAL kernel_name
  ${If} $kernel == "kfreebsd"
    StrCpy $kernel_name "GNU/kFreeBSD"
  ${ElseIf} $kernel == "linux"
    StrCpy $kernel_name "GNU/Linux"
  ${EndIf}
FunctionEnd

