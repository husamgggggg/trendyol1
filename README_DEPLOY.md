# نشر موقع ترنديول على السيرفر

## 🚀 النشر السريع

### الخطوة 1: إعداد DNS
تأكد من إعداد سجلات DNS:
- `trendyol-invest.com` → `187.124.28.173`
- `www.trendyol-invest.com` → `187.124.28.173`

### الخطوة 2: إعداد السيرفر (مرة واحدة فقط)
```bash
# نسخ ملف الإعداد
scp setup-server.sh root@187.124.28.173:/root/

# الاتصال وتشغيل الإعداد
ssh root@187.124.28.173
chmod +x /root/setup-server.sh
/root/setup-server.sh
```

### الخطوة 3: نشر الموقع
```bash
# من مجلد المشروع
chmod +x deploy.sh
./deploy.sh
```

## 📁 الملفات المطلوبة
- ✅ `android-svg-code-render-master/index-50.html`
- ✅ `manifest.json`
- ✅ `sw.js`
- ✅ `icon-192.png` (اختياري)

## 🔄 التحديثات المستقبلية
```bash
./deploy.sh
```

## 📖 للتفاصيل الكاملة
راجع ملف `دليل_النشر.md`

