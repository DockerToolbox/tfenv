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

    if [[ "${CONTAINER_OS_NAME}" == "debian" ]]; then
        case "${CONTAINER_OS_VERSION_RAW}" in
            9)
                CONTAINER_OS_VERSION_ALT="stretch"
                ;;
            9-slim)
                CONTAINER_OS_VERSION_ALT="stretch-slim"
                ;;
            10)
                CONTAINER_OS_VERSION_ALT="buster"
                ;;
            10-slim)
                CONTAINER_OS_VERSION_ALT="buster-slim"
                ;;
            11)
                CONTAINER_OS_VERSION_ALT="bullseye"
                ;;
            11-slim)
                CONTAINER_OS_VERSION_ALT="bullseye-slim"
                ;;
            12)
                CONTAINER_OS_VERSION_ALT="bookworm"
                ;;
            12-slim)
                CONTAINER_OS_VERSION_ALT="bookworm-slim"
                ;;
            *)
                echo "${fgRed}${bold}Unknown debian version ${CONTAINER_OS_VERSION_RAW} - update utils.sh - aborting${reset}"
                exit
        esac
    else
        CONTAINER_OS_VERSION_ALT=$CONTAINER_OS_VERSION_RAW
    fi

    export PUBLISHED_CONTAINER_NAME
    export LOCAL_CONTAINER_NAME
    export CONTAINER_OS_VERSION_RAW
    export CONTAINER_OS_VERSION
    export CONTAINER_OS_VERSION_ALT
}

function manage_container()
{
    type="${1:-}"
    clean="${2:-}"
    tags="${3:-}"

    case "${type}" in
        generate)
            generate_container
            ;;
        build)
            build_container "${clean}"
            ;;
        scan)
            scan_container
            ;;
        publish)
            publish_container "${tags}"
            ;;
        *)
            echo "${fgRed}${bold}Unknown option ${type} aborting${reset}"
            ;;
    esac
}

function set_colours()
{
    export TERM=xterm
    fgRed=$(tput setaf 1)
    fgGreen=$(tput setaf 2)
    fgYellow=$(tput setaf 3)
    fgCyan=$(tput setaf 6)

    bold=$(tput bold)
    reset=$(tput sgr0)
}

function check_template()
{
    if [[ ! -f "${1}" ]]; then
        echo "${fgRed}${bold}${1} is missing aborting Dockerfile generation for ${CONTAINER_OS_NAME}:${CONTAINER_OS_VERSION_ALT}${reset}"
        exit 1
    fi
}

function generate_container()
{
    echo "${fgGreen}${bold}Generating new Dockerfile for ${CONTAINER_OS_NAME}:${CONTAINER_OS_VERSION_ALT}${reset}"

    check_template "Templates/install.tpl"
    check_template "Templates/cleanup.tpl"
    check_template "Templates/entrypoint.tpl"

    INSTALL=$(<Templates/install.tpl)
    CLEANUP=$(<Templates/cleanup.tpl)
    ENTRYPOINT=$(<Templates/entrypoint.tpl)

    REPO_ROOT=$(r=$(git rev-parse --git-dir) && r=$(cd "$r" && pwd)/ && cd "${r%%/.git/*}" && pwd)

    if [[ "${CONTAINER_OS_NAME}" == "alpine" ]]; then
        CONTAINER_SHELL="ash"
        CONTAINER_LINT="# hadolint ignore=SC2016,DL3018,DL4006"
    else
        CONTAINER_SHELL="bash"
        CONTAINER_LINT="# hadolint ignore=SC2016"
    fi

    PACKAGES=$("${REPO_ROOT}"/Scripts/get-versions.sh -g "${REPO_ROOT}"/Scripts/version-grabber.sh -p -c "${REPO_ROOT}/Packages/packages.cfg" -o "${CONTAINER_OS_NAME}" -t "${CONTAINER_OS_VERSION_ALT}" -s "${CONTAINER_SHELL}")
    if [[ -f "Templates/static-packages.tpl" ]]; then
        STATIC=$(<Templates/static-packages.tpl)
        PACKAGES=$(printf "%s\n%s" "${PACKAGES}" "${STATIC}")
    fi

    if [[ -f "Dockerfile" ]]; then
        cp Dockerfile Dockerfile.bak
    fi

    touch Dockerfile
    cat >Dockerfile <<EOL
FROM ${CONTAINER_OS_NAME}:${CONTAINER_OS_VERSION_ALT}

${CONTAINER_LINT}
${PACKAGES}
${INSTALL}
${CLEANUP}

${ENTRYPOINT}

EOL

    echo "${fgGreen}${bold}Complete${reset}"
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

function scan_container()
{
    echo "${fgGreen}${bold}Scanning: ${LOCAL_CONTAINER_NAME}${reset}"
    docker scan "${LOCAL_CONTAINER_NAME}"
    echo "${fgGreen}${bold}Scan Complete: ${LOCAL_CONTAINER_NAME}${reset}"
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

set_colours
setup
