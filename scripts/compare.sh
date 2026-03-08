#!/bin/sh
set -e

COMPARE_SRC="/opt/l2j/deploy/game/data"
COMPARE_DST="${DATA_MOUNT:-/opt/l2j/data}"
COMPARE_VERBOSE="${COMPARE_VERBOSE:-0}"

CONFLICTS=0
COMPARED=0

echo "Comparing L2JFILES." >&2

compare_file() {
  file="$1"
  [ -n "$file" ] || return 0

  matches="$(find "$COMPARE_SRC" -type f -path "$COMPARE_SRC/$file")"
  if [ -z "$matches" ]; then
    echo "WARNING: '$file' did not match any files under '$COMPARE_SRC'" >&2
    return 0
  fi

  while IFS= read -r src; do
    [ -n "$src" ] || continue

    rel="${src#$COMPARE_SRC/}"
    dst="$COMPARE_DST/$rel"

    [ -f "$dst" ] || continue

    COMPARED=$((COMPARED + 1))
    cmp -s "$src" "$dst" && continue

    CONFLICTS=$((CONFLICTS + 1))
    echo "WARNING: override differs for '$rel'" >&2

    if [ "$COMPARE_VERBOSE" = "1" ]; then
      echo "  upstream: $(sha256sum "$src" | awk '{print $1}')" >&2
      echo "  local   : $(sha256sum "$dst" | awk '{print $1}')" >&2

      if command -v diff >/dev/null 2>&1; then
        diff -u "$src" "$dst" 2>/dev/null | sed -n '1,40p' >&2 || true
      fi
    fi
  done <<EOF
$matches
EOF
}

compare_list() {
  list="$1"
  [ -n "$list" ] || return 0

  ifs="$IFS"
  set -f
  IFS=",;"
  for raw in $list; do
    file="$(echo "$raw" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    compare_file "$file"
  done
  IFS="$ifs"
  set +f
}

if [ -n "${1:-}" ]; then
  compare_file "$1"
else
  compare_list "${L2JFILES:-}"

  for key in $(env | sed -n 's/=.*//p' | grep '^L2JFILES_' || true); do
    value="$(printenv "$key")"
    compare_list "$value"
  done
fi

echo "Comparision result: $COMPARED files ($CONFLICTS conflicts)." >&2
