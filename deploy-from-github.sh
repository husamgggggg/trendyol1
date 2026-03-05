#!/bin/bash

# سكريبت سحب المشروع من GitHub إلى السيرفر
# استخدام: ./deploy-from-github.sh

set -e

SERVER="root@187.124.28.173"
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"
REPO="https://github.com/husamgggggg/trendyol1.git"
NGINX_CONFIG="/etc/nginx/sites-available/${DOMAIN}"

echo "📥 سحب المشروع من GitHub إلى السيرفر..."

# التحقق من وجود Git على السيرفر
echo "🔍 التحقق من Git على السيرفر..."
ssh ${SERVER} "which git || apt-get update && apt-get install -y git"

# إنشاء مجلد الموقع إذا لم يكن موجوداً
echo "📁 إنشاء مجلد الموقع..."
ssh ${SERVER} "mkdir -p ${REMOTE_DIR}"

# سحب المشروع
echo "📥 سحب المشروع من GitHub..."
ssh ${SERVER} << EOF
    cd ${REMOTE_DIR}
    
    # إذا كان المجلد فارغاً أو ليس git repo
    if [ ! -d ".git" ]; then
        echo "🔧 استنساخ المشروع..."
        rm -rf * .* 2>/dev/null || true
        git clone ${REPO} .
    else
        echo "🔄 تحديث المشروع..."
        git fetch origin
        git reset --hard origin/main
        git pull origin main
    fi
    
    # نسخ index-50.html إلى index.html
    if [ -f "android-svg-code-render-master/index-50.html" ]; then
        cp android-svg-code-render-master/index-50.html index.html
        echo "✅ تم نسخ index.html"
    fi
    
    # إعطاء الصلاحيات الصحيحة
    chown -R www-data:www-data ${REMOTE_DIR}
    chmod -R 755 ${REMOTE_DIR}
EOF

# إعداد Nginx إذا لم يكن موجوداً
echo "⚙️  التحقق من إعدادات Nginx..."
ssh ${SERVER} << EOF
    if [ ! -f "${NGINX_CONFIG}" ]; then
        echo "📝 إنشاء إعدادات Nginx..."
        cat > /tmp/nginx-config << NGINX_EOF
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};
    
    root ${REMOTE_DIR};
    index index.html;
    
    location / {
        try_files \\\$uri \\\$uri/ /index.html;
    }
    
    location ~* \\.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    location /sw.js {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }
    
    access_log /var/log/nginx/${DOMAIN}.access.log;
    error_log /var/log/nginx/${DOMAIN}.error.log;
}
NGINX_EOF
        sudo mv /tmp/nginx-config ${NGINX_CONFIG}
        sudo ln -sf ${NGINX_CONFIG} /etc/nginx/sites-enabled/${DOMAIN}
        sudo nginx -t && sudo systemctl reload nginx
    fi
EOF

echo "✅ تم سحب المشروع بنجاح!"
echo "🌐 الموقع متاح على: http://${DOMAIN}"

