#!/usr/bin/dumb-init /bin/bash

echo "PID: $$ Entrypoint started"
php-fpm --nodaemonize &

sleep 10
count=1
while true; do
  count=$((count+1))
done

echo "$PID: $$ Entrypoint died"
