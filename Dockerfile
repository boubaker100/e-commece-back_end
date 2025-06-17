FROM php:8.2-apache

# تثبيت الحزم المطلوبة
RUN apt-get update && apt-get install -y \
    libpng-dev libonig-dev libxml2-dev zip unzip curl git libpq-dev netcat-openbsd \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# نسخ ملفات المشروع
COPY . /var/www/html
WORKDIR /var/www/html

# تثبيت الباكدج بدون dev
RUN composer install --optimize-autoloader --no-dev

# إنشاء المجلدات المهمة + صلاحيات
RUN mkdir -p storage/framework/{sessions,views,cache} bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# إعداد Apache
RUN a2enmod rewrite
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# نسخ وتشغيل سكريبت التهيئة
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
