#!/bin/bash

# سكريبت التحقق من النشر
# استخدام: ./verify-deployment.sh

set -e

SERVER="root@187.124.28.173"
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"

echo "🔍 التحقق من النشر..."

# التحقق من وجود الملفات على السيرفر
echo "📁 التحقق من الملفات..."
ssh ${SERVER} << EOF
    if [ -f "${REMOTE_DIR}/index.html" ]; then
        echo "✅ index.html موجود"
    else
        echo "❌ index.html غير موجود"
        exit 1
    fi
    
    if [ -f "${REMOTE_DIR}/manifest.json" ]; then
        echo "✅ manifest.json موجود"
    else
        echo "⚠️  manifest.json غير موجود"
    fi
    
    if [ -d "${REMOTE_DIR}/.git" ]; then
        echo "✅ Git repository موجود"
    else
        echo "⚠️  Git repository غير موجود"
    fi
EOF

# التحقق من Nginx
echo "🌐 التحقق من Nginx..."
ssh ${SERVER} "systemctl is-active nginx > /dev/null && echo '✅ Nginx يعمل' || echo '❌ Nginx متوقف'"

# التحقق من SSL
echo "🔒 التحقق من SSL..."
if curl -s -o /dev/null -w "%{http_code}" https://${DOMAIN} | grep -q "200\|301\|302"; then
    echo "✅ HTTPS يعمل"
else
    echo "⚠️  HTTPS قد لا يعمل بعد"
fi

# التحقق من HTTP
echo "🌍 التحقق من HTTP..."
if curl -s -o /dev/null -w "%{http_code}" http://${DOMAIN} | grep -q "200\|301\|302"; then
    echo "✅ HTTP يعمل"
else
    echo "⚠️  HTTP قد لا يعمل بعد"
fi

echo ""
echo "✅ تم التحقق!"
echo "🌐 الموقع: https://${DOMAIN}"

