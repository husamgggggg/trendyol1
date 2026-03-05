# أوامر السيرفر المباشرة

## 🚀 الطريقة السريعة (من جهازك المحلي)

### نسخ السكريبت إلى السيرفر
```bash
./copy-deploy-script.sh
```

### ثم على السيرفر
```bash
ssh root@187.124.28.173
./deploy-on-server.sh
```

---

## 📋 الطريقة اليدوية (على السيرفر مباشرة)

انسخ والصق هذا الأمر كاملاً على السيرفر:

```bash
cat > /root/deploy-on-server.sh << 'EOF'
#!/bin/bash
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"
REPO="https://github.com/husamgggggg/trendyol1.git"

echo "📥 سحب المشروع من GitHub..."

# تثبيت Git
apt-get update && apt-get install -y git

# تنظيف المجلد
rm -rf ${REMOTE_DIR}/* ${REMOTE_DIR}/.* 2>/dev/null || true
mkdir -p ${REMOTE_DIR}

# سحب المشروع
cd ${REMOTE_DIR}
git clone ${REPO} .

# نسخ index.html
cp android-svg-code-render-master/index-50.html index.html

# إعطاء الصلاحيات
chown -R www-data:www-data ${REMOTE_DIR}
chmod -R 755 ${REMOTE_DIR}

echo "✅ تم!"
EOF

chmod +x /root/deploy-on-server.sh
./deploy-on-server.sh
```

---

## 🔄 التحديثات المستقبلية (على السيرفر)

```bash
cd /var/www/trendyol-invest.com
git pull origin main
cp android-svg-code-render-master/index-50.html index.html
chown -R www-data:www-data /var/www/trendyol-invest.com
```

---

## ⚡ أوامر سريعة (على السيرفر)

### تنظيف فقط
```bash
rm -rf /var/www/trendyol-invest.com/* /var/www/trendyol-invest.com/.* 2>/dev/null || true
```

### سحب من GitHub فقط
```bash
cd /var/www/trendyol-invest.com
git pull origin main
cp android-svg-code-render-master/index-50.html index.html
```

### إعادة تحميل Nginx
```bash
nginx -t && systemctl reload nginx
```

