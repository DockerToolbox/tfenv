#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

# shellcheck disable=SC1091
source ../../../Scripts/utils.sh

manage_container "${1}" "${2}" "${CONTAINER_OS_VERSION_RAW},latest"
