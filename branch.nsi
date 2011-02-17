; Debian-Installer Loader - Branch selection
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

Function ShowBranch
  Var /GLOBAL di_branch
  StrCpy $di_branch stable
  File /oname=$PLUGINSDIR\di_branch.ini	templates/binary_choice.ini
  ${If} $expert == true
    WriteINIStr $PLUGINSDIR\di_branch.ini "Field 1" "Text" $(di_branch1)
    WriteINIStr $PLUGINSDIR\di_branch.ini "Field 2" "Text" $(di_branch2)
    WriteINIStr $PLUGINSDIR\di_branch.ini "Field 3" "Text" $(di_branch3)
    InstallOptions::dialog $PLUGINSDIR\di_branch.ini
    ReadINIStr $0 $PLUGINSDIR\di_branch.ini "Field 3" "State"
    ${If} $0 == "1"
      StrCpy $di_branch daily
    ${Endif}
  ${Endif}

; ********************************************** Initialise base_url
  Var /GLOBAL base_url_images
  Var /GLOBAL base_url
  ReadINIStr $0 $PLUGINSDIR\di_branch.ini "Field 3" "State"
  ${If} $di_branch == "daily"
    MessageBox MB_YESNO|MB_ICONQUESTION $(di_branch4) IDNO +2
    ExecShell "open" "http://wiki.debian.org/DebianInstaller/Today"

    ; Daily images URL
    ; See http://svn.debian.org/viewsvn/d-i/trunk/scripts/daily-build-aggregator for the canonical list
    ${If} $kernel == "linux"
      ${If} $arch == "i386"
        StrCpy $base_url_images "http://people.debian.org/~joeyh/d-i/images/daily/"
        StrCpy $base_url "netboot/$gtkdebian-installer/$arch"
      ${Else} ; We have only two arches, then Else means $arch == "amd64"
        StrCpy $base_url_images "http://d-i.debian.org/daily-images/$arch/daily/"
        StrCpy $base_url "netboot/$gtkdebian-installer/$arch"
      ${Endif}
    ${ElseIf} $kernel == "kfreebsd"
      StrCpy $base_url_images "http://d-i.debian.org/daily-images/kfreebsd-$arch/daily/"
      StrCpy $base_url "netboot/debian-installer/kfreebsd-$arch"
    ${EndIf}
  ${Else}
    ${If} $kernel == "linux"
      StrCpy $base_url_images "http://cdn.debian.net/debian/dists/stable/main/installer-$arch/current/images/"
      StrCpy $base_url "netboot/$gtkdebian-installer/$arch"
    ${ElseIf} $kernel == "kfreebsd"
      StrCpy $base_url_images "http://cdn.debian.net/debian/dists/stable/main/installer-kfreebsd-$arch/current/images/"
      StrCpy $base_url "netboot/$gtkdebian-installer/kfreebsd-$arch"
    ${EndIf}
  ${Endif}
FunctionEnd
