#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: rsync

#===============================================================================
# Abort the script on errors and unbound variables
#===============================================================================

set -o errexit      # Abort on nonzero exit status.
set -o nounset      # Abort on unbound variable.
set -o pipefail     # Don't hide errors within pipes.
# set -o xtrace       # Set debugging.

#===============================================================================
# Variables
#===============================================================================

version='1.0.0'
argv0=${0##*/}

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] <source dir> [target dir: \$PWD]

Make a backup with rsync directory synchronization.
Use with caution, improper usage may result in data loss.

Options:
    -h, --help      Show this screen and exit.
    -v, --version   Show program version and exit.

Examples:
    ${argv0} /path/to/source/dir
    ${argv0} /path/to/source/dir/ /path/to/target/dir/
EOF
  exit ${1:-0}
}

#===============================================================================
# Functions
#===============================================================================

die() {
  local message="$1"

  printf 'Error: %s\n\n' "$message" >&2

  usage 1 1>&2
}

print_version() {
  printf '%s version: %s\n' "$argv0" "$version"
}

synchronize_dirs() {
  local source_dir="$1"
  local target_dir="$2"

  [ ! -d "$source_dir"  ] \
    && die 'Source directory "%s" does not exist' "$source_dir"

  [ ! -d "$target_dir"  ] \
    && die 'Target directory "%s" does not exist' "$target_dir"

  printf 'Synchronizing directories:\n"%s" -> "%s"\n\n' \
    "$source_dir" \
    "$target_dir"

  printf 'Warning: The --delete option is enabled.\n\n'

  read -p 'Press ENTER key to continue ...'

  rsync \
    -aAXH \
    --delete \
    --links \
    --exclude={'lost+found'} \
    --info=progress2 \
    "$source_dir" \
    "$target_dir"
}

#===============================================================================
# Execution
#===============================================================================

test $# -eq 0 && die 'No arguments provided.'
test $# -gt 2 && die 'Maximum number of arguments exceeded.'

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -v | --version )
    print_version
    exit 0
    ;;
esac

source_dir="${1:-}"
target_dir="${2:-$PWD}"

synchronize_dirs "$source_dir" "$target_dir"

