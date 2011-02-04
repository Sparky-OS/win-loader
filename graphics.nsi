Function ShowGraphics
  Var /GLOBAL user_interface
  Var /GLOBAL gtk

!ifndef NOCD
  Var /GLOBAL predefined_user_interface
  ReadINIStr $predefined_user_interface $d\win32-loader.ini "installer" "user_interface"

  ${If} $predefined_user_interface == ""
!endif
    ${If} $expert == true
     ${AndIf} $kernel == "linux"
      File /oname=$PLUGINSDIR\graphics.ini	templates/graphics.ini
      File /oname=$PLUGINSDIR\gtk.bmp	templates/gtk.bmp
      File /oname=$PLUGINSDIR\text.bmp	templates/text.bmp
      WriteINIStr $PLUGINSDIR\graphics.ini "Field 1" "Text" $(graphics1)
      WriteINIStr $PLUGINSDIR\graphics.ini "Field 2" "Text" "$PLUGINSDIR\gtk.bmp"
      WriteINIStr $PLUGINSDIR\graphics.ini "Field 3" "Text" "$PLUGINSDIR\text.bmp"
      WriteINIStr $PLUGINSDIR\graphics.ini "Field 4" "Text" $(graphics2)
      WriteINIStr $PLUGINSDIR\graphics.ini "Field 5" "Text" $(graphics3)
      InstallOptions::dialog $PLUGINSDIR\graphics.ini
      ReadINIStr $0 $PLUGINSDIR\graphics.ini "Field 4" "State"
      ${If} $0 == "1"
        StrCpy $user_interface graphical
      ${EndIf}
    ${ElseIf} $kernel == linux
      ; ** Default to graphical interface for linux
      StrCpy $user_interface graphical
    ${Endif}
!ifndef NOCD
  ${Else}
    StrCpy $user_interface $predefined_user_interface
  ${Endif}
!endif

${If} $user_interface == "graphical"
  StrCpy $gtk "gtk/"
${Endif}

; ********************************************** Preseed vga mode
  ${If} "$user_interface" == "graphical"
    StrCpy $preseed_cmdline "$preseed_cmdline video=vesa:ywrap,mtrr vga=788"
  ${Else}
    StrCpy $preseed_cmdline "$preseed_cmdline vga=normal"
  ${EndIf}
FunctionEnd
