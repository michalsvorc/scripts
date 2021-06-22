#!/usr/bin/env sh
#
# Author: Michal Svorc <dev@michalsvorc.com>
# Version: 1.0.0
# Description: Prompt user for strict [y/N] key press.
# Link: https://stackoverflow.com/a/27875395/3553541
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

_prompt_user() {
  local question="${1:-Are you sure?} [y/N] "
  local answer='N'

  printf '%s\n' "${question}"

  old_stty_cfg=$(stty -g)
  stty raw -echo
  answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
  stty $old_stty_cfg

  if printf '%s' "${answer}" | grep -iq "^y" ;then
    return 0
  else
    return 1
  fi
}

#===============================================================================
# Execution
#===============================================================================

if _prompt_user 'Do you want to continue?'; then
  printf 'True\n'
else
  printf 'False\n'
fi
