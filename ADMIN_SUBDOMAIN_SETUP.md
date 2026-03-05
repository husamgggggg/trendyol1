# 🔐 إعداد Subdomain للوحة الأدمن

## الهدف
إنشاء رابط `admin.trendyol-invest.com` للدخول إلى لوحة الأدمن مباشرة.

---

## الخطوات المطلوبة

### 1️⃣ إعداد DNS

في لوحة تحكم الدومين، أضف سجل DNS جديد:

**نوع السجل**: `A Record`  
**الاسم**: `admin`  
**القيمة**: `187.124.28.173`  
**TTL**: `3600` (أو الافتراضي)

انتظر حتى يتم نشر DNS (قد يستغرق بضع دقائق إلى ساعات).

---

### 2️⃣ إعداد Nginx على السيرفر

انسخ والصق هذا الأمر على السيرفر:

```bash
DOMAIN="trendyol-invest.com"
ADMIN_DOMAIN="admin.${DOMAIN}"
NGINX_CONFIG="/etc/nginx/sites-available/${ADMIN_DOMAIN}"

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
```

---

### 3️⃣ الحصول على شهادة SSL

بعد إعداد DNS وNginx:

```bash
certbot --nginx -d admin.trendyol-invest.com
```

---

### 4️⃣ تحديث الملف على السيرفر

بعد رفع التحديثات على GitHub:

```bash
cd /var/www/trendyol-invest.com
git pull origin main
cp android-svg-code-render-master/index-50.html index.html
systemctl reload nginx
```

---

## بعد الإعداد

### الدخول إلى لوحة الأدمن:

افتح المتصفح وانتقل إلى:

```
https://admin.trendyol-invest.com
```

سيتم فتح صفحة تسجيل دخول الأدمن تلقائياً.

---

## التحقق من DNS

قبل إعداد Nginx، تحقق من أن DNS يعمل:

```bash
nslookup admin.trendyol-invest.com
```

أو:

```bash
ping admin.trendyol-invest.com
```

يجب أن ترى عنوان IP: `187.124.28.173`

---

## ملاحظات

- ✅ Subdomain أكثر أماناً من query parameter
- ✅ يمكن إخفاء رابط الأدمن عن المستخدمين العاديين
- ✅ يمكن إضافة حماية إضافية (مثل IP whitelist) لاحقاً

---

## إضافة حماية IP (اختياري)

لزيادة الأمان، يمكنك تقييد الوصول لعناوين IP محددة:

```nginx
server {
    listen 443 ssl http2;
    server_name admin.trendyol-invest.com;
    
    # السماح فقط بعناوين IP محددة
    allow 123.456.789.0;  # استبدل بعنوان IP الخاص بك
    deny all;
    
    # باقي الإعدادات...
}
```

---

**بعد إعداد DNS وNginx، الرابط سيكون:**
```
https://admin.trendyol-invest.com
```

