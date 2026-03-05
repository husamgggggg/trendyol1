#!/bin/bash

# سكريبت إعداد السيرفر الكامل
# يجب تشغيله على السيرفر مباشرة

set -e

DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"

echo "🔧 بدء إعداد السيرفر..."

# تحديث النظام
echo "📦 تحديث النظام..."
apt-get update
apt-get upgrade -y

# تثبيت Nginx
echo "🌐 تثبيت Nginx..."
apt-get install -y nginx

# تثبيت Certbot
echo "🔒 تثبيت Certbot..."
apt-get install -y certbot python3-certbot-nginx

# إنشاء مجلد الموقع
echo "📁 إنشاء مجلد الموقع..."
mkdir -p ${REMOTE_DIR}
chown -R www-data:www-data ${REMOTE_DIR}

# إعداد Nginx (بدون SSL أولاً)
cat > /etc/nginx/sites-available/${DOMAIN} <<EOF
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

# تفعيل الموقع
ln -sf /etc/nginx/sites-available/${DOMAIN} /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# اختبار وتحميل Nginx
nginx -t
systemctl reload nginx

# الحصول على شهادة SSL
echo "🔐 الحصول على شهادة SSL..."
certbot --nginx -d ${DOMAIN} -d www.${DOMAIN} --non-interactive --agree-tos --email admin@${DOMAIN} --redirect

# إعداد تجديد تلقائي للشهادة
echo "⏰ إعداد تجديد تلقائي للشهادة..."
systemctl enable certbot.timer

# إعداد Firewall
echo "🔥 إعداد Firewall..."
if command -v ufw &> /dev/null; then
    ufw allow 'Nginx Full'
    ufw allow ssh
    ufw --force enable
fi

echo "✅ تم إعداد السيرفر بنجاح!"
echo "🌐 الموقع متاح على: http://${DOMAIN}"
echo "🔒 سيتم تفعيل HTTPS بعد الحصول على الشهادة"

