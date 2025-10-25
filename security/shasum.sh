#!/usr/bin/env bash

find . -type f -execdir bash -c '
  algorithm=512
  file="$1"
  shasum -a "$algorithm" "$file" > "$file.sha$algorithm"
' bash {} \;
