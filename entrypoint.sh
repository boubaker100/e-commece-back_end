#!/bin/sh

echo "🚀 بدء تهيئة Laravel..."

# حل مشكلة المسار في بيئة Docker
export APP_STORAGE_PATH=/var/www/html/storage

# إنشاء المجلدات الأساسية
mkdir -p $APP_STORAGE_PATH/framework/{sessions,views,cache}
mkdir -p bootstrap/cache

# إنشاء مجلدات Laravel المهمة
mkdir -p storage/framework/{sessions,views,cache} bootstrap/cache

# إعطاء الصلاحيات (تم تحديث الترتيب)
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
chown -R www-data:www-data $APP_STORAGE_PATH bootstrap/cache

# إصلاح الجلسات: تأكد استخدام database driver
php artisan config:set session.driver database --quiet

# مسح الكاش للتأكد من استخدام الإعدادات الحديثة
php artisan config:clear
php artisan cache:clear

# انتظار قاعدة البيانات
echo "⏳ انتظار قاعدة البيانات..."
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "⏳ في انتظار قاعدة البيانات على $DB_HOST:$DB_PORT ..."
  sleep 2
done

echo "✅ قاعدة البيانات متاحة"

# تشغيل التهجيرات
echo "📦 تشغيل التهجيرات..."
php artisan migrate --force

# تحسين الأداء للإنتاج
if [ "$APP_ENV" = "production" ]; then
    echo "⚡ تحسين الأداء للإنتاج..."
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
fi

echo "✅ تم الانتهاء من التهيئة، جاري تشغيل الخادم..."

# تشغيل Apache
exec apache2-foreground