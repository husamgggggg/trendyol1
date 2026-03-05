# 🚀 دليل البدء السريع

## الطريقة السريعة (من جهازك المحلي)

### الخطوة 1: نسخ السكريبتات إلى السيرفر
```bash
./copy-scripts.sh
```

### الخطوة 2: الاتصال بالسيرفر وتنظيفه
```bash
ssh root@187.124.28.173
./clean-server.sh
```

### الخطوة 3: إعداد السيرفر (مرة واحدة فقط)
```bash
./setup-server.sh
```

### الخطوة 4: العودة لجهازك المحلي ونشر الموقع
```bash
exit  # للخروج من SSH
./deploy.sh
```

---

## الطريقة اليدوية (على السيرفر مباشرة)

### 1. إنشاء ملف التنظيف على السيرفر
```bash
ssh root@187.124.28.173
cat > /root/clean-server.sh << 'EOF'
#!/bin/bash
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"
echo "🧹 حذف محتويات ${REMOTE_DIR}..."
rm -rf ${REMOTE_DIR}/* ${REMOTE_DIR}/.* 2>/dev/null || true
mkdir -p ${REMOTE_DIR}
chown -R www-data:www-data ${REMOTE_DIR}
chmod -R 755 ${REMOTE_DIR}
rm -f /etc/nginx/sites-available/${DOMAIN}
rm -f /etc/nginx/sites-enabled/${DOMAIN}
systemctl stop nginx 2>/dev/null || true
echo "✅ تم التنظيف!"
EOF

chmod +x /root/clean-server.sh
./clean-server.sh
```

### 2. إعداد السيرفر
```bash
# نسخ ملف الإعداد من جهازك المحلي
# من جهازك المحلي:
scp setup-server.sh root@187.124.28.173:/root/

# على السيرفر:
chmod +x /root/setup-server.sh
/root/setup-server.sh
```

### 3. نشر الموقع
```bash
# من جهازك المحلي:
./deploy.sh
```

---

## ⚡ الطريقة الأسرع (كل شيء تلقائياً)

من جهازك المحلي:
```bash
./copy-scripts.sh
ssh root@187.124.28.173 "./clean-server.sh && ./setup-server.sh"
./deploy.sh
```

---

## 📝 ملاحظات

- تأكد من إعداد DNS قبل البدء
- عند تشغيل `setup-server.sh` سيطلب Certbot بريد إلكتروني
- بعد النشر، الموقع سيكون على: https://trendyol-invest.com

