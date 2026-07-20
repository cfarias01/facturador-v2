#!/bin/sh
set -e

# Compartido por los 3 servicios (app/queue/scheduler, ver docker-compose.yml),
# diferenciados por APP_ROLE. Idempotente: seguro de correr en cada arranque.

php artisan storage:link || true

if [ "$APP_ROLE" = "web" ]; then
    # Solo el servicio web migra: evita que app/queue/scheduler corran
    # migrate --force a la vez en el primer arranque (condicion de carrera).
    # Las bases de datos de cada tenant se provisionan por el flujo normal
    # de la app (System\ClientController::store), no aca.
    php artisan migrate --force

    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
fi

exec "$@"
