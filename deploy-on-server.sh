#!/bin/bash

# سكريبت سحب المشروع من GitHub - للتشغيل مباشرة على السيرفر
# نسخ هذا الملف إلى السيرفر وتشغيله

set -e

DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"
REPO="https://github.com/husamgggggg/trendyol1.git"
NGINX_CONFIG="/etc/nginx/sites-available/${DOMAIN}"

echo "📥 سحب المشروع من GitHub..."

# تثبيت Git إذا لم يكن موجوداً
if ! command -v git &> /dev/null; then
    echo "📦 تثبيت Git..."
    apt-get update && apt-get install -y git
fi

# تنظيف المجلد
echo "🧹 تنظيف المجلد..."
rm -rf ${REMOTE_DIR}/* ${REMOTE_DIR}/.* 2>/dev/null || true
mkdir -p ${REMOTE_DIR}

# سحب المشروع
echo "📥 استنساخ المشروع من GitHub..."
cd ${REMOTE_DIR}
git clone ${REPO} .

# نسخ index.html
if [ -f "android-svg-code-render-master/index-50.html" ]; then
    cp android-svg-code-render-master/index-50.html index.html
    echo "✅ تم نسخ index.html"
fi

# إعطاء الصلاحيات
chown -R www-data:www-data ${REMOTE_DIR}
chmod -R 755 ${REMOTE_DIR}

# إعداد Nginx إذا لم يكن موجوداً
if [ ! -f "${NGINX_CONFIG}" ]; then
    echo "⚙️  إنشاء إعدادات Nginx..."
    cat > ${NGINX_CONFIG} << EOF
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};
    
    root ${REMOTE_DIR};
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    location /sw.js {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }
    
    access_log /var/log/nginx/${DOMAIN}.access.log;
    error_log /var/log/nginx/${DOMAIN}.error.log;
}
EOF
    ln -sf ${NGINX_CONFIG} /etc/nginx/sites-enabled/${DOMAIN}
    nginx -t && systemctl reload nginx
fi

echo "✅ تم سحب المشروع بنجاح!"
echo "🌐 الموقع متاح على: http://${DOMAIN}"

