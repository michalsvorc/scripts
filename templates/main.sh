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

  Usage:  ${argv0} [options] command

  Basic Unix shell script template.

  Options:
    -h, --help      Show this screen and exit.
    -v, --version   Show program version and exit.

  Commands:
    hello           Print Hello World message.

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

hello() {
  printf 'Hello World\n'
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

  hello )
    hello
    exit 0
    ;;

  * )
    die "Unrecognized argument ${1#-}."
    ;;
esac
