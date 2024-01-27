#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)

# Prompts the user for a Yes or No answer.
#
# Arguments:
#   $1: The prompt message to display to the user.
#
# Returns:
#   0 if the user answers 'yes'
#   1 if the user answers 'no'
prompt_yes_no() {
  while true; do
    read -pr "$1 (y/n): " response
    case "$response" in
    [Yy]*) return 0 ;;
    [Nn]*) return 1 ;;
    *) echo "Please answer 'yes' or 'no'." ;;
    esac
  done
}

if prompt_yes_no "Do you want to continue?"; then
  echo "You chose to continue."
else
  echo "You chose to cancel."
fi
