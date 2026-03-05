#!/bin/bash

# سكريبت تحديث سريع للسيرفر
# استخدام: ./quick-update-server.sh

set -e

SERVER="root@187.124.28.173"
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"

echo "🔄 تحديث الملفات على السيرفر..."

# نسخ الملف المحدث مباشرة
scp android-svg-code-render-master/index-50.html ${SERVER}:${REMOTE_DIR}/index.html

# إعطاء الصلاحيات
ssh ${SERVER} "chown -R www-data:www-data ${REMOTE_DIR} && chmod -R 755 ${REMOTE_DIR}"

# إعادة تحميل Nginx
ssh ${SERVER} "systemctl reload nginx"

echo "✅ تم التحديث!"
echo "🌐 الموقع: https://${DOMAIN}"
echo "💡 امسح كاش المتصفح (Ctrl+Shift+Delete) ثم أعد تحميل الصفحة (Ctrl+F5)"

