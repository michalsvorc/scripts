#!/usr/bin/env bash
#
# Description: Download assets from a GitHub release.
#
# Dependencies: curl, cut, egrep, grep
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)

#===============================================================================
# Abort the script on errors and unbound variables
#===============================================================================

set -o errexit      # Abort on nonzero exit status.
set -o nounset      # Abort on unbound variable.
set -o pipefail     # Don't hide errors within pipes.
# set -o xtrace       # Set debugging.

#===============================================================================
# Variables
#===============================================================================

readonly version='1.0.0'
readonly argv0=${0##*/}

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage: ${argv0} [options] <repository> <asset>

Download release asset from GitHub.

Options:
  -h              Show help screen and exit.
  -v              Show program version and exit.

  -t <tag>        Release tag, defaults to latest release.

Arguments:
  repository      Repository id in 'user/package' format.
  asset           Asset to download, provided as an 'egrep' regexp.


Examples:
  Download asset:
  ${argv0} user/package *_x86_64.tar.gz > asset.tar.gz

  Pipe downloaded asset to extraction command:
  ${argv0} user/package *_x86_64.tar.gz | tar zx
EOF
  exit ${1:-0}
}

#===============================================================================
# Functions
#===============================================================================

die() {
  local message="$1"

  printf 'Error: %s\n\n' "$message" >&2
  usage 1 1>&2
}

print_version() {
  printf '%s version: %s\n' "$argv0" "$version"
}

test_argument() {
  local value="$1"
  local name="$2"

  test -z "$value" \
    && die "Missing '${name}' argument." \
    || return 0
}

construct_download_uri() {
  local release='latest'
  local tag=${tag:-}

  test ! -z "$tag" && release="tags/${tag}"

  local release_uri="https://api.github.com/repos/${repository}/releases/${release}"
  local download_uri=$(curl -s "$release_uri" \
    | grep browser_download_url \
    | cut -d\" -f4 \
    | egrep "$asset\$")

  test -z "$download_uri" \
    && die "Error constructing download URI. No asset for '$asset' found." \
    || printf '%s' "$download_uri"
}

download_asset() {
  local download_uri="$1"

  curl -L "$download_uri"
}

main() {
  local download_uri=$(construct_download_uri)

  download_asset "$download_uri"
}

#===============================================================================
# Execution
#===============================================================================

test $# -eq 0 && die 'No arguments provided.'

while getopts ":hva:o:r:t:" options; do
  case "${options}" in
    h)
      usage 0
      ;;
    v)
      print_version
      exit 0
      ;;

    t)
      tag="${OPTARG-}"
      ;;
    :)
      die "Error: -${OPTARG} option requires an argument."
      ;;
    \?) die "Invalid option -${OPTARG}"
      ;;
  esac
done
shift $((OPTIND-1))

readonly repository="${1:-}"
readonly asset="${2:-}"

test_argument "$repository" 'repository'
test_argument "$asset" 'asset'

main
