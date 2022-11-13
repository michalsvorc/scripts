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

emerge_flags='uvDN'

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] [additional emerge flags]

Update Gentoo Linux @world packages with predefined emerge flags.

Deafult emerge flags: ${emerge_flags}

You can supply additional emerge flags.

Options:
    --help      Show help screen and exit.
    --version   Show program version and exit.

Examples:
    ${argv0}        Update packages with default flags.
    ${argv0} -p     Pretended update to see list of changes.
    ${argv0} -av    Ask before update, verbose.
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

#===============================================================================
# Execution
#===============================================================================

case "${1:-}" in
  --help )
    usage 0
    ;;
  --version )
    print_version
    exit 0
    ;;
esac

emerge \
  "-${emerge_flags}" \
  $@ \
   --with-bdeps=y \
  @world
