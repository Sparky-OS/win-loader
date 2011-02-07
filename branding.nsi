!ifndef _EN_PROGRAM_NAME
 # Keep that in sync that with l10/win32-loader.c
 !define _EN_PROGRAM_NAME "Installer loader"
!endif
!ifndef _PRODUCT_NAME
 !define _PRODUCT_NAME "win32-loader"
!endif
!ifndef _OUTFILE_NAME
 !define _OUTFILE_NAME "win32-loader.exe"
!endif
!ifndef _PROGRAM_ICON
 !define _PROGRAM_ICON "swirl.ico"
!endif
!ifdef OPTIONS_TXT
 !define VERSION_OPT "${VERSION} (${OPTIONS_TXT})"
!else
 !define VERSION_OPT "${VERSION}"
!endif

XPStyle on

Name ${_EN_PROGRAM_NAME}
Icon ${_PROGRAM_ICON}
UninstallIcon ${_PROGRAM_ICON}
OutFile ${_OUTFILE_NAME}

VIProductVersion "${4DIGITS_DATE}"

VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "The Debian Project"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${_EN_PROGRAM_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${_PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${VERSION_OPT}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "GPLv3+"

BrandingText "${_PRODUCT_NAME} ${VERSION_OPT}"
