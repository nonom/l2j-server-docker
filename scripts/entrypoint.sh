#!/bin/sh
set -e

sh /opt/l2j/scripts/seed.sh
sh /opt/l2j/scripts/compare.sh

exec /entrypoint.sh
