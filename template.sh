#!/usr/bin/env bash
#
# Shell script template with simple option parsing using getopts.
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines:   
#   https://google.github.io/styleguide/shell
#   https://clig.dev

# Shell script execution options

set -o errexit    # Exit if any command exits with a nonzero (error) status
set -o nounset    # Disallow expansion of unset variables
set -o pipefail   # Use last non-zero exit code in a pipeline
set -o errtrace   # Ensure the error trap handler is properly inherited

# Enable debugging if the DEBUG environment variable is set to positive value

if [[ "${DEBUG-}" =~ ^1|true|yes$ ]]; then
    set -o xtrace # Trace the execution of the script
    printf '%s\n' 'Debugging mode enabled'
fi

# Global variables

readonly VERSION='1.0.0'
NAME='User'

# Computed global variables

readonly script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
readonly script_name=$(basename "${BASH_SOURCE[0]}")

# Functions

# print_usage() - Print Usage
#
# This function prints the program usage.
#
# Usage:
#   print_usage
#
# Parameters:
#   None
print_usage() {
  cat <<EOF
Usage: ${script_name} [options]

Basic Unix shell script template. Prints a greeting message.

Options:
  -h            Show help screen and exit.
  -v            Show program version and exit.
  -n <name>     Set name for greeting message.
                Default: ${NAME}

Examples:
  ${script_name}
  ${script_name} -n Alice
EOF
}

# print_error() - Print error message.
#
# This function prints an error message to stderr.
# It takes a single argument containing the error message.
#
# Usage:
#   print_error "Error message"
#
# Parameters:
#   message: The error message
print_error() {
  local message="$1"

  printf 'Error: %s\n\n' "${message}" >&2
}

# print_version() - Print program version.
#
# This function prints the program version.
# 
# Usage:
#   print_version
#
# Parameters:
#   None
print_version() {
  printf '%s version: %s\n' "${script_name}" "${VERSION}"
}

# setup_signal_traps() - Set up signal traps for cleanup.
#
# This function sets up signal traps to handle common termination signals,
# errors, and script exit. It helps ensure proper cleanup and termination
# of the script, allowing resources to be released gracefully.
#
# Trapped Signals:
#   - SIGINT: Interrupt signal (Ctrl+C)
#   - SIGTERM: Termination signal
#   - ERR: Triggered on error
#   - EXIT: Triggered on script exit

setup_signal_traps() {
  # Trap SIGINT (Ctrl+C) and SIGTERM signals
  trap 'cleanup; exit 130' INT TERM

  # Trap ERR signal
  trap 'cleanup; exit 1' ERR

  # Trap EXIT signal
  trap 'exit' EXIT
}

# cleanup() - Cleanup actions.
#
# This function cleans up after itself, e.g. by removing temporary files and variables.
#
# Usage:
#   cleanup
#
# Parameters:
#   None
cleanup() {
  printf '%s\n' 'Cleanup actions...'
}

# terminate_execution() - Terminate script execution.
#
# This function terminates script execution.
# It takes a single argument containing the error message.
#
# Usage:
#   terminate_execution "Error message"
#
# Parameters:
#   message: The error message
terminate_execution() {
  local message="$1"
  local exit_code=1

  print_error "${message}"
  print_usage
  cleanup
  exit "${exit_code}"
}

# print_name() - Print a personalized greeting message.
#
# This function takes a single argument 'name' and prints a greeting message
# with the provided name.
#
# Usage:
#   print_name "John"
#
# Parameters:
#   name: The name to be included in the greeting message.
print_name() {
  local name="$1"

  printf 'Hello, %s!\n' "${name}"
}

# parse_parameters() - Parse command-line arguments.
#
# This function parses the command-line arguments passed to the script.
#
# Usage:
#   parse_parameters "$@"
#
# Parameters:
#   $@: The command-line arguments
parse_parameters() {
  while getopts ":vhn:" opt; do
      case $opt in
          v)
            print_version
            ;;
          h)
            print_usage
            ;;
          n)
            NAME="${OPTARG}"
            ;;
          \?)
            terminate_execution "Invalid option: -${OPTARG}"
            ;;
          :)
            terminate_execution "Option -${OPTARG} requires an argument."
            ;;
      esac
  done
}

# main() - Main function.
# 
# This function is the entry point of the script.
# It parses the command-line arguments and calls the appropriate functions.
#
# Usage:
#   main
#
# Parameters:
#   None
main() {
  setup_signal_traps
  parse_parameters "$@"
  print_name "${NAME}"
}

# Execution

main "$@"
