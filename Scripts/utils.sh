#!/usr/bin/env bash

set -e

DOCKER_HUB_ORG='wolfsoftwareltd'
CONTAINER_PREFIX='tfenv'

function setup()
{
    IFS="/" read -ra PARTS <<< "$(pwd)"

    CONTAINER_OS_VERSION=${PARTS[-1]}
    CONTAINER_OS_NAME=${PARTS[-2]}

    CONTAINER_OS_VERSION_RAW="${CONTAINER_OS_VERSION}"
    CONTAINER_OS_VERSION="${CONTAINER_OS_VERSION//.}"

    CONTAINER_TMP="${CONTAINER_PREFIX}-${CONTAINER_OS_NAME}-${CONTAINER_OS_VERSION}"
    LOCAL_CONTAINER_NAME="${CONTAINER_TMP//.}"
    PUBLISHED_CONTAINER_NAME="${DOCKER_HUB_ORG}/${CONTAINER_PREFIX}-${CONTAINER_OS_NAME}"

    export PUBLISHED_CONTAINER_NAME
    export LOCAL_CONTAINER_NAME
    export CONTAINER_OS_VERSION_RAW
    export CONTAINER_OS_VERSION
}

function manage_container()
{
    type="${1:-}"
    clean="${2:-}"
    tags="${3:-}"

    if [[ "${type}" != "publish" ]]; then
        build_container "${clean}"
    else
        publish_container "${tags}"
    fi
}

function set_colours()
{
    fgRed=$(tput setaf 1)
    fgGreen=$(tput setaf 2)
    fgYellow=$(tput setaf 3)
    fgCyan=$(tput setaf 6)

    bold=$(tput bold)
    reset=$(tput sgr0)
}

function build_container()
{
    clean="${1:-}"

    if [[ "${clean}" == "clean" ]]; then
        echo "${fgGreen}${bold}Clean Building: ${LOCAL_CONTAINER_NAME}${reset}"
        docker build --no-cache --pull -t "${LOCAL_CONTAINER_NAME}" .
        echo "${fgGreen}${bold}Clean Build Complete: ${LOCAL_CONTAINER_NAME}${reset}"
    else
        echo "${fgGreen}${bold}Building: ${LOCAL_CONTAINER_NAME}${reset}"
        docker build --pull -t "${LOCAL_CONTAINER_NAME}" .
        echo "${fgGreen}${bold}Build Complete: ${LOCAL_CONTAINER_NAME}${reset}"
    fi
}

function get_image_id()
{
    IMAGE_ID=$(docker images -q "${LOCAL_CONTAINER_NAME}")

    if [[ -z "${IMAGE_ID}" ]]; then
        echo "${fgRed}${bold}Unable to locate image ID - aborting${reset}"
        exit 1;
    fi

    echo "${fgCyan}Using image ID: ${IMAGE_ID} for ${LOCAL_CONTAINER_NAME}${reset}"
}

function publish_single_version()
{
    tag=$1

    tag="${tag##*( )}" # Remove leading spaces
    tag="${tag%%*( )}" # Remove trailing spaces

    echo "${fgYellow}${bold}Publishing: ${LOCAL_CONTAINER_NAME} to ${PUBLISHED_CONTAINER_NAME}:${tag}${reset}"
    docker tag "${IMAGE_ID}" "${PUBLISHED_CONTAINER_NAME}":"${tag}"
    docker push "${PUBLISHED_CONTAINER_NAME}":"${tag}"
}

function publish_container()
{
    IFS="," read -ra TAGS <<< "${1}"

    get_image_id

    echo "${fgGreen}${bold}Publishing: ${LOCAL_CONTAINER_NAME}${reset}"

    for tag in "${TAGS[@]}"
    do
        publish_single_version "${tag}"
    done

    echo "${fgGreen}${bold}Publish Complete: ${LOCAL_CONTAINER_NAME}${reset}"
}

setup
set_colours
