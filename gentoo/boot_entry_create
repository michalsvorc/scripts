#!/usr/bin/env bash
#
# Create a new UEFI boot entry for Gentoo Linux.
# Dependencies: efibootmgr
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/shell

#===============================================================================
# Abort the script on errors and unbound variables
#===============================================================================

set -o errexit  # Exit if any command exits with a nonzero (error) status.
set -o nounset  # Disallow expansion of unset variables.
set -o pipefail # Use last non-zero exit code in a pipeline.
set -o errtrace # Ensure the error trap handler is properly inherited.
# set -o xtrace   # Enable shell script debugging mode.

#===============================================================================
# Variables
#===============================================================================

readonly KERNEL_VERSION="${1:-}"
readonly LABEL="Gentoo ${KERNEL_VERSION}"
readonly EFI_PATH='\EFI\Gentoo'
readonly DEVICE='/dev/nvme0n1'

#===============================================================================
# Execution
#===============================================================================

if [[ -z "${KERNEL_VERSION}" ]]; then
  printf 'Error: No kernel version provided. Exiting.\n'
  exit 1
fi

printf 'Creating a new UEFI boot entry for %s...\n' "${LABEL}"

sudo efibootmgr \
  --create \
  --disk "${DEVICE}" \
  --part 1 \
  --label "Gentoo ${KERNEL_VERSION}" \
  --loader "${EFI_PATH}/vmlinuz-${KERNEL_VERSION}.efi"
