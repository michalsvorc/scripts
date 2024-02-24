#!/usr/bin/env bash
#
# Shell script snippet for trapping signals.
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/shell

#===============================================================================
# Sets up signal traps to handle common termination signals,
# errors, and script exit. It helps ensure proper cleanup and termination
# of the script, allowing resources to be released gracefully.
#
# Trapped Signals:
#   - SIGINT: Interrupt signal (Ctrl+C)
#   - SIGTERM: Termination signal
#   - ERR: Triggered on error
#   - EXIT: Triggered on script exit
# Arguments:
#   None
#===============================================================================
setup_signal_traps() {
  # Trap SIGINT (Ctrl+C) and SIGTERM signals
  trap 'cleanup; exit 130' INT TERM

  # Trap ERR signal
  trap 'cleanup; exit 1' ERR

  # Trap EXIT signal
  trap 'exit' EXIT
}

#===============================================================================
# Cleans up after itself, e.g. by removing temporary files and variables.
#
# Arguments:
#   None
# Outputs:
#   Info about cleanup
#===============================================================================
cleanup() {
  printf '%s\n' 'Cleanup actions...'
}
