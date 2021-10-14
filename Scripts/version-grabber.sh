# shellcheck disable=SC2148

# -------------------------------------------------------------------------------- #
# Description                                                                      #
# -------------------------------------------------------------------------------- #
# This script will attempt to get the version information for specific packages.   #
# The aim is to make it work in multiples, currently tested in Bash and Ash.       #
#                                                                                  #
# It will display ready to use config that can be added directly into a Dockerfile #
# and meets the current hadolint specifications.                                   #
# -------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------- #
# Get apk versions                                                                 #
# -------------------------------------------------------------------------------- #
# Get version information for apk based operating systems.                         #
# -------------------------------------------------------------------------------- #

function get_apk_versions()
{
    local packages="${APK_PACKAGES}"
    local output

    if [[ -n "${packages}" ]]; then
        apk update > /dev/null 2>&1

        output="RUN apk update && \\\\\n"
        output="${output}\\tapk add --no-cache \\\\\n"

        for package in $packages; do
            version=$(apk policy "${package}" 2>/dev/null | sed -n 2p | sed 's/:$//g' | sed 's/^[[:space:]]*//')
            if [[ -n "${version}" ]]; then
                output="${output}\\t\t$package=$version \\\\\n"
            fi
        done
        output="${output}\t\t&& \\\\\n"
        echo -e "${output}"
    else
        echo " No packages have been defined."
    fi
}

# -------------------------------------------------------------------------------- #
# Get apt versions                                                                 #
# -------------------------------------------------------------------------------- #
# Get version information for apt based operating systems.                         #
# -------------------------------------------------------------------------------- #

function get_apt_versions()
{
    local packages="${APT_PACKAGES}"
    local output

    if [[ -n "${packages}" ]]; then
        apt-get update > /dev/null 2>&1

        output="RUN apt-get update && \\\\\n"
        output="${output}\tapt-get -y --no-install-recommends install \\\\\n"

        for package in $packages; do
            version=$(apt-cache policy "${package}" 2>/dev/null | grep 'Candidate:' | awk -F ' ' '{print $2}')
            if [[ -n "${version}" ]]; then
                output="${output}\t\t$package=$version \\\\\n"
            fi
        done
        output="${output}\t\t&& \\\\\n"
        echo -e "${output}"
    else
        echo " No packages have been defined."
    fi
}

# -------------------------------------------------------------------------------- #
# Get yum versions                                                                 #
# -------------------------------------------------------------------------------- #
# Get version information for yum based operating systems.                         #
# -------------------------------------------------------------------------------- #

function get_yum_versions()
{
    local packages="${YUM_PACKAGES}"
    local output

    if [[ -n "${packages}" ]]; then
        yum makecache > /dev/null 2>&1

        output="RUN yum makecache && \\\\\n"
        output="${output}\tyum install -y \\\\\n"

        for package in $packages; do
            version=$(yum info "${package}" 2>/dev/null | grep '^Version' | head -n 1 | awk -F ' : ' '{print $2}')
            if [[ -n "${version}" ]]; then
                output="${output}\t\t$package-$version \\\\\n"
            fi
        done
        output="${output}\t\t&& \\\\\n"
        echo -e "${output}"
    else
        echo " No packages have been defined."
    fi
}

# -------------------------------------------------------------------------------- #
# Identify provider                                                                #
# -------------------------------------------------------------------------------- #
# Identify which package provider the OS is using.                                 #
# -------------------------------------------------------------------------------- #

function identify_provider
{
    if command -v apk > /dev/null; then
        get_apk_versions
    elif command -v apt > /dev/null; then
        get_apt_versions
    elif command -v yum  > /dev/null; then
        get_yum_versions
    else
        echo "Unsupport OS type"
    fi
}

# -------------------------------------------------------------------------------- #
# Main()                                                                           #
# -------------------------------------------------------------------------------- #
# This is the actual 'script' and the functions/sub routines are called in order.  #
# -------------------------------------------------------------------------------- #

identify_provider

# -------------------------------------------------------------------------------- #
# End of Script                                                                    #
# -------------------------------------------------------------------------------- #
# This is the end - nothing more to see here.                                      #
# -------------------------------------------------------------------------------- #
