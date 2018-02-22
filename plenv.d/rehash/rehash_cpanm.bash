#!/usr/bin/env bash
set -e

CPANM_SHIM_PATH="$SHIM_PATH/cpanm"

command -p cat > "$CPANM_SHIM_PATH" <<SH
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
    '-h'|'--help'|'-V'|'--version'|'--info'|'-L'|'--local-lib-contained'|'-l'|'--local-lib')
      exit \$rc
    ;;
  esac
done
"$(command -v plenv)" rehash
exit \$rc
SH

command -p chmod +x "$CPANM_SHIM_PATH"
