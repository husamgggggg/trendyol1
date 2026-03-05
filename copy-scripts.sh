#!/bin/bash

# سكريبت نسخ جميع السكريبتات إلى السيرفر
# استخدام: ./copy-scripts.sh

set -e

SERVER="root@187.124.28.173"

echo "📤 نسخ السكريبتات إلى السيرفر..."

# نسخ جميع السكريبتات
scp clean-server-remote.sh ${SERVER}:/root/clean-server.sh
scp setup-server.sh ${SERVER}:/root/
scp deploy.sh ${SERVER}:/root/ 2>/dev/null || echo "⚠️  deploy.sh غير موجود (سيتم إنشاؤه لاحقاً)"

# إعطاء صلاحيات التنفيذ
echo "🔐 إعطاء صلاحيات التنفيذ..."
ssh ${SERVER} "chmod +x /root/clean-server.sh /root/setup-server.sh"

echo "✅ تم نسخ السكريبتات بنجاح!"
echo ""
echo "الآن يمكنك الاتصال بالسيرفر وتشغيل:"
echo "  ssh root@187.124.28.173"
echo "  ./clean-server.sh"

