#!/usr/bin/env bash
#
# Resizes the portage directory to the specified size.
# For use with portage mounted on tmpfs.
# Dependencies: df, grep, mount
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/shell
# Documentation: https://wiki.gentoo.org/wiki/Portage_TMPDIR_on_tmpfs

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

readonly MOUNT_SIZE="${1:-}"
readonly MOUNT_PATH='/var/tmp/portage'

#===============================================================================
# Execution
#===============================================================================

if [[ "$#" -eq 0 ]]; then
  printf 'Error: No mount size provided. Exiting.\n'
  exit 1
fi

printf "Resizing %s to %s...\n" "${MOUNT_PATH}" "${MOUNT_SIZE}"

sudo mount -o remount,size="${MOUNT_SIZE}" "${MOUNT_PATH}" &&
  (df | grep "${MOUNT_PATH}")
