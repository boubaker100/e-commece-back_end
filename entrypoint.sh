#!/bin/sh

# انتظر قاعدة البيانات حتى تصبح جاهزة
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "⏳ في انتظار قاعدة البيانات على $DB_HOST:$DB_PORT ..."
  sleep 2
done

echo "✅ قاعدة البيانات جاهزة، جاري تنفيذ التهيئة..."

# تنفيذ المهاجرات والسييد
php artisan migrate --seed --force

# تشغيل Apache
apache2-foreground
