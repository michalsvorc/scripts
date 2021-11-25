#!/usr/bin/env sh

edit_command="${HOME}/bin/nvim"

"$edit_command" $(yarn lint:es | awk '$1 ~ /^\//') $(yarn lint:tsc | grep -P 'TS\d{4}' | cut -d "(" -f1)
