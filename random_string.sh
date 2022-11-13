#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: pwgen

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
Usage:  ${argv0} [options] <string length integer>

Generate a random string with pwgen.

Options:
    -h, --help      Show help screen and exit.
    -v, --version   Show program version and exit.
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

is_integer() { local ck=${1#[+-]};ck=${ck/.};[ "$ck" ]&&[ -z "${ck//[0-9]}" ];}

generate_random() {
  local string_length="$1"

  pwgen \
    --secure \
    --capitalize \
    --numerals \
    --symbols \
    -1 \
    "$string_length"
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
    print_version
    exit 0
    ;;
esac

string_length="$1"

[ -z "$string_length" ] && die 'Provided string length argument is empty.'

is_integer "$string_length" \
  || die "$(printf 'Invalid string length argument "%s"' "${string_length}")"

generate_random "$string_length"
