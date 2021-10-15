#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: emerge

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

emerge_flags='-uvDN --with-bdeps=y'

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] [additional flags]

Update Gentoo Linux @world packages with predefined emerge flags.

Deafult emerge flags: -${emerge_flags}

You can supply additional flags.

Options:
    -h, --help      Show help screen and exit.
    -v, --version   Show program version and exit.

Examples:
    ${argv0}        Update packages with default flags.
    ${argv0} -p     Pretend update to see what will be updated.
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

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -v | --version )
    version
    exit 0
    ;;
esac

additional_emerge_flags="${1:-}"

emerge \
  "${emerge_flags}" \
  "$additional_emerge_flags" \
  @world
