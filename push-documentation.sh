#!/bin/sh

committer_name=${COMMITTER_NAME:-"Ionos Cloud SDK Robot"}
committer_email=${COMMITTER_EMAIL:-"sdk@cloud.ionos.com"}

function usage() {
	echo "usage: ${program} <version>"
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

cd /home/runner/work/sdk-resources/sdk-resources/twt-reference-documentation

git commit --allow-empty -m "auto-generated version ${version}" >/dev/null || exit 1
git push >/dev/null || exit 1
