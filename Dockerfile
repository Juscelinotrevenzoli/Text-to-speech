# Dockerfile - PHP 8.2 + Apache (sem banco de dados)
FROM php:8.2-apache

# Ativa módulos do Apache e configura o DocumentRoot
RUN a2enmod rewrite headers \
  && sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf \
  && sed -ri 's/AllowOverride\s+None/AllowOverride All/g' /etc/apache2/apache2.conf

# Dependências mínimas do sistema
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg62-turbo-dev libfreetype6-dev libzip-dev \
  && rm -rf /var/lib/apt/lists/*

# Extensões PHP essenciais (sem PDOs de banco)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) gd zip opcache

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

# Instala dependências Laravel
RUN composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader \
  && chown -R www-data:www-data /var/www/html \
  && find storage bootstrap/cache -type d -exec chmod 775 {} \;

EXPOSE 80
CMD ["apache2-foreground"]
