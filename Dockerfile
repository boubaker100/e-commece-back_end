FROM php:8.2-apache

# تثبيت التبعيات الأساسية (أضف libzip-dev و zip)
RUN apt-get update && apt-get install -y \
    libpng-dev libonig-dev libxml2-dev libzip-dev libpq-dev \
    zip unzip curl git netcat-openbsd \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# نسخ ملفات المشروع
COPY . /var/www/html
WORKDIR /var/www/html

# إنشاء المجلدات المهمة + صلاحيات (بدون chown هنا)
RUN mkdir -p storage/framework/{sessions,views,cache} bootstrap/cache

# تثبيت الباكدج بدون dev
RUN composer install --optimize-autoloader --no-dev

# تعيين الصلاحيات بعد تثبيت التبعيات
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# إنشاء رابط التخزين
RUN php artisan storage:link

# إعداد Apache
RUN a2enmod rewrite
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# نسخ وتشغيل سكريبت التهيئة
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80