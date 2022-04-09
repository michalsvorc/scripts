#!/usr/bin/env bash
#
# Application: LF
# Description: Application install script.
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

repository_id="gokcehan/lf"
asset="lf-linux-amd64.tar.gz"
executable_dir='bin'
repository_uri="https://api.github.com/repos/${repository_id}/releases"

#===============================================================================
# Functions
#===============================================================================

function get_release_metadata() {
  local repository_uri="${1}"

  printf '%s' $(\
    jq -r ".[0]" \
    <<< $(curl "${repository_uri}")  \
  )
}

function parse_tag_name() {
  local release_metadata="${1}"

  printf '%s' $(\
    jq -r ".tag_name" \
    <<< "${release_metadata}"  \
  )
}

function parse_download_uri() {
  local release_metadata="${1}"
  local asset="${2}"

  printf '%s' $(\
    jq -r ".assets \
    | map(select(.name==\"${asset}\"))[0] \
    | .browser_download_url" \
    <<< "${release_metadata}"  \
  )
}

#===============================================================================
# Execution
#===============================================================================

release_metadata=$(get_release_metadata $repository_uri)
tag_name=$(parse_tag_name "${release_metadata}")
download_uri=$(parse_download_uri "${release_metadata}" "${asset}")
executable="${tag_name}_${asset%.tar.gz}"

mkdir -p $executable_dir \
  && cd $_ \
  && asset=$(curl -JLOw "%{filename_effective}" $download_uri) \
  && tar -xvf $asset -C . \
  && rm $asset \
  && mv "lf" $executable \
  && cd - \
  && ln -sf "${executable_dir}/${executable}" "run"

