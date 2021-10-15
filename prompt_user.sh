#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Source: https://stackoverflow.com/a/27875395/3553541

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
Usage:  ${argv0} [options]

Prompt user for [y/N] key press. Print True/False based on user input.

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

version() {
  printf '%s version: %s\n' "$argv0" "$version"
}

prompt_user() {
  local default_question='Are you sure?'
  local default_answer='N'

  local question="${1:-$default_question}"

  printf '%s\n' "$question [y/N] "

  old_stty_cfg=$(stty -g)
  stty raw -echo
  answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
  stty $old_stty_cfg

  if (printf '%s' "${answer:-$default_answer}" | grep -iq "^y") ;then
    return 0
  else
    return 1
  fi
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
  * )
    test $# -eq 0 || die "$(printf 'Unrecognized argument "%s".' "${1#-}")"
    ;;
esac

prompt_user 'Do you want to continue?' \
  && printf 'True\n' \
  || printf 'False\n'

