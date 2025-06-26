FROM php:8.2-fpm

# تثبيت الحزم المطلوبة
RUN apt-get update && apt-get install -y \
    git curl libpq-dev zip unzip libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql mbstring xml zip

# تثبيت Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# تحديد مجلد العمل داخل الحاوية
WORKDIR /var/www/html

# نسخ الملفات إلى الحاوية
COPY . /var/www/html

# تثبيت مكتبات Laravel بدون بيئة dev
RUN composer install --no-dev --optimize-autoloader
EXPOSE 8000

# نسخ السكربت
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# نقطة الدخول (entrypoint)
ENTRYPOINT ["/entrypoint.sh"]
