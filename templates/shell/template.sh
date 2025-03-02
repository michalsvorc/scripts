#!/usr/bin/env bash
#
# Shell script template.
#
# Version: 1.1.0
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/shell

#===============================================================================
# Shell script execution options
#===============================================================================

set -o errexit  # Exit if any command exits with a nonzero (error) status.
set -o nounset  # Disallow expansion of unset variables.
set -o pipefail # Use last non-zero exit code in a pipeline.
set -o errtrace # Ensure the error trap handler is properly inherited.

# Enable shell script debugging mode when the DEBUG environment variable is set.

if [[ "${DEBUG-}" =~ ^1|[Tt]rue|[Yy]es$ ]]; then
  set -o xtrace
  printf '%s\n' 'Shell script debugging mode enabled.'
fi

#===============================================================================
# Variables
#===============================================================================

readonly AGE_DEFAULT=42
script_name=$(basename "${BASH_SOURCE[0]}")
readonly script_name

#===============================================================================
# Usage
#===============================================================================

print_usage() {
  cat <<EOF
Usage: ${script_name} [-h] [-v] [-a age] name

Basic BASH script template. Prints a greeting message.

Positional arguments:
  name          specify a name for the greeting message

Options:
  -h            show help screen and exit
  -a age        specify a number for age (default: ${AGE_DEFAULT})
EOF
}

#===============================================================================
# Functions
#===============================================================================

#===============================================================================
# Entry point of the script.
# Globals:
#   age
#   name
# Arguments:
#   None
#===============================================================================
main() {
  parse_arguments "$@"
  print_name
  print_age
}

#===============================================================================
# Parses the command-line arguments passed to the script.
# Globals:
#   age
#   AGE_DEFAULT
#   name
#===============================================================================
parse_arguments() {
  # Options
  age="${AGE_DEFAULT}"

  while getopts ":ha:" opt; do
    case $opt in
    h)
      print_usage
      exit 0
      ;;
    a)
      age="${OPTARG}"
      ;;
    \?)
      terminate "Invalid option: -${OPTARG}"
      ;;
    :)
      terminate "Option -${OPTARG} requires an argument."
      ;;
    esac
  done

  shift $((OPTIND - 1))

  # Positional arguments
  test_positional_arguments "$@"
  name="${1:-}"

  # Mark globals readonly
  readonly age
  readonly name
}

#===============================================================================
# Tests positional arguments with the provided name.
#
# Arguments:
#   name: The name to be included in the greeting message.
# Outputs:
#   Prints a greeting message to stdout.
#===============================================================================
test_positional_arguments() {
  local -r arg_count="$#"

  if [ "${arg_count}" -eq 0 ]; then
    terminate 'No positional arguments provided.'
  fi
}

#===============================================================================
# Takes a single argument 'name' and prints a greeting message
# with the provided name.
#
# Arguments:
#   name: The name to be included in the greeting message.
# Outputs:
#   Prints a greeting message to stdout.
#===============================================================================
print_name() {
  printf 'Hello, %s!\n' "${name}"
}

#===============================================================================
# Takes a single argument 'age' and prints a message with the provided age.
#
# Arguments:
#   age: The age to be included in the message.
# Outputs:
#   Prints a greeting message to stdout.
#===============================================================================
print_age() {
  printf 'Age: %s\n' "${age}"
}

#===============================================================================
# Prints an error message.
#
# Arguments:
#   message: The error message.
# Outputs:
#   Writes the error message to stderr.
#===============================================================================
print_error() {
  local -r message="$1"
  printf 'Error: %s\n\n' "${message}" >&2
}

#===============================================================================
# Terminates script execution.
#
# Arguments:
#   message: The error message.
# Outputs:
#   Writes the error message stderr.
# Returns:
#   Exits with a nonzero (error) status.
#===============================================================================
terminate() {
  local -r message="$1"
  local -r EXIT_CODE=1

  print_error "${message}"
  print_usage
  exit "${EXIT_CODE}"
}

#===============================================================================
# Execution
#===============================================================================

main "$@"
