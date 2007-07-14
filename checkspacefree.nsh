; Obtained from http://nsis.sourceforge.net/CheckSpaceFree

; In response to http://lists.debian.org/debian-boot/2007/02/msg00191.html
;
; On Tue, Feb 06, 2007 at 09:30:19PM +0200, Amir Szekely wrote:
; > As Ximon has named me as the decision maker on this one, I hereby
; > declare this code as licensed under the zlib license. All new content on
; > the website shall now be licensed under zlib, unless specified otherwise
; > by the author.

; $0 - space required in kb
; $1 - path to check
; $2 - 0 = ignore quotas, 1 = obey quotas
; trashes $2
function CheckSpaceFunc
  systeminfo::freespace $2 $1
  Pop $2
  System::Int64Op $2 / 1024
  Pop $2
  ; check space
  System::Int64Op $2 > $0
  Pop $2
functionend
