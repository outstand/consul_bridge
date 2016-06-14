#!/bin/dumb-init /bin/sh
set -e

if [ -n "$USE_BUNDLE_EXEC" ]; then
  BINARY="bundle exec consul_bridge"
else
  BINARY=consul_bridge
fi

if ${BINARY} help "$1" 2>&1 | grep -q "consul_bridge $1"; then
  set -- ${BINARY} "$@"

  if [ -n "$FOG_LOCAL" ]; then
    chown -R bridge:bridge /fog
  fi
fi

exec "$@"
