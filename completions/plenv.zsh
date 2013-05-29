if [[ ! -o interactive ]]; then
    return
fi

compctl -K _plenv plenv

_plenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(plenv commands)"
  else
    completions="$(plenv completions ${words[2,-2]})"
  fi

  reply=("${(ps:\n:)completions}")
}
