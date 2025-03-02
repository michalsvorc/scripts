#!/usr/bin/env bash
#
# Version: 1.0.0
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: ykman, fzf, xclip

#===============================================================================
# Abort the script on errors and unbound variables
#===============================================================================

set -o errexit  # Abort on nonzero exit status.
set -o nounset  # Abort on unbound variable.
set -o pipefail # Don't hide errors within pipes.
# set -o xtrace       # Set debugging.

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage: yubikey [options] [command]

Shortcuts to Yubikey CLI manager.

Options:
  -h, --help      Show help screen and exit.

Commands:
  code [account]  Send OTP code for oath account to clipboard
                  Opens fuzzy search when account is not provided.
  start           Start PC/SC Daemon.

Examples:
  yubikey start
  yubikey code
  yubikey code myname

EOF
  exit ${1:-0}
}

#===============================================================================
# Functions
#===============================================================================

die() {
  local message="$1"

  printf 'Error: %s\n' "$message" >&2
}

restart_pcsc() {
  printf 'Starting PC/SC Daemon\n'

  sudo rc-service pcscd restart &&
    ykman info
}

select_oath_account() {
  local account
  account=$(ykman oath accounts list | fzf)

  printf '%s' "$account"
}

get_oath_code() {
  local account="$1"

  local code
  code=$(
    ykman oath accounts code "$account" |
      tail -c 7 |
      tr -d '\n'
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

test $# -eq 0 && die 'No arguments provided.' && usage 1 1>&2

case "${1:-}" in
-h | --help)
  usage 0
  ;;
start)
  shift
  restart_pcsc
  ;;
code)
  shift
  account="${1:-}"
  test -z "$account" && account=$(select_oath_account)
  code=$(get_oath_code "$account")
  [[ -z ${code} ]] && die "No code for ${account} found." && exit 1
  send_to_clipboard "$code" &&
    printf 'Code for %s copied to clipboard.\n' "$account"
  ;;
*)
  die "$(printf 'Unrecognized argument "%s".' "${1#-}")"
  usage 1 1>&2
  ;;
esac
