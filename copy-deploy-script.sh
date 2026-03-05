#!/bin/bash

# سكريبت نسخ ملف النشر إلى السيرفر
# استخدام: ./copy-deploy-script.sh

set -e

SERVER="root@187.124.28.173"

echo "📤 نسخ سكريبت النشر إلى السيرفر..."

# نسخ السكريبت
scp deploy-on-server.sh ${SERVER}:/root/deploy-on-server.sh

# إعطاء صلاحيات التنفيذ
ssh ${SERVER} "chmod +x /root/deploy-on-server.sh"

echo "✅ تم النسخ بنجاح!"
echo ""
echo "الآن على السيرفر شغّل:"
echo "  ./deploy-on-server.sh"

