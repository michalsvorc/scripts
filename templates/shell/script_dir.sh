#!/usr/bin/env bash
#
# Get the directory containing the script file.
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/shell

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
readonly SCRIPT_DIR

printf 'Script directory: %s\n' "${SCRIPT_DIR}"
