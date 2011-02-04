Function ShowDesktop
  ; It appears that "desktop" is a reserved keyword, hence the _ prefix
  Var /GLOBAL _desktop
!ifndef NOCD
  ReadINIStr $0 $d\win32-loader.ini "installer" "default_desktop"
  ${If} $0 == ""
    StrCpy $_desktop "gnome"
  ${Else}
    StrCpy $_desktop $0
  ${Endif}
!else
  StrCpy $_desktop "gnome"
!endif

  ; Prepare the dialog
  File /oname=$PLUGINSDIR\desktop.ini	templates/4_choices.ini
  WriteINIStr $PLUGINSDIR\desktop.ini	"Field 1" "Text" $(desktop1)
  WriteINIStr $PLUGINSDIR\desktop.ini	"Field 2" "Text" "GNOME"
  ${If} $_desktop == "gnome"
    WriteINIStr $PLUGINSDIR\desktop.ini	"Field 2" "State" "1"
  ${Endif}
  WriteINIStr $PLUGINSDIR\desktop.ini	"Field 3" "Text" "KDE"
  ${If} $_desktop == "kde"
    WriteINIStr $PLUGINSDIR\desktop.ini	"Field 2" "State" "1"
  ${Endif}
  WriteINIStr $PLUGINSDIR\desktop.ini	"Field 4" "Text" "Xfce"
  ${If} $_desktop == "xfce"
    WriteINIStr $PLUGINSDIR\desktop.ini	"Field 2" "State" "1"
  ${Endif}
  WriteINIStr $PLUGINSDIR\desktop.ini	"Field 5" "Text" $(desktop2)

  ; Display it (only in expert mode)
  ${If} $expert == true
    InstallOptions::dialog $PLUGINSDIR\desktop.ini
  ${Endif}

  ; Read from it
  ReadINIStr $0 $PLUGINSDIR\desktop.ini "Field 3" "State"
  ${If} $0 == "1"
    StrCpy $_desktop "kde"
  ${Endif}
  ReadINIStr $0 $PLUGINSDIR\desktop.ini "Field 4" "State"
  ${If} $0 == "1"
    StrCpy $_desktop "xfce"
  ${Endif}

  ; Add the results to our preseed file
  StrCpy $preseed_cfg "\
$preseed_cfg$\n\
tasksel tasksel/desktop multiselect $_desktop-desktop$\n\
tasksel tasksel/desktop seen false"
FunctionEnd
