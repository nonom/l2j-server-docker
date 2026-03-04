#!/bin/sh
set -e

SQL_ROOT="${SQL_ROOT:-data/sql}"
tmp_files="$(mktemp)"
trap 'rm -f "$tmp_files"' EXIT

[ -d "$SQL_ROOT" ] || {
  echo "No SQL directory found at $SQL_ROOT"
  exit 0
}

find "$SQL_ROOT" -type f -name "*.sql" | sort > "$tmp_files"

[ -s "$tmp_files" ] || {
  echo "No SQL files found under $SQL_ROOT/**/*.sql"
  exit 0
}

while IFS= read -r f; do
  [ -f "$f" ] || continue
  echo "Applying: $f"
  docker compose exec -T l2j-database \
    mariadb -u"${DB_USER:-l2jgs}" -p"${DB_PASS:-l2jgs_password}" "${L2JGAME_DB_NAME:-l2jgs}" < "$f"
done < "$tmp_files"
