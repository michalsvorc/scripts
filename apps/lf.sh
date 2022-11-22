#!/usr/bin/env bash
#
# Description: Install script for lf executable.
# Releases: https://github.com/gokcehan/lf/releases
#
# Dependencies: curl, jq
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

readonly version='2.0.0'
readonly argv0=${0##*/}
readonly repository_uri="https://api.github.com/repos/gokcehan/lf/releases"

asset='lf-linux-amd64.tar.gz'
output_dir="${PWD}"

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] command

Download script for lf executable.

Options:
    -h, --help                Show help screen and exit.
    -v, --version             Show program version and exit.

    -a, --asset <filename>    Asset filename to download. Defaults to "$asset".
    -o, --output-dir <dir>    Output directory for downloaded asset.
                              Defaults to \$PWD.
    -t, --tag <tag>           Release tag. Defaults to latest.

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

get_release_metadata() {
  printf '%s' $(\
    jq -r ".[0]" \
    <<< $(curl "$repository_uri")  \
  )
}

parse_tag_name() {
  printf '%s' $(\
    jq -r ".tag_name" \
    <<< "$release_metadata"  \
  )
}

parse_download_uri() {
  printf '%s' $(\
    jq -r ".assets \
    | map(select(.name==\"${asset}\"))[0] \
    | .browser_download_url" \
    <<< "$release_metadata"  \
  )
}

main() {
  local release_metadata=$(get_release_metadata)
  local download_uri=$(parse_download_uri)
  local asset_path="${output_dir}/${asset}"

  curl -Lo "$asset_path" "$download_uri"
}

#===============================================================================
# Execution
#===============================================================================

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -a | --asset )
    shift
    test $# -eq 0 && die 'Missing argument for option "--asset".'
    asset="${1:-asset}"
    ;;
  -o | --output-dir )
    shift
    test $# -eq 0 && die 'Missing argument for option "--output-dir".'
    output_dir="${1:-output_dir}"
    ;;
  -t | --tag )
    shift
    test $# -eq 0 && die 'Missing argument for option "--tag".'
    tag_name="${1:-parse_tag_name}"
    ;;
  -v | --version )
    print_version
    exit 0
    ;;
esac

main
