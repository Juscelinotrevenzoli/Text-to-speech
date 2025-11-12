#!/usr/bin/env bash
set -e

cd /var/www/html

# Garante diretórios do Laravel
mkdir -p storage/framework/{cache,sessions,views} storage/logs bootstrap/cache

# Se usar SQLite, cria o arquivo se não existir
if [ "${DB_CONNECTION}" = "sqlite" ] && [ -n "${DB_DATABASE}" ]; then
  if [ ! -f "${DB_DATABASE}" ]; then
    mkdir -p "$(dirname "${DB_DATABASE}")"
    touch "${DB_DATABASE}"
    chown www-data:www-data "${DB_DATABASE}"
  fi
fi

# Gera APP_KEY se estiver faltando
if [ -z "${APP_KEY}" ] || [[ "${APP_KEY}" == base64:*xxxx* ]]; then
  php artisan key:generate --force || true
fi

# Otimizações em produção (ignora erro se .env ainda não estiver 100%)
if [ "${APP_ENV}" = "production" ]; then
  php artisan config:cache || true
  php artisan route:cache || true
  php artisan view:cache  || true
fi

exec "$@"
