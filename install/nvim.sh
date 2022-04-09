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

repository_id="neovim/neovim"
tag_name="nightly"
extension='appimage'
executable="squashfs-root/AppRun"
executable_dir='bin'

releases_uri="https://api.github.com/repos/${repository_id}/releases"
asset="${tag_name}.${extension}"

#===============================================================================
# Functions
#===============================================================================

function get_release_metadata() {
  local releases_uri="${1}"
  local tag_name="${2}"

  printf '%s' $(\
    jq -r ".[] | select(.tag_name==\"${tag_name}\")" \
    <<< $(curl "${releases_uri}")  \
  )
}

function get_download_uri() {
  local release_metadata="${1}"
  local extension="${2}"

  printf '%s' $(\
    jq -r ".assets \
    | map(select(.name|endswith(\"${extension}\"))).[0] \
    | .browser_download_url" \
    <<< "${release_metadata}"  \
  )
}

#===============================================================================
# Execution
#===============================================================================

release_metadata=$(get_release_metadata $releases_uri $tag_name)
download_uri=$(get_download_uri $release_metadata $extension)

mkdir -p $executable_dir \
  && cd $_ \
  && curl -Lo $asset $download_uri \
  && chmod u+x $asset \
  && "./${asset}" --appimage-extract \
  && rm $asset \
  && cd - \
  && ln -sf "${executable_dir}/${executable}" "run"

