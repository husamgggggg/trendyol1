#!/bin/bash

# سكريبت النشر على السيرفر
# استخدام: ./deploy.sh

set -e

echo "🚀 بدء عملية النشر..."

# متغيرات
SERVER="root@187.124.28.173"
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"
NGINX_CONFIG="/etc/nginx/sites-available/${DOMAIN}"

# إنشاء مجلد الموقع على السيرفر
echo "📁 إنشاء المجلدات..."
ssh ${SERVER} "mkdir -p ${REMOTE_DIR}"

# نسخ الملفات
echo "📤 نسخ الملفات إلى السيرفر..."
scp android-svg-code-render-master/index-50.html ${SERVER}:${REMOTE_DIR}/index.html
scp manifest.json ${SERVER}:${REMOTE_DIR}/manifest.json 2>/dev/null || echo "⚠️  manifest.json غير موجود"
scp sw.js ${SERVER}:${REMOTE_DIR}/sw.js 2>/dev/null || echo "⚠️  sw.js غير موجود"

# نسخ أيقونات إذا كانت موجودة
if [ -f "icon-192.png" ]; then
    scp icon-192.png ${SERVER}:${REMOTE_DIR}/icon-192.png
fi

# نسخ ملف nginx config
echo "⚙️  إعداد Nginx..."
scp nginx-trendyol.conf ${SERVER}:/tmp/nginx-${DOMAIN}.conf
ssh ${SERVER} "sudo mv /tmp/nginx-${DOMAIN}.conf ${NGINX_CONFIG}"
ssh ${SERVER} "sudo ln -sf ${NGINX_CONFIG} /etc/nginx/sites-enabled/${DOMAIN}"

# اختبار تكوين Nginx
echo "🔍 اختبار تكوين Nginx..."
ssh ${SERVER} "sudo nginx -t"

# إعادة تحميل Nginx
echo "🔄 إعادة تحميل Nginx..."
ssh ${SERVER} "sudo systemctl reload nginx"

echo "✅ تم النشر بنجاح!"
echo "🌐 الموقع متاح على: https://${DOMAIN}"

