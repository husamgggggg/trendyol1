#!/bin/bash

# سكريبت إعداد subdomain للأدمن على Hostinger
# للتشغيل على السيرفر

set -e

DOMAIN="trendyol-invest.com"
ADMIN_SUBDOMAIN="admin"  # يمكن تغييره إلى أي subdomain آخر
ADMIN_DOMAIN="${ADMIN_SUBDOMAIN}.${DOMAIN}"
NGINX_CONFIG="/etc/nginx/sites-available/${ADMIN_DOMAIN}"

echo "🔧 إعداد subdomain للأدمن: ${ADMIN_DOMAIN}"

# إنشاء ملف إعدادات Nginx
cat > ${NGINX_CONFIG} << EOF
server {
    listen 80;
    server_name ${ADMIN_DOMAIN};
    
    root /var/www/${DOMAIN};
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
    
    access_log /var/log/nginx/${ADMIN_DOMAIN}.access.log;
    error_log /var/log/nginx/${ADMIN_DOMAIN}.error.log;
}
EOF

# تفعيل الموقع
ln -sf ${NGINX_CONFIG} /etc/nginx/sites-enabled/${ADMIN_DOMAIN}

# اختبار تكوين Nginx
nginx -t

# إعادة تحميل Nginx
systemctl reload nginx

echo "✅ تم الإعداد!"
echo "🌐 لوحة الأدمن متاحة الآن على:"
echo "   http://${ADMIN_DOMAIN}"

