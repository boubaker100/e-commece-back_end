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

# تثبيت الـ PHP packages
RUN composer install --no-dev --optimize-autoloader

# توليد key إذا لم يكن موجود (يمكن تغييره لاحقًا)
RUN php artisan key:generate --show

# تعديل أذونات التخزين
RUN chown -R www-data:www-data storage bootstrap/cache

# إتاحة البورت الخاص بـ Render
EXPOSE 10000

# الأمر الذي سيشغّل Laravel (Render سيحدد PORT)
CMD php artisan serve --host 0.0.0.0 --port $PORT
 