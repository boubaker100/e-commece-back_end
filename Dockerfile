FROM php:8.3-fpm

# تثبيت الإضافات المطلوبة للـ Laravel + MySQL
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    curl \
    git \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    libmcrypt-dev \
    libssl-dev \
    default-mysql-client \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# نسخ كل الملفات
COPY . .
# إعداد ملف .env
RUN cp .env.example .env
# تثبيت باكج Laravel
RUN composer install --no-dev --optimize-autoloader

# إعدادات Laravel
RUN php artisan key:generate
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
