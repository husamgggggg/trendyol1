#!/bin/bash

# سكريبت تنظيف السيرفر وحذف الملفات القديمة
# استخدام: ./clean-server.sh

set -e

echo "🧹 بدء تنظيف السيرفر..."

# متغيرات
SERVER="root@187.124.28.173"
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"
NGINX_CONFIG="/etc/nginx/sites-available/${DOMAIN}"
NGINX_ENABLED="/etc/nginx/sites-enabled/${DOMAIN}"

# التحذير
echo "⚠️  تحذير: سيتم حذف جميع الملفات في ${REMOTE_DIR}"
echo "⚠️  سيتم حذف:"
echo "   - جميع الملفات في ${REMOTE_DIR}"
echo "   - إعدادات Nginx القديمة"
echo "   - ملفات Log القديمة"
echo ""
echo "هل تريد المتابعة؟ (سيتم المتابعة تلقائياً بعد 5 ثواني)"
echo "اضغط Ctrl+C لإلغاء العملية..."

# انتظار 5 ثواني للسماح بالإلغاء
sleep 5

# حذف محتويات مجلد الموقع
echo "🗑️  حذف محتويات مجلد الموقع..."
ssh ${SERVER} "rm -rf ${REMOTE_DIR}/* ${REMOTE_DIR}/.* 2>/dev/null || true"
ssh ${SERVER} "mkdir -p ${REMOTE_DIR}"

# حذف إعدادات Nginx القديمة (إن وجدت)
echo "🗑️  حذف إعدادات Nginx القديمة..."
ssh ${SERVER} "rm -f ${NGINX_CONFIG} ${NGINX_ENABLED} 2>/dev/null || true"

# إيقاف Nginx مؤقتاً إذا كان يعمل
echo "⏸️  التحقق من حالة Nginx..."
ssh ${SERVER} "sudo systemctl stop nginx 2>/dev/null || true"

# تنظيف ملفات Log القديمة
echo "🧹 تنظيف ملفات Log..."
ssh ${SERVER} "sudo rm -f /var/log/nginx/${DOMAIN}.*.log 2>/dev/null || true"

# إنشاء مجلد الموقع من جديد
echo "📁 إنشاء مجلد الموقع من جديد..."
ssh ${SERVER} "mkdir -p ${REMOTE_DIR}"
ssh ${SERVER} "chown -R www-data:www-data ${REMOTE_DIR}"
ssh ${SERVER} "chmod -R 755 ${REMOTE_DIR}"

echo "✅ تم تنظيف السيرفر بنجاح!"
echo "📝 السيرفر جاهز الآن للنشر الجديد"

