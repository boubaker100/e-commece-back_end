# استخدم PHP + Composer الرسمي
FROM php:8.2-fpm

# تثبيت dependencies الأساسية
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libzip-dev \
    libonig-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

# تثبيت Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# إعداد دليل العمل
WORKDIR /var/www/html

# نسخ ملفات المشروع
COPY . .

# تثبيت الحزم
RUN composer install --no-dev --optimize-autoloader

# تعديل أذونات المجلدات
RUN chown -R www-data:www-data storage bootstrap/cache

# نسخ وتشغيل سكريبت التشغيل
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# فتح المنفذ
EXPOSE 10000
