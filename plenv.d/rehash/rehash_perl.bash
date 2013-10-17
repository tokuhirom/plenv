#!/usr/bin/env bash
set -e

perl_shim_path="$SHIM_PATH/perl"

command -p cat > "$perl_shim_path" <<SH
#!$(command -v bash)
set -e
[[ -n "\$PLENV_DEBUG" ]] && set -x

for arg; do
  [[ "\$arg" =~ ^-(-$|[0A-Za-z]*[eE]) ]] && break
  if [[ "\$arg" =~ / && -f "\$arg" ]]; then
    export PLENV_DIR="\${arg%/*}"
    break
  fi
done

PLENV_ROOT='$PLENV_ROOT' exec '$(command -v plenv)' exec perl "\$@"
SH
command -p chmod +x "$perl_shim_path"
