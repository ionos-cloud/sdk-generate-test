#!/usr/bin/env bash
# 
# Checks if a tag already exists for a given version
#
# cwd: the sdk repo directory
#
# env:
#   IONOS_SDK_VERSION - version to check

function error() {
	echo "! ERROR: ${1}"
}

version=${IONOS_SDK_VERSION}

tag_name="v${version}"
version_first_char=$(echo "${version}" | cut -c1-1)
if [ "${version_first_char}" = "v" ]; then
	# strip the v from the major component
	tag_name="${version}"
fi

git ls-remote --tags origin | grep refs/tags/${tag_name}$ 2>&1 >/dev/null 
if [ "$?" = "0" ]; then
	error "tag ${tag_name} already exists"
	exit 1
fi

# vim: ts=2: sw=2: ai: si

