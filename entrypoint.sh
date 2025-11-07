#!/bin/bash
set -e

cd /var/www/html

echo "🚀 Starting Laravel server..."

# تنظيف الكاش
php artisan config:clear || echo "⚠️ config:clear failed"
php artisan cache:clear || echo "⚠️ cache:clear failed"
php artisan route:clear || echo "⚠️ route:clear failed"
php artisan view:clear || echo "⚠️ view:clear failed"

# إعادة بناء الكاش
php artisan config:cache || echo "⚠️ config:cache failed"
php artisan route:cache || echo "⚠️ route:cache failed"
php artisan view:cache || echo "⚠️ view:cache failed"

# تشغيل Laravel
exec php artisan serve --host=0.0.0.0 --port $PORT
