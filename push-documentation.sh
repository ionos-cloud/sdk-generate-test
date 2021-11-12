#!/bin/sh

program="${0}"
sdk_name="${1}"
version="${2}"

committer_name=${COMMITTER_NAME:-"Ionos Cloud SDK Robot"}
committer_email=${COMMITTER_EMAIL:-"sdk@cloud.ionos.com"}

function usage() {
	echo "usage: ${program} <sdk_name> <version>"
}

function error() {
	echo "! ERROR: ${1}"
}

function warning() {
	echo "! WARNING: ${1}"
}

function info() {
	echo "~ ${1}"
}

function debug() {
	echo ">> $1"
}


info "using git committer name: ${committer_name}"
info "using git committer email: ${committer_email}"

# setting up committer info
git config --local user.name "${committer_name}" >/dev/null || exit 1
git config --local user.email ${committer_email} >/dev/null || exit 1

git add . >/dev/null || exit 1

git commit --allow-empty -m "Auto-generated documentation for ${sdk_name} ${version}" >/dev/null || exit 1
git push >/dev/null || exit 1
