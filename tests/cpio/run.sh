#!/bin/sh
# Licensed under the zlib/libpng license (same as NSIS)
#
# Script to perform cpio tests
#
# Usage: run.sh [<helper dir [<Windows architecture> [<test dir>]]]

set -e

CPIO_NAME="archive.cpio"
OUTPUT="output.log"
SCRIPT="cpio_test.nsi"
SOURCEDIR=$(cd "$(dirname "$0")"; pwd -P)
TOPDIR=$(cd "${SOURCEDIR}/../.."; pwd -P)
HELPERDIR=${1:-"${TOPDIR}/build"}

INSTALLER="${SCRIPT%.*}.exe"

TESTID=

ERROR_SUCCESS=0
ERROR_FILE_NOT_FOUND=2
ERROR_INVALID_DATA=13

. "${SOURCEDIR}/../common/funcs.sh"

before() {
	make_installer "-XOutFile ${PWD}/${INSTALLER}" \
		"${SOURCEDIR}/${SCRIPT}"
}

after() {
	[ -n "${TESTID}" -a -f "${TESTID}" ] && rm "${TESTID}"
	[ -f "${CPIO_NAME}" ] && rm "${CPIO_NAME}"
	[ -f "${OUTPUT}" ] && rm "${OUTPUT}"
	[ -f "${INSTALLER}" ] && rm "${INSTALLER}"
}

run_installer() {
	${WINE} ${INSTALLER} /S "${1}" "/OUT=${CPIO_NAME}" "/RESULT=${OUTPUT}" \
	&& tail -n 1 ${OUTPUT}
}

test_it() {
	if [ $# -gt 0 ]; then
		t="${1}"
		echo "${t}"
		result=$(run_installer "/IN=${t}")
		if [ "${result}" = "${ERROR_SUCCESS}" ]; then
			cpio --extract --to-stdout < "${CPIO_NAME}" | \
				diff -q "${t}" -
			if [ $? -eq 0 ]; then
				[ -f "${t}" ] && rm "${t}"
				[ -f "${CPIO_NAME}" ] && rm "${CPIO_NAME}"
			else
				result=${ERROR_INVALID_DATA}
			fi
		fi
		result=$(assert_equal "${ERROR_SUCCESS}" "${result}")
		echo "${result}"
	fi
}

test_non_existent_file() {
        t="non_existent_file"
	echo "${t}"
	result=$(assert_equal "${ERROR_FILE_NOT_FOUND}" \
		$(run_installer "/IN=${t}"))
	echo "${result}"
}

test_empty_file() {
        TESTID="empty_file"
	touch ${TESTID}
	test_it "${TESTID}"
}

test_preseed_cfg() {
	TESTID=preseed_cfg
	cat << EOF > ${TESTID}
d-i debian-installer/locale string en_CA
d-i netcfg/get_domain string string example.com
d-i netcfg/get_domain seen false
d-i time/zone string America/New_York
d-i time/zone seen false
d-i console-keymaps-at/keymap select us
d-i console-keymaps-at/keymap seen false
d-i netcfg/get_hostname string debian
d-i netcfg/get_hostname seen false
d-i passwd/user-fullname string user
d-i passwd/user-fullname seen false
d-i mirror/http/proxy seen true
EOF
	test_it "${TESTID}"
}

main() {
	test_non_existent_file
	test_empty_file
	test_preseed_cfg
}

[ $# -gt 1 ] && shift
wine_set_up "${@}"
before
main
after
wine_clean_up "${@}"
