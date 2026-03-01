#!/bin/sh
set -e

FILE="$1"

SRC="/opt/l2j/deploy/game/data/$FILE"
DST="/opt/l2j/data/$FILE"

mkdir -p "$(dirname "$DST")"

[ -f "$DST" ] || cp "$SRC" "$DST"