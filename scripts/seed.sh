#!/bin/sh
set -e

SRC_ROOT="/opt/l2j/deploy/game/data"
DST_ROOT="/opt/l2j/data"

seed() {
  file="$1"
  [ -n "$file" ] || return 0

  matches="$(find "$SRC_ROOT" -type f -path "$SRC_ROOT/$file")"
  if [ -z "$matches" ]; then
    echo "ERROR: '$file' did not match any files under '$SRC_ROOT'" >&2
    return 1
  fi

  printf '%s\n' "$matches" | while IFS= read -r src; do
    rel="${src#$SRC_ROOT/}"
    dst="$DST_ROOT/$rel"
    mkdir -p "$(dirname "$dst")"
    [ -f "$dst" ] || cp "$src" "$dst"
  done
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

seed_list "${L2JFILES:-}"

for key in $(env | sed -n 's/=.*//p' | grep '^L2JFILES_' || true); do
  value="$(printenv "$key")"
  seed_list "$value"
done

chmod -R a+rwX "$DST_ROOT" 2>/dev/null || true

exec /entrypoint.sh
