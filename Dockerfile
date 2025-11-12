# Dockerfile - Laravel + PHP 8.2 + Apache
FROM php:8.2-apache

# Ativa módulos do Apache e aponta o DocumentRoot para /public
RUN a2enmod rewrite headers \
  && sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf \
  && sed -ri 's/AllowOverride\s+None/AllowOverride All/g' /etc/apache2/apache2.conf

# Dependências do sistema para extensões PHP
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg62-turbo-dev libfreetype6-dev libzip-dev libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# Extensões PHP (ajuste se não precisar de pgsql)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) gd zip pdo pdo_mysql pdo_pgsql pdo_sqlite opcache

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

# Instala dependências Laravel (produção)
RUN composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader \
  && chown -R www-data:www-data /var/www/html \
  && find storage bootstrap/cache -type d -exec chmod 775 {} \;

# Entrypoint que prepara APP_KEY, cache e SQLite (se usado)
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80
ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
