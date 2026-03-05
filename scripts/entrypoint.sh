#!/bin/sh
set -e

sh /opt/l2j/scripts/seed.sh

exec /entrypoint.sh
