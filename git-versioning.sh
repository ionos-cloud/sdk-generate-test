#!/bin/sh

program="${0}"
version="${1}"

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

function get_major() {
	local ret=$(echo "${1}" | cut -d '.' -f 1)
	local first_char=$(echo "${ret}" | cut -c1-1)
	if [ "${first_char}" = "v" ]; then
		# strip the v from the major component
		ret=$(echo "${ret}" | cut -c2-100)
	fi
	echo "${ret}"
}

function get_minor() {
	echo $(echo "${1}" | cut -d '.' -f 2)
}

if [ "${version}" = "" ]; then
	error "version not specified"
	usage
	exit 1
fi

major=$(get_major "${version}")
if [ "${major}" = "" ]; then
	error "cannot compute major version from ${version}"
	exit 1
fi

minor=$(get_minor "${version}")
if [ "${minor}" = "" ]; then
	error "cannot compute minor version from ${version}"
	exit 1
fi

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


info "using git committer name: ${committer_name}"
info "using git committer email: ${committer_email}"

# setting up committer info
git config --local user.name "${committer_name}" >/dev/null || exit 1
git config --local user.email ${committer_email} >/dev/null || exit 1

git config --local pull.rebase false

# we don't need to spam stdout with useless info :)
git config --local advice.detachedHead false

info "fetching latest tags and branches from upstream ..."
git fetch --prune --tags

# check if we have a new major or minor
info "fetching list of old versions ..."

info "tag list"
git tag --list "v*" --sort=refname

info "last tag is "
git tag --list "v*" --sort=refname | tail -n 1

old_version=$(git tag --list "v*" --sort=refname | tail -n 1)

info "committing latest changes ..."

git add . >/dev/null || exit 1

git commit --allow-empty -m "auto-generated version ${version}" >/dev/null || exit 1

# create version tag
info "creating version tag ..."
git tag ${tag_name} >/dev/null || exit 1

info "pushing tags and changes ..."
git push >/dev/null || exit 1
git push --tags >/dev/null || exit 1

info "checking if we have a new major or minor version ..."
if [ "${old_version}" != "" ]; then
	info "found older version ${old_version}"
	old_major=$(get_major "${old_version}")
	old_minor=$(get_minor "${old_version}")
	info "old major: ${old_major} / old minor: is ${old_minor} / current major: ${major} / current minor: ${minor}"
	if [ "${old_major}" != "" -a "${old_minor}" != "" ]; then
	   	if [ "${old_major}" != "${major}" -o "${old_minor}" != "${minor}" ]; then
			# create release branch for old version from the old version tag
			branch_name="release/${old_major}.${old_minor}.x"
			git branch -a | grep ${branch_name}
			if [ "$?" = "0" ]; then
				warning "a release branch ${branch_name} already exists"
			else
				info "creating a new release branch: ${branch_name}"
				git checkout ${old_version} >/dev/null || exit 1
				git checkout -b "${branch_name}" >/dev/null || exit 1
				git push -u origin ${branch_name} >/dev/null || exit 1
				git checkout master >/dev/null || exit 1
			fi
		else
			info "no new release branch needed"
		fi
	else
		info "could not compute old major or old minor versions"
	fi
else
	info "no older versions found"
fi

