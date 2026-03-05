#!/bin/bash

# سكريبت تحديث الملف مع إصلاح الجلسة
# استخدام: ./update-session-fix.sh

set -e

SERVER="root@187.124.28.173"
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"

echo "🔄 تحديث الملف مع إصلاح الجلسة..."

# نسخ الملف المحدث
scp android-svg-code-render-master/index-50.html ${SERVER}:${REMOTE_DIR}/index.html

# إعطاء الصلاحيات
ssh ${SERVER} "chown -R www-data:www-data ${REMOTE_DIR} && chmod -R 755 ${REMOTE_DIR}"

# إعادة تحميل Nginx
ssh ${SERVER} "systemctl reload nginx"

echo "✅ تم التحديث!"
echo "🌐 الموقع: https://${DOMAIN}"
echo "💡 الآن المستخدمون سيظلون مسجلين حتى بعد تحديث الصفحة!"

