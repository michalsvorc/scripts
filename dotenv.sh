#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: cut, grep

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

env_path_default="${PWD}/.env"

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] <key>

Read a single value from an .env file.

Options:
    -h, --help      Show help screen and exit.
    -v, --version   Show program version and exit.
    -e, --env-path  Provide path to .env file.
                    Defaults to "\$PWD/.env".
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

get_env_value() {
  local env_path="$1"
  local key="${2:-}"

  [ ! -f "$env_path" ] \
    && die "$(printf 'File not found: "%s".' "$env_path" )"

  [ -z "$key" ] && die 'Empty "key" argument.'

  local value=$(grep -e "^${key}=.*" "$env_path")

  [ -z "$value" ] \
    && die "$(
      printf 'Value with key "%s" not found in "%s".' "$key" "$env_path"
    )"

  printf '%s' "$value" | cut -d '=' -f2
}

#===============================================================================
# Execution
#===============================================================================

test $# -eq 0 && die 'No arguments provided.'

env_path="$env_path_default"

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -v | --version )
    version
    exit 0
    ;;
  -e | --env-path )
    shift
    env_path="$1"
    [ -z "$env_path" ] && die 'Missing argument for option "--env-path".'

    shift
    ;;
esac

test $# -eq 0 && die 'Missing "key" argument.'

key="$1"

get_env_value "$env_path" "$key"
