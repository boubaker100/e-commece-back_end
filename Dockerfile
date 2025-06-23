FROM php:8.3-fpm

# تثبيت الحزم اللازمة
RUN apt-get update && apt-get install -y \
    zip unzip git curl default-mysql-client \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev libzip-dev libssl-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN composer install --no-dev --optimize-autoloader

# انشر ملفات passport migrations الآن لتجنّب prompt لاحقًا
RUN php artisan vendor:publish --tag=passport-migrations --force

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

CMD ["/entrypoint.sh"]
