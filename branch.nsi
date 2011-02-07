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
  Var /GLOBAL base_url
  ReadINIStr $0 $PLUGINSDIR\di_branch.ini "Field 3" "State"
  ${If} $di_branch == "daily"
    MessageBox MB_YESNO|MB_ICONQUESTION $(di_branch4) IDNO +2
    ExecShell "open" "http://wiki.debian.org/DebianInstaller/Today"

    ; Daily images URL
    ; See http://svn.debian.org/viewsvn/d-i/trunk/scripts/daily-build-aggregator for the canonical list
    ${If} $kernel == "linux"
      ${If} $arch == "i386"
        StrCpy $base_url "http://people.debian.org/~joeyh/d-i/images/daily/netboot/$gtkdebian-installer/$arch"
      ${Else} ; We have only two arches, then Else means $arch == "amd64"
        StrCpy $base_url "http://d-i.debian.org/daily-images/$arch/daily/netboot/$gtkdebian-installer/$arch"
      ${Endif}
    ${ElseIf} $kernel == "kfreebsd"
      StrCpy $base_url "http://d-i.debian.org/daily-images/kfreebsd-$arch/daily/netboot/debian-installer/kfreebsd-$arch/"
    ${EndIf}
  ${Else}
    ${If} $kernel == "linux"
      StrCpy $base_url "http://cdn.debian.net/debian/dists/stable/main/installer-$arch/current/images/netboot/$gtkdebian-installer/$arch"
    ${ElseIf} $kernel == "kfreebsd"
      StrCpy $base_url "http://cdn.debian.net/debian/dists/stable/main/installer-kfreebsd-$arch/current/images/netboot/$gtkdebian-installer/kfreebsd-$arch"
    ${EndIf}
  ${Endif}
FunctionEnd
