#!/bin/bash -e

# make sure gettext output is in UTF-8
unset LC_CTYPE
while read a b ; do
  if [ "$b" = "UTF-8" ] ; then
    export LC_CTYPE=$a
    break
  fi
done < /etc/locale.gen
if ! [ "$LC_CTYPE" ] ; then
  echo "Run \"sudo dpkg-reconfigure locales\" and add at least one UTF-8 locale there."
  exit 1
fi

. /usr/bin/gettext.sh
export TEXTDOMAIN=win32-loader
export TEXTDOMAINDIR=${PWD}/locale

# translate: This must be the string used by Windows to represent your
# translate: language.  If you don't know, check [wine]/tools/wmc/lang.c,
# translate: or http://www.microsoft.com/globaldev/reference/WinCP.mspx
charset=`gettext windows-1252`

# translate: This must be a valid string recognised by Nsis.  If your
# translate: language is not yet supported by Nsis, please translate the
# translate: missing Nsis part first.
nsis_lang=`gettext LANG_ENGLISH`

grep -v "^# translate:" << EOF | iconv -f utf-8 -t ${charset} | sed -e "s/@DOLLAR@/$/g"
# translate: The nlf file for your language should be found in
# translate: /usr/share/nsis/Contrib/Language files/
LoadLanguageFile "\${NSISDIR}\Contrib\Language files\\`gettext English.nlf`"
LicenseLangString license \${$nsis_lang} license\en.txt
# translate: Please do NOT use double quotes (") anywhere from now on.  These break build!
# translate: You may, however, use single quotes (') or « » just fine.
# translate: Also note that only the subset of UTF-8 that can be converted to the
# translate: corresponding windows-xxxx charset should be used.
LangString program_name \${$nsis_lang} "`gettext "Debian-Installer Loader"`"
LangString d-i \${$nsis_lang} "`gettext "Debian Installer"`"
LangString not_enough_space_for_debian \${$nsis_lang} "`gettext "There doesn't seem to be enough free disk space in drive @DOLLAR@c.  For a complete desktop install, it is recommended to have at least 3 GB of free disk.  If there is already a separate disk or partition to install Debian, or if you plan to replace Windows completely, you can safely ignore this warning."`"
LangString not_enough_space_for_loader \${$nsis_lang} "`gettext "Error: not enough free disk space.  Aborting install."`"
LangString expert1 \${$nsis_lang} "`gettext "Select install mode:"`"
LangString expert2 \${$nsis_lang} "`gettext "Normal mode.  Recommended for most users."`"
LangString expert3 \${$nsis_lang} "`gettext "Expert mode.  Recommended for expert users who want full control of the install process."`"
LangString graphics1 \${$nsis_lang} "`gettext "Select install mode:"`"
LangString graphics2 \${$nsis_lang} "`gettext "Graphical install"`"
LangString graphics3 \${$nsis_lang} "`gettext "Text install"`"
LangString custom1 \${$nsis_lang} "`gettext "Debian-Installer Loader will be setup with the following parameters.  Do NOT change any of these unless you know what you're doing."`"
LangString custom2 \${$nsis_lang} "`gettext "Proxy settings (host:port):"`"
LangString custom3 \${$nsis_lang} "`gettext "Location of boot.ini:"`"
LangString custom4 \${$nsis_lang} "`gettext "Debconf preseed line:"`"
LangString custom5 \${$nsis_lang} "`gettext "Base URL for netboot images (linux and initrd.gz):"`"
LangString nsisdl1 \${$nsis_lang} "`gettext "Downloading %s"`"
LangString nsisdl2 \${$nsis_lang} "`gettext "Connecting ..."`"
LangString nsisdl3 \${$nsis_lang} "`gettext "second"`"
LangString nsisdl4 \${$nsis_lang} "`gettext "minute"`"
LangString nsisdl5 \${$nsis_lang} "`gettext "hour"`"
# translate: This string is appended to "second", "minute" or "hour" to make plurals.
# translate: I know it's quite unfortunate.  An alternate method for translating NSISdl
# translate: has been proposed [1] but in the meantime we'll have to cope with this.
# translate: [1] http://sourceforge.net/tracker/index.php?func=detail&aid=1656076&group_id=22049&atid=373087
LangString nsisdl6 \${$nsis_lang} "`gettext "s"`"
LangString nsisdl7 \${$nsis_lang} "`gettext "%dkB (%d%%) of %dkB at %d.%01dkB/s"`"
LangString nsisdl8 \${$nsis_lang} "`gettext " (%d %s%s remaining)"`"
LangString error \${$nsis_lang} "`gettext "Error"`"
LangString boot_ini_not_found \${$nsis_lang} "`gettext "Error: @DOLLAR@boot_ini not found.  Your version of Windows might be too old, or damaged."`"
LangString warning \${$nsis_lang} "`gettext "VERY IMPORTANT NOTICE:\n\nYou need to reboot in order to proceed with your Debian install.  During your next boot, you will be asked whether you want to start Windows or Debian Installer.  Choose Debian Installer to continue the install process.\n\nDuring the install process, you will be offered the possibility of either reducing your Windows partition to install Debian or completely replacing it.  In both cases, it is STRONGLY RECOMMENDED that you have previously made a backup of your data.  Nor the authors of this loader neither the Debian project will take ANY RESPONSIBILITY in the event of data loss.\n\nOnce your Debian install is complete (and if you have chosen to keep Windows in your disk), you can uninstall the Debian-Installer Loader through the Windows Add/Remove Programs dialog in Control Panel."`"
LangString reboot_now \${$nsis_lang} "`gettext "Do you want to reboot now?"`"
EOF
