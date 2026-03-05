#!/bin/bash

# سكريبت إصلاح مشكلة Nginx والمنفذ 80
# للتشغيل على السيرفر مباشرة

set -e

echo "🔍 التحقق من المنفذ 80..."

# التحقق من ما يستخدم المنفذ 80
PORT_80=$(lsof -i :80 2>/dev/null | grep LISTEN || netstat -tuln | grep :80 || ss -tuln | grep :80 || echo "")

if [ -n "$PORT_80" ]; then
    echo "⚠️  المنفذ 80 مستخدم:"
    echo "$PORT_80"
    echo ""
    echo "🔍 البحث عن العملية..."
    
    # محاولة إيجاد العملية
    PID=$(lsof -ti :80 2>/dev/null || fuser 80/tcp 2>/dev/null | awk '{print $1}' || echo "")
    
    if [ -n "$PID" ]; then
        echo "📋 PID العملية: $PID"
        echo "📝 معلومات العملية:"
        ps aux | grep $PID | grep -v grep || echo "لا توجد معلومات"
        
        # التحقق إذا كانت Apache
        if ps aux | grep -i apache | grep -v grep; then
            echo ""
            echo "🔧 Apache يعمل - سيتم إيقافه..."
            systemctl stop apache2 2>/dev/null || service apache2 stop 2>/dev/null || killall apache2 2>/dev/null || true
        fi
        
        # التحقق إذا كانت خدمة أخرى
        SERVICE=$(systemctl list-units --type=service --state=running | grep -E "http|web|nginx" | head -1 | awk '{print $1}' || echo "")
        if [ -n "$SERVICE" ] && [ "$SERVICE" != "nginx.service" ]; then
            echo "🔧 إيقاف الخدمة: $SERVICE"
            systemctl stop $SERVICE 2>/dev/null || true
        fi
    fi
fi

# محاولة بدء Nginx
echo ""
echo "🚀 محاولة بدء Nginx..."
systemctl start nginx 2>/dev/null || {
    echo "⚠️  فشل بدء Nginx - التحقق من الأخطاء..."
    nginx -t
    systemctl status nginx
}

# التحقق من حالة Nginx
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx يعمل الآن!"
    systemctl status nginx --no-pager
else
    echo "❌ Nginx لا يزال متوقفاً"
    echo "📋 محاولة إعادة التشغيل..."
    systemctl restart nginx
fi

