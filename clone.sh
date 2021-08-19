#!/usr/bin/env bash

set -ux

git clone https://${GITHUB_PAT}@github.com/ionos-cloud/sdk-test-drivers.git --branch master --single-branch /tmp/test-drivers

# git clone https://${GITHUB_PAT}@github.com/ionos-cloud/${IONOS_SDK_NAME} /tmp/${IONOS_SDK_NAME}
git clone https://${GITHUB_PAT}@github.com/ionos-cloud/${IONOS_SDK_NAME}

pushd "${IONOS_SDK_NAME}"

git fetch --prune --tags

git branch -a | grep ${IONOS_SDK_BRANCH}
if [ "$?" = "0" ]; then
  git checkout ${IONOS_SDK_BRANCH} >/dev/null || exit 1
else
  info "creating a new branch: ${IONOS_SDK_BRANCH}"
  git checkout -b ${IONOS_SDK_BRANCH} >/dev/null || exit 1
  git push -u origin ${IONOS_SDK_BRANCH} >/dev/null || exit 1
fi

cp -rf . /tmp/${IONOS_SDK_NAME}

popd

# vim: ts=2: sw=2: ai: si

