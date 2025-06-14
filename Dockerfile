# استخدام PHP مع Apache
FROM php:8.2-apache

# تثبيت الحزم
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip unzip curl git libpq-dev netcat-openbsd \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# نسخ ملفات المشروع
COPY . /var/www/html

WORKDIR /var/www/html

# تثبيت الحزم
RUN composer install --optimize-autoloader --no-dev

# إنشاء المجلدات المطلوبة إذا لم تُنسخ، وإعطاء الصلاحيات
RUN mkdir -p storage bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# تفعيل mod_rewrite
RUN a2enmod rewrite

# إعداد Apache
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

# نقطة البداية
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

EXPOSE 80
