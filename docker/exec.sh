#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)

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

version='1.1.0'
argv0=${0##*/}

shell_default='zsh'

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] [arguments...]

Select and execute a Docker container in interactive login shell session.

Interactive shell defaults to /bin/${shell_default}.

Options:
  -h, --help              Show help screen and exit.
  -v, --version           Show program version and exit.
  -s, --shell <string>    Specify a shell.

Arguments:
  Additional Docker exec arguments.

Examples:
  ${argv0}
  ${argv0} --shell bash
  ${argv0} --user root

Dependencies:
  awk, docker, fzf, sed
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

search_containers() {
  printf '%s\n' "$(docker ps -a | sed 1d | fzf | awk '{print $1}')"
}

test_container_status() {
  local status="$1"
  local container="$2"

  test=$(docker ps -aq -f status="$status" -f id="$container")

  [ "$test"  == "$container" ] \
    && true \
    || false
}

#===============================================================================
# Execution
#===============================================================================

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -v | --version )
    print_version
    exit 0
    ;;
  -s | --shell )
    shift
    shell="${1:-}"
    [ -z "$shell" ] && die 'Missing argument for option "--shell".'
    ;;
esac

container=$(search_containers)

$(test_container_status 'running' "$container") \
  || (printf 'Starting container ' ; docker start "$container")

docker exec \
  -it \
  $@ \
  "$container" \
  "/bin/${shell:-$shell_default}" --login

