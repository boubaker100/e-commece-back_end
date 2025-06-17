#!/bin/sh

# انتظر قاعدة البيانات حتى تصبح جاهزة
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "⏳ في انتظار قاعدة البيانات على $DB_HOST:$DB_PORT ..."
  sleep 2
done
# عمل الترحيلات
php artisan migrate --force

echo "✅ قاعدة البيانات جاهزة، جاري تشغيل الخادم..."

# ✅ لا يوجد تهجير، فقط تشغيل الخادم
apache2-foreground
