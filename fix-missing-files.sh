#!/bin/bash

# سكريبت إصلاح الملفات المفقودة
# للتشغيل على السيرفر

set -e

DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"

echo "🔧 إصلاح الملفات المفقودة..."

cd ${REMOTE_DIR}

# إنشاء icon-192.png بسيط (أو نسخه من المشروع)
if [ ! -f "icon-192.png" ]; then
    echo "📝 إنشاء icon-192.png..."
    # يمكنك استخدام ImageMagick لإنشاء أيقونة بسيطة
    if command -v convert &> /dev/null; then
        convert -size 192x192 xc:"#d4a94a" -gravity center -pointsize 72 -fill "#0a1628" -annotate +0+0 "T" icon-192.png
    else
        echo "⚠️  ImageMagick غير مثبت - يمكنك نسخ icon-192.png يدوياً"
        echo "💡 أو استخدم أي صورة 192x192 بكسل"
    fi
fi

# إزالة سكريبت Cloudflare من index.html (إن لم يكن موجوداً)
if grep -q "email-decode.min.js" index.html; then
    echo "🔧 إزالة سكريبت Cloudflare غير الموجود..."
    sed -i '/email-decode.min.js/d' index.html
    echo "✅ تم إزالة السكريبت"
fi

# إعطاء الصلاحيات
chown -R www-data:www-data ${REMOTE_DIR}
chmod -R 755 ${REMOTE_DIR}

# إعادة تحميل Nginx
systemctl reload nginx

echo "✅ تم!"

