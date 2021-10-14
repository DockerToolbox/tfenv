#!/usr/bin/env bash

while IFS=  read -r -d '' script; do
    $script "${1}" "${2}"
done < <(find . -name manage.sh -print0 | sort -zVd)

