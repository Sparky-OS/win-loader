; Debian-Installer Loader - Desktop selection
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
  ${If} $kernel == "linux"
    StrCpy $_desktop "gnome"
  ${Else}
    StrCpy $_desktop "xfce"
  ${EndIf}
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
    WriteINIStr $PLUGINSDIR\desktop.ini	"Field 3" "State" "1"
  ${Endif}
  WriteINIStr $PLUGINSDIR\desktop.ini	"Field 4" "Text" "Xfce"
  ${If} $_desktop == "xfce"
    WriteINIStr $PLUGINSDIR\desktop.ini	"Field 4" "State" "1"
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
