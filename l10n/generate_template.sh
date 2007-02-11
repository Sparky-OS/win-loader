#!/bin/bash -e

case $LANGUAGE in
  cs)
	charset=windows-1250 ;;
  ca|es|de|fr|sv)
	charset=windows-1252 ;;
  *)	charset=windows-1252 ;;
esac

. /usr/bin/gettext.sh
export TEXTDOMAIN=win32-loader
export TEXTDOMAINDIR=${PWD}/locale

iconv -f utf-8 -t ${charset} << EOF | sed -e "s/@DOLLAR@/$/g"
LoadLanguageFile "\${NSISDIR}\Contrib\Language files\\`gettext English.nlf`"
LicenseLangString license \${`gettext LANG_ENGLISH`} license\en.txt
LangString program_name \${`gettext LANG_ENGLISH`} "`gettext "Debian-Installer Loader"`"
LangString d-i \${`gettext LANG_ENGLISH`} "`gettext "Debian Installer"`"
LangString not_enough_space_for_debian \${`gettext LANG_ENGLISH`} "`gettext "There doesn't seem to be enough free disk space in drive @DOLLAR@c.  For a complete desktop install, it is recommended that you have at least 3 GB of free disk.  If there is already a separate disk or partition to install Debian, or if you plan to replace Windows completely, you can safely ignore this warning."`"
LangString not_enough_space_for_loader \${`gettext LANG_ENGLISH`} "`gettext "Error: not enough free disk space.  Aborting install."`"
LangString graphics1 \${`gettext LANG_ENGLISH`} "`gettext "Select install mode:"`"
LangString graphics2 \${`gettext LANG_ENGLISH`} "`gettext "Graphical install (recommended)"`"
LangString graphics3 \${`gettext LANG_ENGLISH`} "`gettext "Text install"`"
LangString custom1 \${`gettext LANG_ENGLISH`} "`gettext "Debian-Installer Loader will be setup with the following parameters.  Do NOT change any of these unless you know what you're doing."`"
LangString custom2 \${`gettext LANG_ENGLISH`} "`gettext "NSISdl proxy settings (host:port):"`"
LangString custom3 \${`gettext LANG_ENGLISH`} "`gettext "Location of boot.ini:"`"
LangString custom4 \${`gettext LANG_ENGLISH`} "`gettext "Debconf preseed line:"`"
LangString custom5 \${`gettext LANG_ENGLISH`} "`gettext "Base URL for netboot images (linux and initrd.gz):"`"
LangString nsisdl1 \${`gettext LANG_ENGLISH`} "`gettext "Downloading %s"`"
LangString nsisdl2 \${`gettext LANG_ENGLISH`} "`gettext "Connecting ..."`"
LangString nsisdl3 \${`gettext LANG_ENGLISH`} "`gettext "second"`"
LangString nsisdl4 \${`gettext LANG_ENGLISH`} "`gettext "minute"`"
LangString nsisdl5 \${`gettext LANG_ENGLISH`} "`gettext "hour"`"
LangString nsisdl6 \${`gettext LANG_ENGLISH`} "`gettext "s"`"
; This string is appended to "second", "minute" or "hour" to make plurals.
; I know it's quite unfortunate.  An alternate method for translating NSISdl
; has been proposed [1] but in the meantime we'll have to cope with this.
; [1] http://sourceforge.net/tracker/index.php?func=detail&aid=1656076&group_id=22049&atid=373087
LangString nsisdl7 \${`gettext LANG_ENGLISH`} "`gettext "%dkB (%d%%) of %dkB at %d.%01dkB/s"`"
LangString nsisdl8 \${`gettext LANG_ENGLISH`} "`gettext " (%d %s%s remaining)"`"
LangString error \${`gettext LANG_ENGLISH`} "`gettext "Error"`"
LangString boot_ini_not_found \${`gettext LANG_ENGLISH`} "`gettext "Error: @DOLLAR@boot_ini not found.  Your version of Windows might be too old, or damaged."`"
LangString warning \${`gettext LANG_ENGLISH`} "`gettext "VERY IMPORTANT NOTICE:\n\nYou need to reboot in order to proceed with your Debian install.  During your next boot, you will be asked whether you want to start Windows or Debian Installer.  Choose Debian Installer to continue the install process.\n\nDuring the install process, you will be offered the possibility of either reducing your Windows partition to install Debian or completely replacing it.  In both cases, it is STRONGLY RECOMMENDED that you have previously made a backup of your data.  Nor the authors of this loader neither the Debian project will take ANY RESPONSIBILITY in the event of data loss.\n\nOnce your Debian install is complete (and if you have chosen to keep Windows in your disk), you can uninstall the Debian-Installer Loader through the Windows Add/Remove Programs dialog in Control Panel."`"
LangString reboot_now \${`gettext LANG_ENGLISH`} "`gettext "Do you want to reboot now?"`"
EOF
