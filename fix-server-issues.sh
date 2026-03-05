#!/bin/bash

# سكريبت إصلاح المشاكل على السيرفر
# للتشغيل على السيرفر مباشرة

set -e

DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"

echo "🔧 إصلاح المشاكل..."

# إصلاح Git ownership
echo "🔧 إصلاح Git ownership..."
git config --global --add safe.directory ${REMOTE_DIR}

# الانتقال إلى المجلد
cd ${REMOTE_DIR}

# سحب التحديثات
echo "📥 سحب التحديثات من GitHub..."
git pull origin main

# نسخ index.html
echo "📝 نسخ index.html..."
cp android-svg-code-render-master/index-50.html index.html

# إنشاء manifest.json
echo "📝 إنشاء manifest.json..."
cat > manifest.json << 'EOF'
{
  "name": "ترنديول - منصة الاستثمار",
  "short_name": "Trendyol",
  "description": "منصة ترنديول للاستثمار",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0a1628",
  "theme_color": "#0d1e38",
  "orientation": "portrait-primary",
  "icons": [
    {
      "src": "icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    }
  ]
}
EOF

# إنشاء sw.js
echo "📝 إنشاء sw.js..."
cat > sw.js << 'EOF'
const CACHE_NAME = 'trendyol-v1';
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache) {
      return cache.addAll(['/', '/index.html']);
    })
  );
});
self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request).then(function(response) {
      return response || fetch(event.request);
    })
  );
});
EOF

# إعطاء الصلاحيات
echo "🔐 إعطاء الصلاحيات..."
chown -R www-data:www-data ${REMOTE_DIR}
chmod -R 755 ${REMOTE_DIR}

# التحقق من Nginx
echo "🌐 التحقق من Nginx..."
if systemctl is-active --quiet nginx; then
    systemctl reload nginx
    echo "✅ Nginx تم إعادة تحميله"
elif command -v nginx &> /dev/null; then
    systemctl start nginx
    echo "✅ Nginx تم تشغيله"
else
    echo "⚠️  Nginx غير مثبت - سيتم تثبيته..."
    apt-get update && apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "✅ Nginx تم تثبيته وتشغيله"
fi

echo "✅ تم الإصلاح بنجاح!"

