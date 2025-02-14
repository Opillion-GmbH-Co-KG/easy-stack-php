#!/usr/bin/dumb-init /bin/bash

echo "PID: $$ Entrypoint started"
php-fpm --nodaemonize &

bash /var/www/script/startup.sh &

sleep 10
count=1
while true; do
  bash /var/www/script/cron.sh
  count=$((count+1))
done

echo "$PID: $$ Entrypoint died"
