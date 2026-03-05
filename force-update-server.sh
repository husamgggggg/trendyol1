#!/bin/bash

# سكريبت إجبار تحديث الملفات على السيرفر
# استخدام: ./force-update-server.sh

set -e

SERVER="root@187.124.28.173"
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"

echo "🔄 إجبار تحديث الملفات على السيرفر..."

# نسخ index.html
echo "📤 نسخ index.html..."
scp android-svg-code-render-master/index-50.html ${SERVER}:${REMOTE_DIR}/index.html

# نسخ manifest.json
if [ -f "manifest.json" ]; then
    echo "📤 نسخ manifest.json..."
    scp manifest.json ${SERVER}:${REMOTE_DIR}/manifest.json
else
    echo "⚠️  manifest.json غير موجود محلياً"
fi

# نسخ sw.js
if [ -f "sw.js" ]; then
    echo "📤 نسخ sw.js..."
    scp sw.js ${SERVER}:${REMOTE_DIR}/sw.js
else
    echo "⚠️  sw.js غير موجود محلياً"
fi

# نسخ icon-192.png إن كان موجوداً
if [ -f "icon-192.png" ]; then
    echo "📤 نسخ icon-192.png..."
    scp icon-192.png ${SERVER}:${REMOTE_DIR}/icon-192.png
else
    echo "⚠️  icon-192.png غير موجود محلياً"
    echo "💡 يمكنك إنشاء أيقونة 192x192 بكسل وحفظها كـ icon-192.png"
fi

# إعطاء الصلاحيات الصحيحة
echo "🔐 إعطاء الصلاحيات..."
ssh ${SERVER} "chown -R www-data:www-data ${REMOTE_DIR} && chmod -R 755 ${REMOTE_DIR}"

# مسح الكاش
echo "🧹 مسح الكاش..."
ssh ${SERVER} "systemctl reload nginx"

echo "✅ تم التحديث بنجاح!"
echo "🌐 الموقع: https://${DOMAIN}"

