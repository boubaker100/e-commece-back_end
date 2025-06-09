# استخدم صورة PHP مع Apache
FROM php:8.2-apache

# تثبيت المتطلبات
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    curl \
    git \
    libpq-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# نسخ ملفات Laravel
COPY . /var/www/html

WORKDIR /var/www/html

# تثبيت باقات Laravel
RUN composer install --no-dev --optimize-autoloader

# إعطاء صلاحيات
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# تفعيل mod_rewrite
RUN a2enmod rewrite

# إعداد Apache
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
CMD ["apache2-foreground"]
