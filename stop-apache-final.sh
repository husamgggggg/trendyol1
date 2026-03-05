#!/bin/bash

# سكريبت إيقاف Apache نهائياً - للتشغيل على السيرفر

set -e

echo "🛑 إيقاف Apache نهائياً..."

# إيقاف Apache
systemctl stop apache2 2>/dev/null || service apache2 stop 2>/dev/null || true

# تعطيل Apache من البدء التلقائي
systemctl disable apache2 2>/dev/null || true

# التحقق من أن Nginx يعمل
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx يعمل"
else
    echo "🚀 بدء Nginx..."
    systemctl start nginx
    systemctl enable nginx
fi

# التحقق من المنفذ 80
echo "🔍 التحقق من المنفذ 80..."
sleep 2
lsof -i :80 2>/dev/null || netstat -tuln | grep :80 || ss -tuln | grep :80

echo "✅ تم!"

