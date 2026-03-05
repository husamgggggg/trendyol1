#!/bin/bash

# سكريبت تحديث مباشر على السيرفر
# للتشغيل على السيرفر مباشرة

set -e

DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"
REPO="https://github.com/husamgggggg/trendyol1.git"

echo "🔄 تحديث الملفات من GitHub..."

# الانتقال إلى مجلد الموقع
cd ${REMOTE_DIR}

# سحب التحديثات من GitHub
if [ -d ".git" ]; then
    echo "📥 سحب التحديثات..."
    git fetch origin
    git reset --hard origin/main
    git pull origin main
else
    echo "📥 استنساخ المشروع..."
    rm -rf * .* 2>/dev/null || true
    git clone ${REPO} .
fi

# نسخ index.html
if [ -f "android-svg-code-render-master/index-50.html" ]; then
    cp android-svg-code-render-master/index-50.html index.html
    echo "✅ تم نسخ index.html"
fi

# إعطاء الصلاحيات
chown -R www-data:www-data ${REMOTE_DIR}
chmod -R 755 ${REMOTE_DIR}

# إعادة تحميل Nginx
systemctl reload nginx

echo "✅ تم التحديث بنجاح!"

