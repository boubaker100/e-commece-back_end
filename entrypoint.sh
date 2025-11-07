#!/bin/sh
set -e

echo "🚀 Starting Laravel initialization..."

cd /var/www/html

# 1️⃣ توليد مفتاح التطبيق إذا لم يكن موجودًا
if [ -z "$APP_KEY" ]; then
  echo "🔑 Generating APP_KEY..."
  php artisan key:generate --force
else
  echo "✅ APP_KEY already exists, skipping."
fi

# 2️⃣ تشغيل المايغريشن والسييد فقط إذا لم تكن الجداول موجودة
if ! php artisan migrate:status | grep -q "Yes"; then
  echo "📦 Running migrations and seeders..."
  php artisan migrate --force --seed
else
  echo "✅ Database tables already exist, skipping migrations."
fi

# 3️⃣ تثبيت Laravel Passport فقط إذا لم تكن المفاتيح موجودة
if [ ! -f "storage/oauth-private.key" ]; then
  echo "🔐 Installing Laravel Passport..."
  php artisan passport:install --force || true
else
  echo "✅ Passport keys already exist, skipping."
fi

# 4️⃣ ضبط صلاحيات المجلدات
echo "🔧 Fixing permissions..."
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# 5️⃣ تنظيف الكاش وإعادة بنائه
echo "🧹 Clearing and rebuilding caches..."
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# 6️⃣ تشغيل Laravel
echo "🌍 Starting Laravel server on port ${PORT:-8000}..."
exec php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
