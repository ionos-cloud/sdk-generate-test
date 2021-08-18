#!/usr/bin/env bash

set -uex

git clone git@github.com:ionos-cloud/sdk-test-drivers --branch master --single-branch /tmp/test-drivers
git clone git@github.com:ionos-cloud/${IONOS_SDK_NAME} /tmp/${IONOS_SDK_NAME}

# vim: ts=2: sw=2: ai: si

