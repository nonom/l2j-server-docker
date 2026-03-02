#!/bin/sh
set -e

seed() {
  file="$1"
  [ -n "$file" ] || return 0

  src="/opt/l2j/deploy/game/data/$file"
  dst="/opt/l2j/data/$file"

  mkdir -p "$(dirname "$dst")"
  [ -f "$dst" ] || cp "$src" "$dst"
}

seed_list() {
  list="$1"
  [ -n "$list" ] || return 0

  ifs="$IFS"
  IFS=",;"
  for raw in $list; do
    file="$(echo "$raw" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    seed "$file"
  done
  IFS="$ifs"
}

if [ -n "${1:-}" ]; then
  seed "$1"
  exit 0
fi

seed_list "${L2J_FILES:-}"

for key in $(env | sed -n 's/=.*//p' | grep '^L2J_FILES_' || true); do
  value="$(printenv "$key")"
  seed_list "$value"
done

exec /entrypoint.sh
