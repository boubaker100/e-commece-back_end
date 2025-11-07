#!/bin/sh
cd /var/www/html
set -e

echo "🚀 [1/6] Starting deployment entrypoint..."

# إنشاء المجلدات المهمة
echo "📁 [2/6] Creating storage folders..."
mkdir -p storage/framework/sessions \
         storage/framework/views \
         storage/framework/cache \
         bootstrap/cache

# صلاحيات الكتابة
echo "🔒 [3/6] Setting permissions..."
chmod -R 775 storage bootstrap/cache

# تنظيف الكاش
echo "🧹 [4/6] Clearing caches..."
php artisan config:clear || echo "⚠️ config:clear failed"
php artisan cache:clear || echo "⚠️ cache:clear failed"
php artisan route:clear || echo "⚠️ route:clear failed"
php artisan view:clear || echo "⚠️ view:clear failed"

# إعادة بناء الكاش
echo "⚙️ [5/6] Rebuilding caches..."
php artisan config:cache || echo "⚠️ config:cache failed"
php artisan route:cache || echo "⚠️ route:cache failed"
php artisan view:cache || echo "⚠️ view:cache failed"

# ✅ لا نعيد إنشاء الجداول أو المفاتيح
echo "✅ [6/6] Skipping migrations and passport key generation"

echo "🚀 Starting Laravel server..."
exec php artisan serve --host=0.0.0.0 --port=8000
