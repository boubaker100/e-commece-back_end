#!/bin/sh

# تنظيف الكاش
php artisan config:clear

# حذف كل الجداول وإنشاءها من جديد
php artisan migrate:fresh --force

# تثبيت Passport (ينشئ المفاتيح وجداول OAuth)
php artisan passport:install --force

# ملء قاعدة البيانات بالسيدرز
php artisan db:seed --force

# تشغيل السيرفر أو العملية المطلوبة
exec "$@"
