#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: awk, docker, fzf, sed

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

shell_default='zsh'

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options]

Select and execute a Docker container in interactive tty login shell session.
If the container is not running, start it.
Interactive shell defaults to ${shell_default}.

Options:
    -h, --help              Show help screen and exit.
    -v, --version           Show program version and exit.
    -s, --shell <string>    Specify a shell.

Examples:
    ${argv0}
    ${argv0} --shell bash
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

execute_container() {
  local container="$1"
  local shell="$2"

  docker exec -it "$container" "/bin/$shell" -l
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
  -s | --shell )
    shift
    shell="${1:-}"
    [ -z "$shell" ] && die 'Missing argument for option "--shell".'
    ;;
esac

container=$(search_containers)

$(test_container_status 'running' "$container") \
  || (printf 'Starting container ' ; docker start "$container")

execute_container "$container" "${shell:-$shell_default}"

