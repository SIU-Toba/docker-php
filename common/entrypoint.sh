#!/usr/bin/env sh

set -eo pipefail

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "siu-toba:x:$(id -u):0:SIU toba:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

for i in /siu-entrypoint.d/* ; do
  source $i
done

exec "$@"
