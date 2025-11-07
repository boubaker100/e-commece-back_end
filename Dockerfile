# استخدم PHP + Composer الرسمي
FROM php:8.2-fpm

# تثبيت الأدوات والمكتبات المطلوبة
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libzip-dev \
    libonig-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

# تثبيت Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# إعداد مجلد العمل
WORKDIR /var/www/html

# نسخ ملفات المشروع إلى الحاوية
COPY . .

# تثبيت حزم PHP (من composer)
RUN composer install --no-dev --optimize-autoloader

# إعطاء صلاحيات للـ storage و bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache && \
    chown -R www-data:www-data storage bootstrap/cache

# نسخ سكربت التشغيل
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# فتح المنفذ الافتراضي (Render يحدد $PORT)
EXPOSE 10000

# تشغيل التطبيق عبر سكربت الدخول
CMD ["sh", "/usr/local/bin/entrypoint.sh"]
