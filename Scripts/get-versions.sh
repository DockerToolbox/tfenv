#! /usr/bin/env bash

# -------------------------------------------------------------------------------- #
# Description                                                                      #
# -------------------------------------------------------------------------------- #
# When building docker containers it is considered best (or at least good)         #
# practice to pin the packages you install to specific versions. Identifying all   #
# these versions can be a long, slow and often boring process.                     #
#                                                                                  #
# This is a tool to assist in generating a list of packages and their associated   #
# versions for use within a Dockerfile.                                            #
# -------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------- #
# Required commands                                                                #
# -------------------------------------------------------------------------------- #
# These commands MUST exist in order for the script to correctly run.              #
# -------------------------------------------------------------------------------- #

PREREQ_COMMANDS=( "docker" )

# -------------------------------------------------------------------------------- #
# Flags                                                                            #
# -------------------------------------------------------------------------------- #
# A set of global flags that we use for configuration.                             #
# -------------------------------------------------------------------------------- #

NO_HEADERS=false
USE_COLOURS=true                 # Should we use colours in our output ?
WIDTH=120

# -------------------------------------------------------------------------------- #
# The wrapper function                                                             #
# -------------------------------------------------------------------------------- #
# This is where you code goes and is effectively your main() function.             #
# -------------------------------------------------------------------------------- #

function wrapper()
{
    draw_header

    docker run --rm -v "${GRABBER_SCRIPT}":/version-grabber --env-file="${CONFIG_FILE}" "${OSNAME}":"${TAGNAME}" "${SHELLNAME}" /version-grabber

    draw_line
}

# -------------------------------------------------------------------------------- #
# Usage (-h parameter)                                                             #
# -------------------------------------------------------------------------------- #
# This function is used to show the user 'how' to use the script.                  #
# -------------------------------------------------------------------------------- #

function usage()
{
    if [[ -n ${1:-} ]];
    then
        show_error "  Error: ${1}"
    fi

cat <<EOF
  Usage: $0 [ -h ] [ -p ] [ -c value ] [ -g value ] [ -o value ] [ -s value ] [ -t value ]
    -h    : Print this screen
    -p    : Package list only (No headers or other information)
    -c    : config file name (including path)
    -g    : version grabber script (including path) [Default: ~/bin/version-grabber.sh]
    -o    : which operating system to use (docker container)
    -s    : which shell to use inside the container [Default: bash]
    -t    : which tag to use [Default: latest]
EOF
    clean_exit 1;
}

# -------------------------------------------------------------------------------- #
# Process Arguments                                                                #
# -------------------------------------------------------------------------------- #
# This function will process the input from the command line and work out what it  #
# is that the user wants to see.                                                   #
#                                                                                  #
# This is the main processing function where all the processing logic is handled.  #
# -------------------------------------------------------------------------------- #

function process_arguments()
{
    if [[ $# -eq 0 ]]; then
        usage
    fi

    while getopts ":hpc:g:o:s:t:" arg; do
        case $arg in
            h)
                usage
                ;;
            p)
                NO_HEADERS=true
                ;;
            c)
                CONFIG_FILE=$(realpath "${OPTARG}")
                if [[ ! -r "${CONFIG_FILE}" ]]; then
                    show_error "Cannot read config file: ${CONFIG_FILE}"
                fi
                ;;
            g)
                GRABBER_SCRIPT=$(realpath "${OPTARG}")
                if [[ ! -r "${GRABBER_SCRIPT}" ]]; then
                    show_error "Cannot read grabber script: ${GRABBER_SCRIPT}"
                fi
                ;;
            o)
                OSNAME=${OPTARG}
                ;;
            s)
                SHELLNAME=${OPTARG}
                ;;
            t)
                TAGNAME=${OPTARG}
                ;;
            :)
                usage "Option -$OPTARG requires an argument."
                ;;
            \?)
                usage "Invalid option: -$OPTARG"
                ;;
        esac
    done

    [[ -z "${CONFIG_FILE}" ]] && usage
    [[ -z "${GRABBER_SCRIPT}" ]] && GRABBER_SCRIPT="$(realpath ~/bin/version-grabber.sh)"
    [[ -z "${OSNAME}" ]] &&  usage
    [[ -z "${SHELLNAME}" ]] && SHELLNAME='bash'
    [[ -z "${TAGNAME}" ]] && TAGNAME='latest'

    wrapper
    clean_exit
}

# -------------------------------------------------------------------------------- #
# STOP HERE!                                                                       #
# -------------------------------------------------------------------------------- #
# The functions below are part of the template and should not require any changes  #
# in order to make use of this template. If you are going to edit code beyound     #
# this point please ensure you fully understand the impact of those changes!       #
# -------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------- #
# Utiltity Functions                                                               #
# -------------------------------------------------------------------------------- #
# The following functions are all utility functions used within the script but are #
# not specific to the display of the colours and only serve to handle things like, #
# signal handling, user interface and command line option processing.              #
# -------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------- #
# Check Colours                                                                    #
# -------------------------------------------------------------------------------- #
# This function will check to see if we are able to support colours and how many   #
# we are able to support.                                                          #
#                                                                                  #
# The script will give and error and exit if there is no colour support or there   #
# are less than 8 supported colours.                                               #
#                                                                                  #
# Variables intentionally not defined 'local' as we want them to be global.        #
#                                                                                  #
# NOTE: Do NOT use show_error for the error messages are it requires colour!       #
# -------------------------------------------------------------------------------- #

function check_colours()
{
    local ncolors

    red=''
    yellow=''
    green=''
    reset=''

    if [[ "${USE_COLOURS}" = false ]]; then
        return
    fi

    if ! test -t 1; then
        return
    fi

    if ! tput longname > /dev/null 2>&1; then
        return
    fi

    ncolors=$(tput colors)

    if ! test -n "${ncolors}" || test "${ncolors}" -le 7; then
        return
    fi

    red=$(tput setaf 1)
    yellow=$(tput setaf 3)
    green=$(tput setaf 2)
    reset=$(tput sgr0)
}

# -------------------------------------------------------------------------------- #
# Show Error                                                                       #
# -------------------------------------------------------------------------------- #
# A simple wrapper function to show something was an error.                        #
# -------------------------------------------------------------------------------- #

function show_error()
{
    if [[ -n $1 ]]; then
        printf '%s%s%s\n' "${red}" "${*}" "${reset}" 1>&2
    fi
}

# -------------------------------------------------------------------------------- #
# Show Warning                                                                     #
# -------------------------------------------------------------------------------- #
# A simple wrapper function to show something was a warning.                       #
# -------------------------------------------------------------------------------- #

function show_warning()
{
    if [[ -n $1 ]]; then
        printf '%s%s%s\n' "${yellow}" "${*}" "${reset}" 1>&2
    fi
}

# -------------------------------------------------------------------------------- #
# Show Success                                                                     #
# -------------------------------------------------------------------------------- #
# A simple wrapper function to show something was a success.                       #
# -------------------------------------------------------------------------------- #

function show_success()
{
    if [[ -n $1 ]]; then
        printf '%s%s%s\n' "${green}" "${*}" "${reset}" 1>&2
    fi
}

function draw_header
{
    if [[ "${NO_HEADERS}" = false ]]; then

        local config_string_raw config_string
        config_string_raw="Config File: $(basename "${CONFIG_FILE}")  Grabber Script: $(basename "${GRABBER_SCRIPT}")  Docker Container: ${OSNAME}:${TAGNAME}  Shell: ${SHELLNAME}"
        config_string="${green}Config File:${reset} $(basename "${CONFIG_FILE}")  ${green}Grabber Script:${reset} $(basename "${GRABBER_SCRIPT}")  ${green}Docker Container:${reset} ${OSNAME}:${TAGNAME}  ${green}Shell:${reset} ${SHELLNAME}"

        draw_line
        center_text "Docker package version grabber"
        draw_line
        center_text "${config_string}" "${#config_string_raw}"
        draw_line
    fi
}

# -------------------------------------------------------------------------------- #
# abs                                                                              #
# -------------------------------------------------------------------------------- #
# Return the absolute value for a given number.                                    #
# -------------------------------------------------------------------------------- #

function abs()
{
    (( $1 < 0 )) && echo "$(( $1 * -1 ))" || echo "$1"
}

# -------------------------------------------------------------------------------- #
# Center Text                                                                      #
# -------------------------------------------------------------------------------- #
# A simple wrapper function to some text centered on the screen.                   #
# -------------------------------------------------------------------------------- #

function center_text()
{
    if [[ -n ${2} ]]; then
        textsize=${2}
        extra=$(abs "$(( textsize - ${#1} ))")
    else
        textsize=${#1}
        extra=0
    fi
    span=$(( ( (WIDTH + textsize) / 2) + extra ))

    printf '%*s\n' "${span}" "$1"
}

# -------------------------------------------------------------------------------- #
# Draw Line                                                                        #
# -------------------------------------------------------------------------------- #
# A simple wrapper function to draw a line on the screen.                          #
# -------------------------------------------------------------------------------- #

function draw_line()
{
    if [[ "${NO_HEADERS}" = false ]]; then

        local start=$'\e(0' end=$'\e(B' line='qqqqqqqqqqqqqqqq'

        while ((${#line} < "${WIDTH}"));
        do
            line+="$line";
        done
        printf '%s%s%s\n' "$start" "${line:0:WIDTH}" "$end"
    fi
}


# -------------------------------------------------------------------------------- #
# Check Prerequisites                                                              #
# -------------------------------------------------------------------------------- #
# Check to ensure that the prerequisite commmands exist.                           #
# -------------------------------------------------------------------------------- #

function check_prereqs()
{
    local error_count=0

    for i in "${PREREQ_COMMANDS[@]}"
    do
        command=$(command -v "${i}" || true)
        if [[ -z $command ]]; then
            show_error "$i is not in your command path"
            error_count=$((error_count+1))
        fi
    done

    if [[ $error_count -gt 0 ]]; then
        show_error "$error_count errors located - fix before re-running";
        clean_exit 1;
    fi
}

# -------------------------------------------------------------------------------- #
# Clean Exit                                                                       #
# -------------------------------------------------------------------------------- #
# Unset the traps and exit cleanly, with an optional exit code / message.          #
# -------------------------------------------------------------------------------- #

function clean_exit()
{
    if [[ -n ${2:-} ]];
    then
        show_error "${2}"
    fi
    exit "${1:-0}"
}

# -------------------------------------------------------------------------------- #
# Main()                                                                           #
# -------------------------------------------------------------------------------- #
# The main function where all of the heavy lifting and script config is done.      #
# -------------------------------------------------------------------------------- #

function main()
{
    check_colours
    check_prereqs
    process_arguments "${@}"
}

# -------------------------------------------------------------------------------- #
# Main()                                                                           #
# -------------------------------------------------------------------------------- #
# This is the actual 'script' and the functions/sub routines are called in order.  #
# -------------------------------------------------------------------------------- #

main "${@}"

# -------------------------------------------------------------------------------- #
# End of Script                                                                    #
# -------------------------------------------------------------------------------- #
# This is the end - nothing more to see here.                                      #
# -------------------------------------------------------------------------------- #
