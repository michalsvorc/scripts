#!/usr/bin/env sh
#
# Author: Michal Svorc <dev@michalsvorc.com>
# Refer to the usage() function below for usage.
# This program is under MIT license (https://opensource.org/licenses/MIT).

#===============================================================================
# Abort the script on errors and undbound variables
#===============================================================================

set -o errexit      # abort on nonzero exit status
set -o nounset      # abort on unbound variable
set -o pipefail     # don't hide errors within pipes
# set -o xtrace       # debugging

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

  Usage:  ${argv0} [options] <string length>

  Generate random string with safe characters and print it to stdout.

  Options:
    -h, --help      Show this screen and exit.
    -v, --version   Show program version and exit.

EOF
exit ${1:-0}
}

#===============================================================================
# Functions
#===============================================================================

die() {
  local message="${1}"

  printf 'Error: %s\n' "${message}" >&2

  usage 1 1>&2
}

version() {
  printf '%s\n' "${version}"
}

generate_string() {
  local string_length=$1

  </dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' \
    | head -c $string_length \
    | printf '%s\n' $(</dev/stdin)
  }

#===============================================================================
# Execution
#===============================================================================

if test $# -eq 0; then
  die 'No arguments provided.'
fi

case "${1:-}" in
  -h | --help | --h* )
    usage 0
    ;;
  -v | --version )
    printf '%s version: %s\n' "${argv0}" $(version)
    exit 0
    ;;

  * )
    string_length=$1

    case $string_length in
      ''|*[!0-9]*)
        die "$string_length is invalid argument for string length."
        ;;
      *)
        ;;
    esac

    generate_string $string_length
    ;;
esac
