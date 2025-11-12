#!/bin/bash

# Script de inicialização do Docker

set -e

echo "🚀 Iniciando aplicação Laravel TTS em Docker..."

# Gerar APP_KEY se não existir
if [ -z "$APP_KEY" ]; then
    echo "📝 Gerando APP_KEY..."
    php artisan key:generate
fi

# Executar migrações
echo "🗄️  Executando migrações..."
php artisan migrate --force

# Limpar cache
echo "🧹 Limpando cache..."
php artisan cache:clear
php artisan config:clear

# Publicar assets
echo "📦 Publicando assets..."
php artisan storage:link

echo "✅ Inicialização concluída com sucesso!"
