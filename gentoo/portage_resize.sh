#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: df, grep, mount

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

target_dir='/var/tmp/portage'

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] <mount size>

Resize portage temporary directory "${target_dir}".

Directory should be registered in "/etc/fstab".

Options:
    -h, --help      Show help screen and exit.
    -v, --version   Show program version and exit.

Size: Valid size value for mount command.

Examples:
    ${argv0} 8G

See: https://wiki.gentoo.org/wiki/Portage_TMPDIR_on_tmpfs
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

version() {
  printf '%s version: %s\n' "$argv0" "$version"
}

#===============================================================================
# Execution
#===============================================================================

test $# -eq 0 && die 'No arguments provided.'

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -v | --version )
    version
    exit 0
    ;;
esac

size="${1:-}"

mount -o remount,size="$size" "$target_dir" \
  && (df | grep "$target_dir")
