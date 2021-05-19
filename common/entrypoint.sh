#!/usr/bin/env sh

set -eo pipefail

for i in /siu-entrypoint.d/* ; do
  source $i
done

exec "$@"
