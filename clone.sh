#!/usr/bin/env bash

set -uex

git clone https://${GITHUB_PAT}@github.com/ionos-cloud/sdk-test-drivers.git --branch master --single-branch /tmp/test-drivers

git clone https://${GITHUB_PAT}@github.com/ionos-cloud/${IONOS_SDK_NAME} --branch ${IONOS_SDK_BRANCH} /tmp/${IONOS_SDK_NAME}

# vim: ts=2: sw=2: ai: si

