#!/usr/bin/env sh
#
# Author: Michal Svorc <dev@michalsvorc.com>
# This program is under MIT license (https://opensource.org/licenses/MIT).
# Dependencies: openssl

#===============================================================================
# Abort the script on errors and undbound variables
#===============================================================================

set -o errexit      # Abort on nonzero exit status.
set -o nounset      # Abort on unbound variable.
set -o pipefail     # Don't hide errors within pipes.
# set -o xtrace       # Set debugging.

#===============================================================================
# Variables
#===============================================================================

version='1.1.1'
filename=${0##*/}

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  $filename <command> <input_string>

Encrypt or decrypt string with a password, base64 encoding, no salt.

Commands:
  -h, --help      Show this screen and exit.
  -v, --version   Show program version and exit.
  -e              String encryption.
  -d              String decryption.
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
  printf '%s version: %s\n' "$filename" "$version"
}

password_input_prompt() {
  stty_orig=$(stty -g)
  stty -echo
  read password
  stty $stty_orig

  printf '%s\n' "$password"
}

string_encryption() {
  local comand="$1"
  local input_string="$2"
  local password="$3"

  printf '%s\n' "$input_string" | \
    openssl \
    enc \
    "$command" \
    -base64 \
    -aes-256-cbc \
    -nosalt \
    -pbkdf2 \
    -k "$password"
  }

#===============================================================================
# Execution
#===============================================================================

if test $# -eq 0; then
  die 'No arguments provided.'
fi

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -v | --version )
    version
    exit 0
    ;;

  -e | -d )
    command="$1"
    shift

    test $# -eq 0 && die 'Missing the input string.'
    input_string="$1"

    printf 'Enter password: '
    password=$(password_input_prompt)
    printf '\n'

    if [ "$command" == '-e' ]; then
      printf 'Re-enter password: '
      password_verification=$(password_input_prompt)
      printf '\n'

      [ "$password" == "$password_verification" ] \
        || (printf 'Passwords do not match.\n' && exit 1)
    fi

    string_encryption "$command" "$input_string" "$password"
    ;;

  * )
    die "Unrecognized argument ${1#-}."
    ;;
esac
