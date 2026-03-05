# 🔐 إعداد Subdomain للأدمن على Hostinger

## الخطوات المطلوبة

### 1️⃣ إنشاء Subdomain في Hostinger (تم ✅)

إذا لم تكن أنشأته بعد:
1. اذهب إلى Hostinger Panel
2. Websites → trendyol-invest.com → Domains → Subdomains
3. أنشئ subdomain باسم: `admin`
4. Directory: اتركه فارغاً أو ضع `/public_html` (نفس الموقع الرئيسي)

---

### 2️⃣ إعداد Nginx على السيرفر

بعد إنشاء subdomain في Hostinger، شغّل هذا على السيرفر:

```bash
DOMAIN="trendyol-invest.com"
ADMIN_DOMAIN="admin.${DOMAIN}"
NGINX_CONFIG="/etc/nginx/sites-available/${ADMIN_DOMAIN}"

# إنشاء ملف إعدادات Nginx
cat > ${NGINX_CONFIG} << 'EOF'
server {
    listen 80;
    server_name admin.trendyol-invest.com;
    
    root /var/www/trendyol-invest.com;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    location /sw.js {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }
    
    access_log /var/log/nginx/admin.trendyol-invest.com.access.log;
    error_log /var/log/nginx/admin.trendyol-invest.com.error.log;
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

### 3️⃣ تحديث الملف على السيرفر

```bash
cd /var/www/trendyol-invest.com
git pull origin main
cp android-svg-code-render-master/index-50.html index.html
systemctl reload nginx
```

---

### 4️⃣ الحصول على شهادة SSL

```bash
certbot --nginx -d admin.trendyol-invest.com
```

---

## بعد الإعداد

افتح المتصفح وانتقل إلى:

```
https://admin.trendyol-invest.com
```

سيتم فتح صفحة تسجيل دخول الأدمن تلقائياً.

---

## ملاحظات مهمة

### إذا كان Hostinger يدير Nginx:

إذا كان Hostinger يدير Nginx تلقائياً، قد تحتاج إلى:

1. **استخدام Directory مشترك**: في Hostinger، عند إنشاء subdomain، اختر نفس directory للموقع الرئيسي
2. **أو إضافة redirect**: في Hostinger Panel، أضف redirect من subdomain إلى الموقع الرئيسي

### إذا كان لديك subdomain مختلف:

إذا أنشأت subdomain باسم آخر (مثل `panel-trendyol-5482`)، غيّر الكود:

في ملف `index-50.html`، ابحث عن:
```javascript
if(window.location.hostname.startsWith('admin.')){
```

وغيّره إلى:
```javascript
if(window.location.hostname.startsWith('admin.') || window.location.hostname.startsWith('panel-trendyol-')){
```

أو استخدم pattern أكثر مرونة:
```javascript
if(window.location.hostname !== 'trendyol-invest.com' && window.location.hostname !== 'www.trendyol-invest.com'){
```

---

## التحقق من الإعداد

1. **تحقق من DNS**:
   ```bash
   nslookup admin.trendyol-invest.com
   ```

2. **تحقق من Nginx**:
   ```bash
   nginx -t
   systemctl status nginx
   ```

3. **تحقق من الملف**:
   ```bash
   grep "admin." /var/www/trendyol-invest.com/index.html
   ```

---

**بعد الإعداد، الرابط سيكون:**
```
https://admin.trendyol-invest.com
```

