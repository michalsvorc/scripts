#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Description: Create an EFI boot entry with efibootmgr.
# Dependencies: efibootmgr

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

version="${1}"

#===============================================================================
# Functions
#===============================================================================

die() {
  local message="$1"

  printf 'Error: %s\n\n' "$message" >&2

  usage 1 1>&2
}

version() {
  printf 'Version: %s\n' "$version"
}

#===============================================================================
# Execution
#===============================================================================

[ -z "$version" ] && die 'Provided version is empty.'

version
efibootmgr \
  -c \
  -d /dev/nvme0n1 \
  -p 1 \
  -L "Gentoo ${version}" \
  -l "\EFI\Gentoo\vmlinuz-${version}-gentoo.efi" \
  && efibootmgr -v
