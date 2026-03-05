# إصلاح الملفات المفقودة

## المشاكل المكتشفة:
1. ❌ `icon-192.png` مفقود (404)
2. ❌ `manifest.json` مفقود (404)
3. ❌ خطأ JavaScript: `go is not defined`
4. ⚠️ الملفات القديمة ما زالت مستخدمة

---

## الحل السريع:

### الطريقة 1: من جهازك المحلي
```bash
./force-update-server.sh
```

### الطريقة 2: على السيرفر مباشرة
انسخ والصق هذا على السيرفر:

```bash
cd /var/www/trendyol-invest.com

# سحب التحديثات من GitHub
git pull origin main

# نسخ index.html
cp android-svg-code-render-master/index-50.html index.html

# التحقق من وجود manifest.json
if [ ! -f "manifest.json" ]; then
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
fi

# التحقق من وجود sw.js
if [ ! -f "sw.js" ]; then
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
fi

# إعطاء الصلاحيات
chown -R www-data:www-data /var/www/trendyol-invest.com
chmod -R 755 /var/www/trendyol-invest.com

# إعادة تحميل Nginx
systemctl reload nginx

echo "✅ تم!"
```

---

## إنشاء icon-192.png

إذا كان `icon-192.png` مفقوداً، يمكنك:

1. **إنشاء أيقونة 192x192 بكسل** وحفظها كـ `icon-192.png`
2. **نسخها إلى السيرفر**:
   ```bash
   scp icon-192.png root@187.124.28.173:/var/www/trendyol-invest.com/
   ```

أو **استخدام أيقونة مؤقتة**:
```bash
ssh root@187.124.28.173
cd /var/www/trendyol-invest.com
# يمكنك استخدام أي صورة موجودة أو إنشاء واحدة بسيطة
```

---

## التحقق من الإصلاح

بعد الإصلاح، افتح المتصفح وتحقق من:
- ✅ لا توجد أخطاء 404 في Console
- ✅ `manifest.json` يعمل
- ✅ `icon-192.png` موجود
- ✅ JavaScript يعمل (لا توجد أخطاء `go is not defined`)

---

## إصلاح خطأ JavaScript

إذا كان خطأ `go is not defined` ما زال موجوداً، تحقق من:
1. ملف `index.html` يحتوي على جميع دوال JavaScript
2. لا توجد أخطاء syntax في الكود
3. جميع الملفات تم نسخها بشكل صحيح

