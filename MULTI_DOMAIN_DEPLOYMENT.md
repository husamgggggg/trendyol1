# دليل رفع البرنامج على نطاقين (Domains)

## 📋 نظرة عامة

هذا الدليل يوضح كيفية رفع منصة Trendyol الاستثمارية على نطاقين مختلفين. يمكنك استخدام نفس قاعدة البيانات Supabase أو قواعد بيانات منفصلة لكل نطاق.

---

## 🎯 السيناريوهات الممكنة

### السيناريو 1: نفس قاعدة البيانات (مشترك)
- ✅ أسهل في الإدارة
- ✅ بيانات موحدة
- ✅ مناسب للمواقع المرآة (Mirror Sites)

### السيناريو 2: قواعد بيانات منفصلة
- ✅ عزل كامل للبيانات
- ✅ إدارة مستقلة لكل نطاق
- ✅ مناسب للمواقع المستقلة

---

## 🚀 الطريقة 1: رفع على نطاقين باستخدام نفس قاعدة البيانات

### الخطوة 1: إعداد ملف واحد للرفع

1. **استخدم الملف الحالي `index-50.html`**
   - الملف جاهز للرفع على أي نطاق
   - بيانات Supabase واحدة لجميع النطاقات

2. **تحديث بيانات Supabase (إذا لزم الأمر):**
   ```javascript
   // في ملف index-50.html، السطر 684
   var DB=supabase.createClient('YOUR_SUPABASE_URL','YOUR_SUPABASE_KEY');
   ```

### الخطوة 2: رفع على النطاق الأول

#### أ) باستخدام Netlify:

1. **اذهب إلى:** [netlify.com](https://netlify.com)
2. **سجّل حساب:** مجاني
3. **اضغط:** "Add new site" → "Deploy manually"
4. **اسحب:** `index-50.html` إلى الصفحة
5. **احفظ الرابط:** `https://domain1.netlify.app/index-50.html`

#### ب) باستخدام Vercel:

```bash
# من مجلد المشروع
cd "C:\Users\it 021\Desktop\trendyol"

# تثبيت Vercel CLI (مرة واحدة)
npm install -g vercel

# رفع الموقع
vercel

# اتبع التعليمات:
# - سجّل دخولك
# - اختر المشروع
# - سيتم الرفع تلقائياً
```

#### ج) باستخدام استضافة عادية (FTP):

1. **استخدم FileZilla أو WinSCP**
2. **اتصل بالسيرفر الأول:**
   - Host: عنوان السيرفر الأول
   - Username: اسم المستخدم
   - Password: كلمة المرور
   - Port: 21 (FTP) أو 22 (SFTP)
3. **ارفع الملف:**
   - اسحب `index-50.html` إلى مجلد `public_html` أو `www`
   - أو أعد تسميته إلى `index.html`

### الخطوة 3: رفع على النطاق الثاني

**كرر نفس الخطوات السابقة على النطاق الثاني:**

#### أ) Netlify (نطاق ثاني):
- أنشئ موقع جديد في Netlify
- ارفع نفس الملف `index-50.html`
- الرابط: `https://domain2.netlify.app/index-50.html`

#### ب) Vercel (نطاق ثاني):
```bash
# نفس الأمر، لكن سيتم إنشاء مشروع جديد
vercel
```

#### ج) استضافة عادية (نطاق ثاني):
- اتصل بالسيرفر الثاني
- ارفع نفس الملف `index-50.html`

---

## 🔄 الطريقة 2: رفع على نطاقين بقواعد بيانات منفصلة

### الخطوة 1: إنشاء نسختين من الملف

#### 1. إنشاء نسخة للنطاق الأول:

```bash
# نسخ الملف
copy index-50.html index-domain1.html
```

#### 2. إنشاء نسخة للنطاق الثاني:

```bash
# نسخ الملف
copy index-50.html index-domain2.html
```

### الخطوة 2: إعداد قاعدة بيانات Supabase للنطاق الأول

1. **أنشئ مشروع Supabase جديد:**
   - اذهب إلى [supabase.com](https://supabase.com)
   - أنشئ مشروع جديد باسم "trendyol-domain1"

2. **احصل على بيانات الاتصال:**
   - URL: `https://xxxxx.supabase.co`
   - Key: `sb_publishable_xxxxx`

3. **أنشئ الجداول:**
   - استخدم نفس SQL من `RUN_COMMANDS.md`
   - أو انسخ الجداول من المشروع الأول

### الخطوة 3: تحديث ملف النطاق الأول

افتح `index-domain1.html` وابحث عن:
```javascript
var DB=supabase.createClient('YOUR_SUPABASE_URL','YOUR_SUPABASE_KEY');
```

استبدل بـ بيانات Supabase للنطاق الأول:
```javascript
var DB=supabase.createClient('https://domain1-xxxxx.supabase.co','sb_publishable_domain1_key');
```

### الخطوة 4: إعداد قاعدة بيانات Supabase للنطاق الثاني

1. **أنشئ مشروع Supabase جديد:**
   - مشروع جديد باسم "trendyol-domain2"

2. **احصل على بيانات الاتصال**

3. **أنشئ الجداول** (نفس SQL)

### الخطوة 5: تحديث ملف النطاق الثاني

افتح `index-domain2.html` وحدّث بيانات Supabase:
```javascript
var DB=supabase.createClient('https://domain2-xxxxx.supabase.co','sb_publishable_domain2_key');
```

### الخطوة 6: رفع الملفات

#### رفع النطاق الأول:
- ارفع `index-domain1.html` على النطاق الأول
- أو أعد تسميته إلى `index.html`

#### رفع النطاق الثاني:
- ارفع `index-domain2.html` على النطاق الثاني
- أو أعد تسميته إلى `index.html`

---

## 📝 سكريبت تلقائي لإنشاء النسخ

### إنشاء ملف `create-domains.bat` (Windows):

```batch
@echo off
echo Creating domain files...

copy index-50.html index-domain1.html
copy index-50.html index-domain2.html

echo.
echo Files created:
echo - index-domain1.html
echo - index-domain2.html
echo.
echo Next steps:
echo 1. Update Supabase URLs in each file
echo 2. Upload to your domains
pause
```

### إنشاء ملف `create-domains.sh` (Linux/Mac):

```bash
#!/bin/bash
echo "Creating domain files..."

cp index-50.html index-domain1.html
cp index-50.html index-domain2.html

echo ""
echo "Files created:"
echo "- index-domain1.html"
echo "- index-domain2.html"
echo ""
echo "Next steps:"
echo "1. Update Supabase URLs in each file"
echo "2. Upload to your domains"
```

---

## 🔧 إعدادات متقدمة

### 1. استخدام متغيرات البيئة (Environment Variables)

إذا كنت تستخدم Netlify أو Vercel، يمكنك استخدام متغيرات البيئة:

#### في Netlify:
1. اذهب إلى Site settings → Environment variables
2. أضف:
   - `SUPABASE_URL`: رابط Supabase
   - `SUPABASE_KEY`: المفتاح

#### في Vercel:
1. اذهب إلى Project settings → Environment Variables
2. أضف نفس المتغيرات

#### تحديث الكود لاستخدام المتغيرات:

```javascript
// في index-50.html
var SUPABASE_URL = window.SUPABASE_URL || 'https://hnytoognlhubnopmgfay.supabase.co';
var SUPABASE_KEY = window.SUPABASE_KEY || 'sb_publishable_s28RnLc2XDGcLX2OnrhBUw_sljae1aZ';
var DB = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
```

### 2. إعدادات CORS في Supabase

تأكد من إضافة النطاقات في Supabase:

1. اذهب إلى Supabase Dashboard
2. Settings → API
3. أضف النطاقات في "Allowed CORS origins":
   ```
   https://domain1.com
   https://domain2.com
   https://domain1.netlify.app
   https://domain2.netlify.app
   ```

---

## 📋 قائمة التحقق

### قبل الرفع على النطاق الأول:
- [ ] تحديث بيانات Supabase في الملف (إذا لزم الأمر)
- [ ] اختبار الموقع محلياً
- [ ] التأكد من عمل جميع الميزات
- [ ] إنشاء الجداول في Supabase
- [ ] إعداد حساب مدير

### قبل الرفع على النطاق الثاني:
- [ ] إنشاء نسخة من الملف (إذا كانت قواعد بيانات منفصلة)
- [ ] تحديث بيانات Supabase في الملف الثاني
- [ ] إنشاء الجداول في Supabase الثاني (إذا منفصل)
- [ ] اختبار الموقع محلياً
- [ ] إضافة النطاق في CORS settings

### بعد الرفع على كلا النطاقين:
- [ ] اختبار الموقع على النطاق الأول
- [ ] اختبار الموقع على النطاق الثاني
- [ ] اختبار تسجيل الدخول على كلا النطاقين
- [ ] اختبار لوحة التحكم على كلا النطاقين
- [ ] اختبار جميع الميزات

---

## 🎯 الطريقة الأسهل (مشترك)

### خطوات سريعة:

1. **استخدم الملف الحالي `index-50.html`**
2. **ارفع على Netlify (النطاق الأول):**
   - سجّل حساب
   - اسحب الملف
   - احفظ الرابط
3. **ارفع على Netlify (النطاق الثاني):**
   - أنشئ موقع جديد
   - اسحب نفس الملف
   - احفظ الرابط
4. **انتهى!** 🎉

**الروابط:**
```
https://domain1.netlify.app/index-50.html
https://domain2.netlify.app/index-50.html
```

---

## 🔄 التحديثات المستقبلية

### إذا استخدمت نفس الملف (مشترك):

عند التحديث، ارفع الملف المحدث على كلا النطاقين:

#### Netlify:
- ارفع الملف المحدث على الموقع الأول
- ارفع الملف المحدث على الموقع الثاني

#### Vercel:
```bash
# تحديث النطاق الأول
cd project1
vercel --prod

# تحديث النطاق الثاني
cd project2
vercel --prod
```

#### FTP:
- ارفع الملف المحدث على السيرفر الأول
- ارفع الملف المحدث على السيرفر الثاني

### إذا استخدمت ملفات منفصلة:

حدّث كل ملف حسب الحاجة وارفعه على النطاق المناسب.

---

## 🆘 استكشاف الأخطاء

### المشكلة: النطاق الأول يعمل لكن الثاني لا يعمل
**الحل:**
- تحقق من بيانات Supabase في الملف الثاني
- تأكد من إضافة النطاق في CORS settings
- افتح Console (F12) وابحث عن الأخطاء

### المشكلة: قاعدة البيانات لا تعمل على أحد النطاقين
**الحل:**
- تحقق من URL و Key في الملف
- تأكد من أن Supabase متاح
- تحقق من RLS Policies
- تأكد من إضافة النطاق في CORS

### المشكلة: البيانات تختلط بين النطاقين
**الحل:**
- استخدم قواعد بيانات منفصلة لكل نطاق
- أو أضف حقل `domain` في الجداول للتمييز

---

## 💡 نصائح مهمة

1. **للمواقع المرآة (Mirror Sites):**
   - استخدم نفس قاعدة البيانات
   - أسهل في الإدارة والتحديث

2. **للمواقع المستقلة:**
   - استخدم قواعد بيانات منفصلة
   - عزل كامل للبيانات

3. **للأداء:**
   - استخدم CDN (Cloudflare)
   - فعّل التخزين المؤقت (Caching)

4. **للأمان:**
   - استخدم HTTPS على كلا النطاقين
   - راجع RLS Policies في Supabase

---

## ✅ الخلاصة

### الطريقة الموصى بها:

1. **للمبتدئين:** استخدم Netlify + نفس قاعدة البيانات
2. **للمحترفين:** استخدم Vercel + قواعد بيانات منفصلة
3. **للإنتاج:** استخدم استضافة عادية + قواعد بيانات منفصلة

---

## 📞 الدعم

إذا واجهت مشاكل:
1. راجع Console في المتصفح (F12)
2. راجع ملف `DEPLOYMENT.md`
3. راجع ملف `RUN_COMMANDS.md`
4. تحقق من إعدادات Supabase

