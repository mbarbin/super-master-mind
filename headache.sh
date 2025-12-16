#!/bin/bash -e

DIRS_FILE="$(dirname "$0")/.headache.dirs"

if [ ! -f "$DIRS_FILE" ]; then
    echo "Directory list file '$DIRS_FILE' not found!" >&2
    exit 1
fi

while IFS= read -r dir; do
    # Ignore empty lines and lines starting with '#'
    [ -z "$dir" ] && continue
    case "$dir" in
        \#*) continue ;;
    esac
    echo "Apply headache to directory ${dir}"

    # Apply headache to .ml files
    headache -c .headache.config -h COPYING.HEADER "${dir}"/*.ml

    # Check if .mli files exist in the directory, if so apply headache
    # Exclude Sites.mli (generated file)
    mli_files=$(find "${dir}" -maxdepth 1 -name '*.mli' ! -regex '.*/Sites\.mli' 2>/dev/null)
    if [ -n "$mli_files" ]; then
        headache -c .headache.config -h COPYING.HEADER $mli_files
    fi
done < "$DIRS_FILE"

dune fmt
