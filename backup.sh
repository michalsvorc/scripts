#!/usr/bin/env sh
#
# Author: Michal Svorc <dev@michalsvorc.com>
# Dependencies: rsync
# Refer to the usage() function below for usage.
# This program is under MIT license (https://opensource.org/licenses/MIT).

#===============================================================================
# Abort the script on errors and undbound variables
#===============================================================================

set -o errexit      # abort on nonzero exit status
set -o nounset      # abort on unbound variable
set -o pipefail     # don't hide errors within pipes
# set -o xtrace       # debugging

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

  Usage:  ${argv0} [options] <source dir> [target dir: \$PWD]

  Synchronize directories in archive mode with rsync.

  Options:
    -h, --help      Show this screen and exit.
    -v, --version   Show program version and exit.

EOF
exit ${1:-0}
}

#===============================================================================
# Functions
#===============================================================================

die() {
  local message="${1}"

  printf 'Error: %s\n' "${message}" >&2

  usage 1 1>&2
}

version() {
  printf '%s\n' "${version}"
}

backup() {
  local source_dir="${1}"
  local target_dir="${2}"

  if [ -z $source_dir  ] || [ -z $target_dir  ]; then
    _die 'Missing argument for source or target directory.'
  fi

  printf 'Synchronizing directories: "%s" > "%s"\n' \
    $source_dir \
    $target_dir

  printf 'Warning: The --delete option is enabled.\n\n'

  read -p 'Press ENTER key to continue ...'

  rsync \
    -aAXH \
    --delete \
    --links \
    --exclude={"lost+found"} \
    --info=progress2 \
    $source_dir \
    $target_dir
  }

#===============================================================================
# Execution
#===============================================================================

if test $# -eq 0; then
  die 'No arguments provided.'
fi

case "${1:-}" in
  -h | --help | --h* )
    usage 0
    ;;
  -v | --version )
    printf '%s version: %s\n' "${argv0}" $(version)
    exit 0
    ;;
esac

source_dir="${1}"
target_dir="${2:-$PWD}"

backup $source_dir $target_dir
