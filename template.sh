#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)

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

default_input='World'

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] command

Basic Unix shell script template.

Options:
    -h, --help      Show help screen and exit.
    -v, --version   Show program version and exit.

Commands:
    hello <string>  Print a welcoming message.
                    Defaults to "Hello ${default_input}".
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

hello() {
  local input="$1"

  printf 'Hello %s\n' "$input"
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
  hello )
    shift
    hello "${1:-$default_input}"
    ;;
  * )
    die "$(printf 'Unrecognized argument "%s".' "${1#-}")"
    ;;
esac

