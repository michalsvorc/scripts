#!/usr/bin/env bash
#
# Application: Neovim
# Description: Application install script.
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

readonly repository_id='neovim/neovim'
readonly tag_name='nightly'
readonly executable='squashfs-root/AppRun'
readonly executable_dir='bin'
readonly extension='appimage'
readonly repository_uri="https://api.github.com/repos/${repository_id}/releases"

#===============================================================================
# Functions
#===============================================================================

get_release_metadata() {
  local repository_uri="$1"
  local tag_name="$2"

  printf '%s' $(\
    jq -r ".[] | select(.tag_name==\"${tag_name}\")" \
    <<< $(curl "$repository_uri")  \
  )
}

parse_download_uri() {
  local release_metadata="$1"
  local extension="$2"

  printf '%s' $(\
    jq -r ".assets \
    | map(select(.name|endswith(\"$extension\")))[0] \
    | .browser_download_url" \
    <<< "$release_metadata"  \
  )
}

#===============================================================================
# Execution
#===============================================================================

release_metadata=$(get_release_metadata "$repository_uri" "$tag_name")
download_uri=$(parse_download_uri "$release_metadata" "$extension")
asset="${tag_name}.${extension}"

mkdir -p "$executable_dir" \
  && cd $_ \
  && curl -Lo "$asset" "$download_uri" \
  && chmod u+x "$asset" \
  && "./${asset}" --appimage-extract \
  && rm "$asset" \
  && cd - \
  && ln -sf "${executable_dir}/${executable}" 'run'

