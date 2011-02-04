Function ShowRescue
!ifdef PXE
 ${If} $pxe_mode == "false"
!endif ;PXE
  File /oname=$PLUGINSDIR\rescue.ini	templates/binary_choice.ini
  WriteINIStr $PLUGINSDIR\rescue.ini "Field 1" "Text" $(rescue1)
  WriteINIStr $PLUGINSDIR\rescue.ini "Field 2" "Text" $(rescue2)
  WriteINIStr $PLUGINSDIR\rescue.ini "Field 3" "Text" $(rescue3)
  InstallOptions::dialog $PLUGINSDIR\rescue.ini

  ReadINIStr $0 $PLUGINSDIR\rescue.ini "Field 3" "State"
  ${If} $0 == "1"
    StrCpy $preseed_cfg "\
$preseed_cfg$\n\
d-i rescue/enable boolean true"
  ${Endif}
!ifdef PXE
 ${Endif} ; $pxe_mode == "false"
!endif ;PXE
FunctionEnd

