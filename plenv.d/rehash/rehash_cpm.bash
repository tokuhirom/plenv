#!/usr/bin/env bash
set -e

CPM_SHIM_PATH="$SHIM_PATH/cpm"

command -p cat > "$CPM_SHIM_PATH" <<SH
#!/usr/bin/env bash
set -e
[ -n "\$PLENV_DEBUG" ] && set -x

program="\${0##*/}"

export PLENV_ROOT="$PLENV_ROOT"
"$(command -v plenv)" exec "\$program" "\$@"
rc=\$?
for arg in \$@
do
  case \$arg in
    '-g'|'--global')
      "$(command -v plenv)" rehash
      exit \$rc
    ;;
  esac
done
exit \$rc
SH

command -p chmod +x "$CPM_SHIM_PATH"
