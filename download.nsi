Function Download
    ; Base URL
    Pop $0
    ; Target dir
    Pop $1
    ; Filename
    Pop $2
    ; Allow it to fail?
    Pop $3
    Var /GLOBAL nsisdl_proxy
    ${If} $proxy == ""
      StrCpy $nsisdl_proxy /NOIEPROXY
    ${Else}
      StrCpy $nsisdl_proxy "/PROXY $proxy"
    ${Endif}

    NSISdl::download /TRANSLATE $(nsisdl1) $(nsisdl2) $(nsisdl3) $(nsisdl4) $(nsisdl5) $(nsisdl6) $(nsisdl7) $(nsisdl8) $nsisdl_proxy $0/$2 $1\$2
    Pop $R0
    ${If} $R0 != "success"
      ${If} $R0 != "cancel"
         MessageBox MB_OK|MB_ICONSTOP "$(error): $R0"
      ${EndIf}
      ${If} $3 == "false"
        Quit
      ${Endif}
    ${EndIf}
    StrCpy $0 "$R0"
FunctionEnd
