#!/usr/bin/env bash
#
# Version: 1.0.0
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)

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
Usage:
  yubikey [options] [command]

Options:
  -h, --help      Display this help message and exit.

Commands:
  code [account]  Retrieve and copy the OTP code for the specified OATH account to
                  the clipboard. If no account is specified, a fuzzy search will
                  be initiated to select an account.

Description:
  A command-line utility for managing Yubikey operations, including OTP code retrieval
  and PC/SC Daemon management.

Examples:
  yubikey
    Restarts the PC/SC Daemon and displays Yubikey manager information.

  yubikey code
    Prompts for an OATH account selection and copies the corresponding OTP code to
    the clipboard.

  yubikey code [account_name]
    Retrieves and copies the OTP code for the specified OATH account to the clipboard.

Dependencies:
  ykman, fzf, xclip, rc-service
EOF
  exit "${1:-0}"
}

#===============================================================================
# Functions
#===============================================================================

# Terminates the script with an error message
die() {
  local message="$1"
  printf 'Error: %s\n' "$message" >&2
  exit 1
}

# Restarts the PC/SC Daemon and displays Yubikey manager information
restart_pcsc() {
  echo 'Starting PC/SC Daemon'
  sudo rc-service pcscd restart || die 'Failed to restart PC/SC Daemon'
  ykman info || die 'Failed to retrieve Yubikey manager information'
}

# Prompts the user to select an OATH account using fuzzy search
select_oath_account() {
  local account
  account=$(ykman oath accounts list | fzf) || die 'Failed to list OATH accounts'
  echo "$account"
}

# Retrieves the OTP code for a given OATH account
get_oath_code() {
  local account="$1"
  local code
  code=$(ykman oath accounts code "$account" | tail -c 7 | tr -d '\n') || die "Failed to retrieve code for account: $account"
  echo "$code"
}

# Sends the selected OTP code to the clipboard
send_to_clipboard() {
  local code="$1"
  echo "$code" | xclip -selection c -i || die 'Failed to copy code to clipboard'
}

#===============================================================================
# Main Execution
#===============================================================================

# Check if no arguments are provided
if [ $# -eq 0 ]; then
  restart_pcsc
  exit 0
fi

# Parse command-line arguments
case "${1:-}" in
-h | --help)
  usage 0
  ;;
code)
  shift
  account="${1:-}"
  if [ -z "$account" ]; then
    account=$(select_oath_account)
  fi
  code=$(get_oath_code "$account")
  send_to_clipboard "$code"
  printf 'Code for %s copied to clipboard.\n' "$account"
  ;;
*)
  die "Unrecognized argument: ${1#-}"
  ;;
esac
