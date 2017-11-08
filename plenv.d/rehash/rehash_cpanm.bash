#!/usr/bin/env bash
set -e

CPAN_TEMP_HEREDOC="$SHIM_PATH/.cpan-heredoc"

cpan_clients=( 'cpan' 'cpanm' 'cpanp' )
regexp_system_perl="^system$"
# Check whether all cpan-related shims are existed in the list of
# registered shims and then create separately shims for cpanm and 
# other cpan clients (with respecting of the ExtUtils::MakeMaker's
# and Module::Build's environment variables only for system-wide Perl)
for _shim in "${cpan_clients[@]}"; do
  # Check whether shim is present in array of registered shims.
  # Yup, solution was found on StackOverflow. It is very dirty.
  # (https://stackoverflow.com/questions/14366390/check-if-an-element-is-present-in-a-bash-array)
  if [[ " ${registered_shims[*]} " == *" $_shim "* ]]; then 
    if [[ $_shim == "cpanm" ]]; then
      command -p cat > "$SHIM_PATH/$_shim" <<CPANM_SHIM
#!/usr/bin/env bash
set -e
[ -n "\$PLENV_DEBUG" ] && set -x

program="\${0##*/}"

# Respect this env vars for system-wide perl and when they're set by
# `plenv use` command (see plenv-contrib for local::lib integration).
if [[ ! \$(plenv version-name) =~ $regexp_system_perl ]] &&
   [[ ! -z \${PERL_MM_OPT##*/} ]] ; then
  unset PERL_MM_OPT
  unset PERL_MB_OPT
fi

export PLENV_ROOT="$PLENV_ROOT"
"$(command -v plenv)" exec "\$program" "\$@"
rc=\$?
for arg in \$@
do
  case \$arg in
    '-h'|'--help'|'-v'|'--version'|'--info'|'-L'|'--local-lib-contained'|'-l'|'--local-lib')
      exit \$rc
    ;;
  esac
done
"$(command -v plenv)" rehash
exit \$rc
CPANM_SHIM
    else
      command -p cat > "$SHIM_PATH/$_shim" <<CPANS_SHIM
#!/usr/bin/env bash
set -e
[ -n "\$PLENV_DEBUG" ] && set -x

program="\${0##*/}"

# Respect this env vars only for system-wide perl
if [[ ! \$(plenv-version-name) =~ $regexp_system_perl ]]; then
  unset PERL_MM_OPT
  unset PERL_MB_OPT
fi

if [ "\$program" == "perl" ]; then
  for arg; do
    [[ "\$arg" =~ ^(--$|-[0A-Za-z]*[eE].*) ]] && break
    if [[ "\$arg" =~ / ]] && [ -f "\$arg" ]; then
      export PLENV_DIR="\${arg%/*}"
      break
    fi
  done
fi

export PLENV_ROOT="\$PLENV_ROOT"
exec "$(command -v plenv)" exec "\$program" "\$@" 
CPANS_SHIM
    fi
    command -p chmod +x "$SHIM_PATH/$_shim"
  fi
done

