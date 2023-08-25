#!/usr/bin/env bash
#
# Shell script template with simple option parsing using getopts.
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines:   
#   https://google.github.io/styleguide/shell
#   https://clig.dev

#===============================================================================
# Shell script execution options
#===============================================================================

set -o errexit    # Exit if any command exits with a nonzero (error) status
set -o nounset    # Disallow expansion of unset variables
set -o pipefail   # Use last non-zero exit code in a pipeline
set -o errtrace   # Ensure the error trap handler is properly inherited

# Enable debugging if the DEBUG environment variable is set to positive value

if [[ "${DEBUG-}" =~ ^1|true|yes$ ]]; then
    set -o xtrace # Trace the execution of the script
    printf '%s\n' 'Debugging mode enabled'
fi

#===============================================================================
# Variables
#===============================================================================

readonly VERSION='1.0.0'
name='User'

readonly script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
readonly script_name=$(basename "${BASH_SOURCE[0]}")

#===============================================================================
# Functions
#===============================================================================

# Prints the program usage.
#
# Globals:
#   script_name
#   name
#
# Parameters:
#   None
#
# Outputs:
#   Prints the program usage
print_usage() {
  cat <<EOF
Usage: ${script_name} [options]

Basic Unix shell script template. Prints a greeting message.

Options:
  -h            Show help screen and exit.
  -v            Show program version and exit.
  -n <name>     Set name for greeting message.
                Default: ${name}

Examples:
  ${script_name}
  ${script_name} -n Alice
EOF
}

# Prints an error message to stderr.
# It takes a single argument containing the error message.
#
# Parameters:
#   message: The error message
#
# Outputs:
#   Prints the error message to stderr
print_error() {
  local message="$1"

  printf 'Error: %s\n\n' "${message}" >&2
}

# Prints the program version.
#
# Parameters:
#   None
#
# Outputs:
#   Prints the program version
print_version() {
  printf '%s version: %s\n' "${script_name}" "${VERSION}"
}

# Sets up signal traps to handle common termination signals,
# errors, and script exit. It helps ensure proper cleanup and termination
# of the script, allowing resources to be released gracefully.
#
# Trapped Signals:
#   - SIGINT: Interrupt signal (Ctrl+C)
#   - SIGTERM: Termination signal
#   - ERR: Triggered on error
#   - EXIT: Triggered on script exit
#
# Parameters:
#   None
#
# Returns:
#   None
setup_signal_traps() {
  # Trap SIGINT (Ctrl+C) and SIGTERM signals
  trap 'cleanup; exit 130' INT TERM

  # Trap ERR signal
  trap 'cleanup; exit 1' ERR

  # Trap EXIT signal
  trap 'exit' EXIT
}

# Cleans up after itself, e.g. by removing temporary files and variables.
#
# Parameters:
#   None
#
# Outputs:
#   Info about cleanup
cleanup() {
  printf '%s\n' 'Cleanup actions...'
}

# Terminates script execution.
# It takes a single argument containing the error message.
#
# Parameters:
#   message: The error message
#
# Returns:
#   1
terminate_execution() {
  local message="$1"
  local exit_code=1

  print_error "${message}"
  print_usage
  cleanup
  exit "${exit_code}"
}

# Takes a single argument 'name' and prints a greeting message
# with the provided name.
#
# Usage:
#   print_name "John"
#
# Parameters:
#   name: The name to be included in the greeting message.
#
# Outputs:
#   Prints a greeting message
print_name() {
  local name="$1"

  printf 'Hello, %s!\n' "${name}"
}

# Parses the command-line arguments passed to the script.
#
# Usage:
#   parse_parameters "$@"
#
# Parameters:
#   $@: The command-line arguments
#
# Returns:
#   None
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
            name="${OPTARG}"
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

# Entry point of the script.
# It parses the command-line arguments and calls the appropriate functions.
#
# Parameters:
#   None
#
# Returns:
#   None
main() {
  setup_signal_traps
  parse_parameters "$@"
  print_name "${name}"
}

#===============================================================================
# Execution
#===============================================================================

main "$@"
