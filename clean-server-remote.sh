#!/bin/bash

# سكريبت تنظيف السيرفر - للتشغيل مباشرة على السيرفر
# نسخ هذا الملف إلى السيرفر وتشغيله

set -e

DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"
NGINX_CONFIG="/etc/nginx/sites-available/${DOMAIN}"
NGINX_ENABLED="/etc/nginx/sites-enabled/${DOMAIN}"

echo "🧹 بدء تنظيف السيرفر..."
echo "⚠️  سيتم حذف جميع الملفات في ${REMOTE_DIR}"

# حذف محتويات مجلد الموقع
echo "🗑️  حذف محتويات مجلد الموقع..."
rm -rf ${REMOTE_DIR}/* ${REMOTE_DIR}/.* 2>/dev/null || true
mkdir -p ${REMOTE_DIR}

# حذف إعدادات Nginx القديمة (إن وجدت)
echo "🗑️  حذف إعدادات Nginx القديمة..."
rm -f ${NGINX_CONFIG} ${NGINX_ENABLED} 2>/dev/null || true

# إيقاف Nginx مؤقتاً إذا كان يعمل
echo "⏸️  إيقاف Nginx..."
systemctl stop nginx 2>/dev/null || true

# تنظيف ملفات Log القديمة
echo "🧹 تنظيف ملفات Log..."
rm -f /var/log/nginx/${DOMAIN}.*.log 2>/dev/null || true

# إنشاء مجلد الموقع من جديد
echo "📁 إنشاء مجلد الموقع من جديد..."
mkdir -p ${REMOTE_DIR}
chown -R www-data:www-data ${REMOTE_DIR}
chmod -R 755 ${REMOTE_DIR}

echo "✅ تم تنظيف السيرفر بنجاح!"
echo "📝 السيرفر جاهز الآن للنشر الجديد"

