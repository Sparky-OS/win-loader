; Obtained from http://nsis.sourceforge.net/CheckSpaceFree

; On Tue, Feb 06, 2007 at 09:30:19PM +0200, Amir Szekely wrote:
; > As Ximon has named me as the decision maker on this one, I hereby
; > declare this code as licensed under the zlib license. All new content on
; > the website shall now be licensed under zlib, unless specified otherwise
; > by the author.

!addplugindir contrib
!define sysGetDiskFreeSpaceEx 'kernel32::GetDiskFreeSpaceExA(t, *l, *l, *l) i'
 
; $0 - space required in kb
; $1 - path to check
; $2 - 0 = ignore quotas, 1 = obey quotas
; trashes $2
function CheckSpaceFunc
  IntCmp $2 0 ignorequota
  ; obey quota
  System::Call '${sysGetDiskFreeSpaceEx}(r1,.r2,,.)'
  goto converttokb
  ; ignore quota
  ignorequota:
  System::Call '${sysGetDiskFreeSpaceEx}(r1,.,,.r2)'
  converttokb:
  ; convert the large integer byte values into managable kb
  System::Int64Op $2 / 1024
  Pop $2
  ; check space
  System::Int64Op $2 > $0
  Pop $2
functionend
