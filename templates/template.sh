#!/usr/bin/env bash
#
# Shell script template.
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/shell

#===============================================================================
# Shell script execution options
#===============================================================================

set -o errexit  # Exit if any command exits with a nonzero (error) status
set -o nounset  # Disallow expansion of unset variables
set -o pipefail # Use last non-zero exit code in a pipeline
set -o errtrace # Ensure the error trap handler is properly inherited

# Enable shell script debugging mode when the DEBUG environment variable is set

if [[ ${DEBUG-} =~ ^1|[Tt]rue|[Yy]es$ ]]; then
  set -o xtrace
  printf '%s\n' 'Shell script debugging mode enabled.'
fi

#===============================================================================
# Variables
#===============================================================================

readonly VERSION='1.0.2'
readonly DEFAULT_AGE=42

script_name=$(basename "${BASH_SOURCE[0]}")
readonly script_name

#===============================================================================
# Usage
#===============================================================================

# Prints the program usage.
#
# Globals:
#   script_name
#   name
#
# Arguments:
#   None
#
# Outputs:
#   Prints the program usage.
print_usage() {
  cat <<EOF
Usage: ${script_name} [...options] name

Basic BASH script template. Prints a greeting message.

Positional arguments:
  name          specify a name for the greeting message

Options:
  -h            show help screen and exit
  -v            show program version and exit
  -a            set age (default: ${DEFAULT_AGE})
EOF
}

#===============================================================================
# Functions
#===============================================================================

# Entry point of the script.
# It parses the command-line arguments and calls the appropriate functions.
#
# Arguments:
#   None
#
# Returns:
#   None
main() {
  parse_arguments "$@"
  print_name "${name}"
  print_age "${age}"
}

# Parses the command-line arguments passed to the script.
#
# Usage:
#   parse_arguments "$@"
#
# Arguments:
#   $@: The command-line arguments.
#
# Returns:
#   None
parse_arguments() {
  # Default arguments
  age=${DEFAULT_AGE}

  # Optional arguments
  while getopts ":vha:" opt; do
    case $opt in
    v)
      print_version VERSION
      exit 0
      ;;
    h)
      print_usage
      exit 0
      ;;
    a)
      age="${OPTARG}"
      ;;
    \?)
      terminate_execution "Invalid option: -${OPTARG}"
      ;;
    :)
      terminate_execution "Option -${OPTARG} requires an argument."
      ;;
    esac
  done
  shift $((OPTIND - 1))

  # Positional arguments
  test $# -eq 0 && terminate_execution 'No positional arguments provided.'
  name="${1:-}"
}

# Prints an error message.
#
# Arguments:
#   message: The error message.
#
# Outputs:
#   Writes the error message to stderr.
print_error() {
  local -r message="$1"
  printf 'Error: %s\n\n' "${message}" >&2
}

# Prints the program version.
#
# Arguments:
#   VERSION: The program version.
#
# Outputs:
#   Writes the program version to stdout.
print_version() {
  printf '%s version: %s\n' "${script_name}" "${VERSION}"
}

# Terminates script execution.
#
# Arguments:
#   message: The error message.
#
# Returns:
#   Exits with a nonzero (error) status.
terminate_execution() {
  local -r message="$1"
  local -r EXIT_CODE=1

  print_error "${message}"
  print_usage
  exit "${EXIT_CODE}"
}

# Takes a single argument 'name' and prints a greeting message
# with the provided name.
#
# Arguments:
#   name: The name to be included in the greeting message.
#
# Outputs:
#   Prints a greeting message to stdout.
print_name() {
  local -r name="$1"
  printf 'Hello, %s!\n' "${name}"
}

# Takes a single argument 'age' and prints a message
# with the provided age.
#
# Arguments:
#   age: The age to be included in the message.
#
# Outputs:
#   Prints a greeting message to stdout.
print_age() {
  local -r age="$1"
  printf 'Age: %s\n' "${age}"
}

#===============================================================================
# Execution
#===============================================================================

main "$@"

#===============================================================================
# Snippets
#===============================================================================
#
# Directory containing the script file
#
# script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
# readonly script_dir
