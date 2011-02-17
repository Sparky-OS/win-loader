Function Download
    ; Base URL
    Pop $0
    ; Target dir
    Pop $1
    ; Filename
    Pop $2
    ; Allow it to fail?
    Pop $3
    ; Check its md5sum ?
    Pop $4
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
         MessageBox MB_OK|MB_ICONSTOP "$(error): $0/$2 $R0"
      ${EndIf}
      ${If} $3 == "false"
        Quit
      ${Endif}
    ${EndIf}

    ${If} $4 != "false"
      ; $2 goes in the text
      DetailPrint "$(computing_checksum)"
      ; Compute md5sum of downloaded file, put it as $1
      VPatch::GetFileMD5 $1\$2
      Pop $1
      ${If} $4 != $1
       MessageBox MB_OK|MB_ICONSTOP "$(checksum_mismatch)"
       Quit
      ${EndIf}
      DetailPrint "$4 = $1"
    ${EndIf}

    Push "$R0"
FunctionEnd

Function Get_MD5_ref
    ; Url we are looking for
    Pop $0
    ; MD5SUMS file
    Pop $1
    ClearErrors
    FileOpen $3 "$PLUGINSDIR\MD5SUMS" r
    IfErrors done ; Make sure it's readable
  readline:
    FileRead $3 $4
    IfErrors endoffile
    StrCpy $5 $4 -1 36 ; md5sum + spaces and ./, -1 to get rid of newline
    ; Compare what we want with what we have
    StrCmpS $0 $5 0 readline
    StrCpy $0 $4 32 ; Copying the found md5sum to $0
    Push $0
    FileClose $3
    Goto done
  endoffile:
    Push "false"
    FileClose $3
  done:
FunctionEnd
