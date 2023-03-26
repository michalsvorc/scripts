#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: ykman, fzf, xclip

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

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage: yubikey [options] [command]

Shortcuts to Yubikey CLI manager.

Options:
  -h, --help      Show help screen and exit.
  -v, --version   Show program version and exit.

Commands:
  code            List available oath accounts and pipes selected code to xclip.
  start           Start PC/SC Daemon.


Examples:
  yubikey start
  yubikey code

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
  printf '%s version: %s\n' "$version"
}

restart_pcsc() {
  printf 'Starting PC/SC Daemon\n'

  sudo rc-service pcscd restart \
    && ykman info
}

select_oath_account() {
  local account=$(ykman oath accounts list | fzf)

  printf '%s' "$account"
}

get_oath_code() {
  local account="$1"

  local code=$(
    ykman oath accounts code "$account" \
      | tail -c 7 \
      | tr -d '\n'
  )

  printf '%s' "$code"
}

send_to_clipboard() {
  local selection="$1"

  printf '%s' "$selection" | xclip -selection c -i
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
  start )
    shift
    restart_pcsc
    ;;
  code )
    shift
    account=$(select_oath_account)
    code=$(get_oath_code "$account")
    send_to_clipboard "$code"
    ;;
  * )
    die "$(printf 'Unrecognized argument "%s".' "${1#-}")"
    ;;
esac

