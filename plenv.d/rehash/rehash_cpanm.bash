#!/usr/bin/env bash
set -e

CPANM_SHIM_PATH="$SHIM_PATH/cpanm"

cat > "$CPANM_SHIM_PATH" <<SH
#!/usr/bin/env bash
set -e
[ -n "\$PLENV_DEBUG" ] && set -x

program="\${0##*/}"
if [ "\$program" = "perl" ]; then
  for arg; do
    case "\$arg" in
    -e* | -- ) break ;;
    */* )
      if [ -f "\$arg" ]; then
        export PLENV_DIR="\${arg%/*}"
        break
      fi
      ;;
    esac
  done
fi

export PLENV_ROOT="$PLENV_ROOT"
"$(command -v plenv)" exec "\$program" "\$@"
"$(command -v plenv)" rehash
SH

chmod +x "$CPANM_SHIM_PATH"
