#!/usr/bin/env sh
#
# Author: Michal Svorc <dev@michalsvorc.com>
# Dependencies: pass, fzf, sed
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

  Usage:  ${argv0} [options] [pass command: -c1]

  Filter pass listings with fzf and execute pass command on selected entry.

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

select_pass_file() {
  local pass_file=$(

  find "$HOME/.password-store" -name '*.gpg' -printf '%P\n' \
    | sed -e 's:.gpg$::gi' \
    | fzf
  )

  printf '%s' "${pass_file}"
}

execute_pass_command() {
  local pass_command=$1
  local pass_file=$(select_pass_file)

  printf '%s\n' "${pass_file}"

  pass ${pass_command:-'-c1'} $pass_file
}

#===============================================================================
# Execution
#===============================================================================

case "${1:-}" in
  -h | --help | --h* )
    usage 0
    ;;
  -v | --version )
    printf '%s version: %s\n' "${argv0}" $(version)
    exit 0
    ;;

  * )
    execute_pass_command "${1:-}"
    ;;
esac


