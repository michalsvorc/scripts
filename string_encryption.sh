#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: openssl

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

version='1.0.1'
argv0=${0##*/}

cipher='aes-256-cbc'

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] <command> <input_string>

Encrypt and decrypt a string.
The encryption uses ${cipher} cipher, password protection, and no salt.
The resulting string is encoded in base64.

Options:
    -h, --help      Show help screen and exit.
    -v, --version   Show program version and exit.

Commands:
    encrypt         Encrypt the input string.
    decrypt         Decrypt the input string.
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

password_input_prompt() {
  stty_orig=$(stty -g)
  stty -echo
  read password
  stty $stty_orig

  printf '%s\n' "$password"
}

string_encryption() {
  local operation="$1"
  local input_string="$2"
  local password="$3"

  case "$operation" in
    encrypt)
      command='-e'
      ;;
    decrypt)
      command='-d'
      ;;
  esac

  printf '%s\n' "$input_string" | \
    openssl \
    enc \
    "${command:-}" \
    -base64 \
    "-${cipher}" \
    -nosalt \
    -pbkdf2 \
    -k "$password"
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
  encrypt | decrypt )
    operation="$1"
    shift

    test $# -eq 0 && die 'Missing the input string.'
    input_string="$1"

    printf 'Enter password: '
    password=$(password_input_prompt)
    printf '\n'

    [ -z "$password" ] && die 'Provided password is empty.'

    if [ "$operation" == 'encrypt' ]; then
      printf 'Re-enter password: '
      password_verification=$(password_input_prompt)
      printf '\n'

      [ "$password" == "$password_verification" ] \
        || die 'Provided passwords do not match.'
    fi

    string_encryption "$operation" "$input_string" "$password"
    ;;
  * )
    die "$(printf 'Unrecognized argument "%s".' "${1#-}")"
    ;;
esac

