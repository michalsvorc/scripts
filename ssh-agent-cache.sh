#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Version: 1.0.0
# Source: https://wiki.archlinux.org/title/SSH_keys#SSH_agents
#
# Description: This will run a ssh-agent process if there is not one already,
# and save the output thereof. If there is one running already, we retrieve the
# cached ssh-agent output and evaluate it which will set the necessary
# environment variables. The lifetime of the unlocked keys is set to TTL
# variable.

#===============================================================================
# Abort the script on errors and unbound variables
#===============================================================================

set -o errexit      # Abort on nonzero exit status.
# set -o nounset      # Abort on unbound variable.
set -o pipefail     # Don't hide errors within pipes.
# set -o xtrace       # Set debugging.

#===============================================================================
# Variables
#===============================================================================

version='1.0.0'
argv0=${0##*/}

ttl_default='1h'
agent_env_file='ssh-agent.env'
runtime_dir="$XDG_RUNTIME_DIR"
runtime_dir_fallback="/tmp/$UID"

#===============================================================================
# Functions
#===============================================================================

usage() {
  cat <<EOF
Start the agent and make sure that only one ssh-agent process runs at a time.

Usage:
  ${argv0} [ttl]
  ${argv0} -h | --help
  ${argv0} --version

Options:
  -h, --help  Show this screen.
  --version   Show version.
  ttl         The lifetime of the unlocked keys. [default: ${ttl_default}]
EOF
  exit ${1:-0}
}

die() {
  local message="$1"

  printf 'Error: %s\n\n' "$message" >&2

  usage 1 1>&2
}

version() {
  printf '%s version: %s\n' "$argv0" "$version"
}

#===============================================================================
# Execution
#===============================================================================

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -v | --version )
    version 0
    ;;
esac

ttl="${1:-$ttl_default}"

printf 'The lifetime of the unlocked keys is set to %s.\n' "$ttl"

[[ -z "$runtime_dir" ]] \
  && mkdir -p "$runtime_dir_fallback" \
  && runtime_dir="$runruntime_dir_fallback"

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t "$ttl" > "${runtime_dir}/${agent_env_file}"
fi

if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "${runtime_dir}/${agent_env_file}" >/dev/null
fi

