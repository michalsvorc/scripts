#!/usr/bin/env sh
#
# Author: Michal Svorc <dev@michalsvorc.com>
# Version: 1.0.0
# Description: Read values from an .env file.
# This program is under MIT license (https://opensource.org/licenses/MIT).

#===============================================================================
# Abort the script on errors and undbound variables
#===============================================================================

set -o errexit      # abort on nonzero exit status
set -o nounset      # abort on unbound variable
set -o pipefail     # don't hide errors within pipes
# set -o xtrace       # debugging

#===============================================================================
# Functions
#===============================================================================

die() {
  local message="${1}"

  printf 'Error: %s\n' "${message}" >&2

  exit 1
}

get_env_variable() {
  local variable_key="${1}"
  local env_file_path="${2:-$PWD/.env}"

  [ ! -f "${env_file_path}" ] && die "${env_file_path} file not found."

  local variable_value=$(grep -e "^${variable_key}=.*" "${env_file_path}")

  [ -z "${variable_value}" ] && die "${variable_key} not found in ${env_file_path}."

  printf '%s' "${variable_value}" | cut -d '=' -f2
}

#===============================================================================
# Execution
#===============================================================================

printf '%s\n' $(get_env_variable 'KEY')
