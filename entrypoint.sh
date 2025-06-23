#!/bin/sh

cd /var/www

# إذا .env غير موجود، أنشئه
if [ ! -f .env ]; then
  cp .env.example .env
fi

# قراءة متغيرات البيئة من Render (config:cache يقرأ env vars)
php artisan config:clear
php artisan cache:clear
php artisan route:clear

# إذا لم يكن لديك APP_KEY، أنشئه
php artisan key:generate --force --no-interaction

# إعادة إنشاء الجداول دون حذف ملفات passport migrations
php artisan migrate:fresh --force --no-interaction

# تثبيت Passport (بدون prompt)
php artisan passport:install --force --no-interaction

# تشغيل Seeder
php artisan db:seed --force --no-interaction

# تشغيل السيرفر
php artisan serve --host=0.0.0.0 --port=8000
