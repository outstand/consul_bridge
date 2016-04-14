#!/bin/dumb-init /bin/sh
set -e

if [ "$(id -u)" = '0' ] && [ "$1" != 'ash' ]; then
  exec gosu bridge consul_bridge "$@"
fi

exec "$@"
