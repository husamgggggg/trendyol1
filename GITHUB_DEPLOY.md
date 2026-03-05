# دليل رفع المشروع على GitHub والنشر على السيرفر

## 📋 الخطوات الكاملة

### 1️⃣ إعداد Git ورفع المشروع على GitHub

#### أ) إعداد Git (مرة واحدة)
```bash
./setup-git.sh
```

#### ب) إنشاء المستودع على GitHub
1. اذهب إلى: https://github.com/new
2. اسم المستودع: `trendyol1`
3. **لا تضع** README أو .gitignore (موجودان بالفعل)
4. اضغط "Create repository"

#### ج) رفع المشروع
```bash
./push-to-github.sh
```

**ملاحظة**: إذا طُلب منك اسم المستخدم وكلمة المرور:
- استخدم **Personal Access Token** بدلاً من كلمة المرور
- لإنشاء Token: GitHub → Settings → Developer settings → Personal access tokens → Generate new token
- الصلاحيات المطلوبة: `repo`

---

### 2️⃣ سحب المشروع على السيرفر

#### الطريقة التلقائية (من جهازك المحلي)
```bash
./deploy-from-github.sh
```

#### الطريقة اليدوية (على السيرفر مباشرة)
```bash
ssh root@187.124.28.173

# تنظيف السيرفر أولاً
DOMAIN="trendyol-invest.com"
REMOTE_DIR="/var/www/${DOMAIN}"
rm -rf ${REMOTE_DIR}/* ${REMOTE_DIR}/.* 2>/dev/null || true
mkdir -p ${REMOTE_DIR}

# تثبيت Git إذا لم يكن موجوداً
apt-get update && apt-get install -y git

# سحب المشروع
cd ${REMOTE_DIR}
git clone https://github.com/husamgggggg/trendyol1.git .

# نسخ index.html
cp android-svg-code-render-master/index-50.html index.html

# إعطاء الصلاحيات
chown -R www-data:www-data ${REMOTE_DIR}
chmod -R 755 ${REMOTE_DIR}
```

---

### 3️⃣ التحديثات المستقبلية

#### من جهازك المحلي:
```bash
# 1. تحديث الكود
git add .
git commit -m "تحديث الموقع"
git push origin main

# 2. سحب التحديثات على السيرفر
./deploy-from-github.sh
```

#### أو على السيرفر مباشرة:
```bash
ssh root@187.124.28.173
cd /var/www/trendyol-invest.com
git pull origin main
cp android-svg-code-render-master/index-50.html index.html
chown -R www-data:www-data /var/www/trendyol-invest.com
```

---

## 🔐 إعداد المصادقة مع GitHub

### الطريقة 1: Personal Access Token (الأسهل)
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. اختر صلاحيات: `repo`
4. انسخ الـ Token
5. عند `git push` استخدم الـ Token ككلمة مرور

### الطريقة 2: SSH Key (الأكثر أماناً)
```bash
# إنشاء SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# نسخ المفتاح العام
cat ~/.ssh/id_ed25519.pub

# أضف المفتاح إلى GitHub:
# Settings → SSH and GPG keys → New SSH key
```

---

## 📁 هيكل المشروع على GitHub

```
trendyol1/
├── android-svg-code-render-master/
│   └── index-50.html
├── manifest.json
├── sw.js
├── nginx-trendyol.conf
├── deploy.sh
├── setup-server.sh
├── clean-server.sh
├── .gitignore
└── README.md
```

---

## 🔄 سير العمل الموصى به

1. **تطوير محلي** → تعديل الملفات
2. **Commit** → `git add . && git commit -m "وصف التحديث"`
3. **Push** → `git push origin main`
4. **Deploy** → `./deploy-from-github.sh`

---

## 🆘 استكشاف الأخطاء

### المشكلة: فشل الرفع إلى GitHub
```bash
# التحقق من الاتصال
git remote -v

# تحديث URL
git remote set-url origin https://github.com/husamgggggg/trendyol1.git
```

### المشكلة: Git غير مثبت على السيرفر
```bash
ssh root@187.124.28.173
apt-get update && apt-get install -y git
```

### المشكلة: خطأ في الصلاحيات على السيرفر
```bash
ssh root@187.124.28.173
chown -R www-data:www-data /var/www/trendyol-invest.com
chmod -R 755 /var/www/trendyol-invest.com
```

---

## ✅ التحقق من النشر

بعد النشر، تحقق من:
- ✅ https://github.com/husamgggggg/trendyol1 (المشروع موجود)
- ✅ https://trendyol-invest.com (الموقع يعمل)
- ✅ SSL مفعّل (قفل أخضر)

---

**تم الإعداد بنجاح! 🎉**

