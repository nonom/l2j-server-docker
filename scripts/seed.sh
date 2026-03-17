#!/bin/sh
set -e

SEED_SRC=/opt/l2j/deploy/game/data
SEED_DEST="${DATA_MOUNT:-/opt/l2j/data}"

seed() {
  file="$1"
  [ -n "$file" ] || return 0

  matches="$(find "$SEED_SRC" -type f -path "$SEED_SRC/$file")"
  if [ -z "$matches" ]; then
    echo "ERROR: '$file' did not match any files under '$SEED_SRC'" >&2
    return 1
  fi

  printf '%s\n' "$matches" | while IFS= read -r src; do
    rel="${src#$SEED_SRC/}"
    dst="$SEED_DEST/$rel"
    mkdir -p "$(dirname "$dst")"
    [ -f "$dst" ] || cp "$src" "$dst"
  done
}

seed_list() {
  list="$1"
  [ -n "$list" ] || return 0

  ifs="$IFS"
  set -f
  IFS=",;"
  for raw in $list; do
    file="$(echo "$raw" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    seed "$file"
  done
  IFS="$ifs"
  set +f
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

