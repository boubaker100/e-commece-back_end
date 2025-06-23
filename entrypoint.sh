#!/bin/sh

# 1) إذا لم يكن ملف .env موجودًا، أنشئه من المثال لكي لا يفشل الـ key:generate
if [ ! -f /var/www/.env ]; then
  cp /var/www/.env.example /var/www/.env
fi

# 2) مسح الكاش حتى يقرأ Laravel متغيرات البيئة من Dashboard
php artisan config:clear
php artisan cache:clear
php artisan route:clear

# 3) لا تُنشئ مفتاح جديد إذا كان لديك APP_KEY مُعين كـ env var
#    بل فقط إن اختفت القيمة.
php artisan key:generate --force

# 4) أنشُئ جداول القاعدة
php artisan migrate:fresh --force

# 5) أنشِئ عملاء Passport (personal + password grant)
php artisan passport:install --force

# 6) شغّل Seeder
php artisan db:seed --force

# 7) شغّل السيرفر
php artisan serve --host=0.0.0.0 --port=8000
