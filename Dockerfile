# Dockerfile - PHP 8.2 + Apache + Node.js
FROM php:8.2-apache

# Ativa módulos do Apache e configura o DocumentRoot
RUN a2enmod rewrite headers \
  && sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf \
  && sed -ri 's/AllowOverride\s+None/AllowOverride All/g' /etc/apache2/apache2.conf

# Dependências do sistema + Node.js
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg62-turbo-dev libfreetype6-dev libzip-dev \
    curl sqlite3 libsqlite3-dev \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

# Extensões PHP essenciais
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) gd zip opcache pdo pdo_sqlite mbstring exif pcntl bcmath

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

# Instala dependências Laravel
RUN composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader

# Instala dependências Node e constrói assets
RUN npm install && npm run build

# Cria diretórios e define permissões
RUN mkdir -p storage/app/public/tts \
  && chown -R www-data:www-data /var/www/html \
  && find storage bootstrap/cache -type d -exec chmod 775 {} \; \
  && find storage bootstrap/cache -type f -exec chmod 664 {} \;

# Cria storage link
RUN php artisan storage:link

# Limpa cache
RUN php artisan config:clear

EXPOSE 80
CMD ["apache2-foreground"]
