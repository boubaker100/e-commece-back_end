#!/bin/sh

# الانتقال إلى دليل المشروع
cd /var/www

# --- تهيئة ملف .env ---
# إذا لم يكن ملف .env موجودًا، أنشئه من .env.example
if [ ! -f .env ]; then
  cp .env.example .env
fi

# --- مسح الكاش وإعادة تهيئة إعدادات Laravel ---
# هذا يضمن قراءة متغيرات البيئة الجديدة من ملف .env أو من Render
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# --- إنشاء مفتاح التطبيق APP_KEY إذا لم يكن موجودًا ---
# التحقق مما إذا كان APP_KEY موجودًا في ملف .env
if ! grep -q "APP_KEY=" .env || grep -q "APP_KEY=$" .env; then
  echo "APP_KEY غير موجود أو فارغ، يتم إنشاؤه..."
  php artisan key:generate --force
else
  echo "APP_KEY موجود بالفعل."
fi

# --- ترحيل قاعدة البيانات (Migrations) ---
# إعادة إنشاء الجداول من جديد دون حذف ملفات Passport Migrations
# (قد تحتاج لإزالة --no-interaction إذا كنت تريد تأكيدات يدوية)
echo "بدء ترحيل قاعدة البيانات..."
php artisan migrate:fresh --force --no-interaction

# --- تثبيت Passport ---
# تثبيت Passport (بدون طلب تأكيد)
echo "تثبيت Laravel Passport..."
php artisan passport:install --force --no-interaction

# --- تشغيل Seeder ---
# ملء قاعدة البيانات بالبيانات الأولية
echo "تشغيل Seeder لملء قاعدة البيانات..."
php artisan db:seed --force --no-interaction

# --- تشغيل السيرفر ---
# تشغيل خادم Laravel المدمج على جميع الواجهات والمنفذ 8000
echo "تشغيل خادم Laravel..."
php artisan serve --host=0.0.0.0 --port=8000