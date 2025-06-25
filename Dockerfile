FROM php:8.2-fpm

# تثبيت الحزم الأساسية
RUN apt-get update && apt-get install -y \
    git curl libpq-dev zip unzip libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql mbstring xml zip

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

# تثبيت البكجات
RUN composer install --no-dev --optimize-autoloader

# إعدادات Laravel
RUN php artisan config:cache

# نسخ السكريبت الخاص بالتنفيذ
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# نقطة الدخول
ENTRYPOINT ["/entrypoint.sh"]
