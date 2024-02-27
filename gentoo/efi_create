#!/usr/bin/env bash
#
# Copy the kernel image to the EFI system partition.
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
readonly BOOT_PATH='/boot'
readonly EFI_PATH="${BOOT_PATH}/EFI/Gentoo"

#===============================================================================
# Execution
#===============================================================================

if [[ "$#" -eq 0 ]]; then
  printf 'Error: No kernel version provided. Exiting.\n'
  exit 1
fi

if [[ ! -d "${BOOT_PATH}" ]]; then
  printf 'Error: /boot is not mounted. Exiting.\n'
  exit 1
fi

printf 'Copying vmlinuz-%s to %s...\n' "${KERNEL_VERSION}" "${EFI_PATH}"

sudo cp "${BOOT_PATH}/vmlinuz-${KERNEL_VERSION}" "${EFI_PATH}/vmlinuz-${KERNEL_VERSION}.efi"
