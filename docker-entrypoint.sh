#!/bin/dumb-init /bin/sh
set -e

if consul_bridge help "$1" 2>&1 | grep -q "consul_bridge $1"; then
  set -- consul_bridge "$@"
fi

if [ "$1" = 'consul_bridge' ]; then
  set -- gosu bridge "$@"
fi

exec "$@"
