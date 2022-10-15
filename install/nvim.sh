#!/usr/bin/env bash
#
# Description: Install script for neovim executable.
# Releases: https://github.com/neovim/neovim/releases
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

readonly version='1.0.0'
readonly argv0=${0##*/}
readonly repository_id='neovim/neovim'
readonly app_name='nvim'
readonly extension='appimage'
readonly repository_uri="https://api.github.com/repos/${repository_id}/releases"

output_dir="${PWD}"
tag_name='nightly'

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0} [options] command

Install script for lf executable.

Options:
    -h, --help                Show help screen and exit.
    -o, --output-dir <string> Specify output dir for executable.
    -t, --tag <string>        Specify release tag. Defaults to "$tag_name".
                              Defaults to \$PWD.
    -v, --version             Show program version and exit.

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

version() {
  printf '%s version: %s\n' "$argv0" "$version"
}

get_release_metadata() {
  printf '%s' $(\
    jq -r ".[] | select(.tag_name==\"${tag_name}\")" \
    <<< $(curl "$repository_uri")  \
  )
}

parse_download_uri() {
  printf '%s' $(\
    jq -r ".assets \
    | map(select(.name|endswith(\"$extension\")))[0] \
    | .browser_download_url" \
    <<< "$release_metadata"  \
  )
}

main() {
  local release_metadata=$(get_release_metadata)
  local download_uri=$(parse_download_uri)
  local asset="${tag_name}.${extension}"
  local asset_path="${output_dir}/${asset}"

  curl -Lo "$asset_path" "$download_uri" \
    && chmod u+x "$asset_path" \
    && cd "$output_dir" \
    && "./$asset" --appimage-extract \
    && cd - \
    && rm "$asset_path"
  }

#===============================================================================
# Execution
#===============================================================================

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -o | --output-dir )
    shift
    test $# -eq 0 && die 'Missing argument for option "--output-dir".'
    output_dir="${1:-output_dir}"
    ;;
  -t | --tag )
    shift
    test $# -eq 0 && die 'Missing argument for option "--tag".'
    tag_name="${1:-tag_name}"
    ;;
  -v | --version )
    version
    exit 0
    ;;
esac

main
