# كيفية الدخول إلى لوحة التحكم الإدارية

## 🔐 طريقتان للدخول

### الطريقة الأولى: رابط مباشر (الأسهل)

أضف `?admin=trendyol-secret` في نهاية رابط الموقع:

```
http://localhost:8000/index-50.html?admin=trendyol-secret
```

أو إذا كان الموقع على سيرفر:
```
https://yourdomain.com/index-50.html?admin=trendyol-secret
```

**مثال:**
- إذا كان الموقع على: `http://localhost:8000/index-50.html`
- الرابط الكامل: `http://localhost:8000/index-50.html?admin=trendyol-secret`

### الطريقة الثانية: إنشاء رابط في الكود

يمكنك إضافة زر في الصفحة الرئيسية (اختياري):

```html
<button onclick="go('adminlogin')">لوحة التحكم</button>
```

---

## 🔑 بيانات الدخول

### كلمة المرور الافتراضية:
```
admin123
```

### اسم المستخدم:
```
admin
```

---

## 📝 إعداد حساب المدير في قاعدة البيانات

إذا لم يكن لديك حساب مدير، قم بإضافته في Supabase:

### 1. افتح Supabase Dashboard
- اذهب إلى Table Editor
- اختر جدول `admins`

### 2. أضف سجل جديد:
```sql
INSERT INTO admins (username, password) 
VALUES ('admin', 'admin123');
```

أو من خلال SQL Editor:
```sql
INSERT INTO admins (username, password) 
VALUES ('admin', 'admin123')
ON CONFLICT (username) DO NOTHING;
```

---

## 🔄 تغيير كلمة المرور

### من لوحة التحكم:
1. ادخل إلى لوحة التحكم
2. اذهب إلى قسم "⚙️ الإعدادات"
3. أدخل كلمة المرور الجديدة في حقل "كلمة مرور جديدة للأدمن"
4. اضغط "💾 حفظ الإعدادات"

### من قاعدة البيانات مباشرة:
```sql
UPDATE admins 
SET password = 'كلمة_المرور_الجديدة' 
WHERE username = 'admin';
```

---

## ✅ خطوات الدخول الكاملة

### 1. تأكد من وجود حساب مدير:
```sql
-- تحقق من وجود المدير
SELECT * FROM admins WHERE username = 'admin';

-- إذا لم يكن موجوداً، أضفه:
INSERT INTO admins (username, password) 
VALUES ('admin', 'admin123');
```

### 2. افتح رابط الدخول:
```
http://localhost:8000/index-50.html?admin=trendyol-secret
```

### 3. أدخل كلمة المرور:
- كلمة المرور: `admin123`

### 4. اضغط "دخول"

---

## 🛡️ الأمان

### نصائح مهمة:

1. **غيّر كلمة المرور الافتراضية** فوراً بعد أول دخول
2. **لا تشارك رابط `?admin=trendyol-secret`** مع أي شخص
3. **استخدم كلمة مرور قوية** (8 أحرف على الأقل، مزيج من أرقام وحروف)
4. **احفظ كلمة المرور في مكان آمن**

### تغيير رابط الدخول (اختياري):

إذا أردت تغيير الكلمة السرية في الرابط، عدّل في `index-50.html`:

```javascript
// السطر 731
if(p.get('admin')==='trendyol-secret'){  // غيّر 'trendyol-secret' إلى كلمة أخرى
  go('adminlogin');
  return;
}
```

---

## 🐛 استكشاف الأخطاء

### المشكلة: لا يفتح صفحة الدخول
**الحل:**
- تأكد من كتابة الرابط بشكل صحيح
- تأكد من وجود `?admin=trendyol-secret` في نهاية الرابط

### المشكلة: "كلمة المرور غير صحيحة"
**الحل:**
1. تحقق من وجود حساب مدير في قاعدة البيانات:
```sql
SELECT * FROM admins;
```
2. إذا لم يكن موجوداً، أضفه:
```sql
INSERT INTO admins (username, password) VALUES ('admin', 'admin123');
```
3. تأكد من أن كلمة المرور مطابقة تماماً

### المشكلة: لا يمكن حفظ الإعدادات
**الحل:**
- تأكد من أن جدول `settings` موجود
- تأكد من وجود سجل بـ `id = 1` في جدول `settings`

---

## 📋 ملخص سريع

```
1. افتح: http://localhost:8000/index-50.html?admin=trendyol-secret
2. أدخل كلمة المرور: admin123
3. اضغط "دخول"
4. غيّر كلمة المرور من الإعدادات
```

---

## 🎯 روابط سريعة

- **رابط الدخول:** `index-50.html?admin=trendyol-secret`
- **كلمة المرور الافتراضية:** `admin123`
- **اسم المستخدم:** `admin`

---

## 💡 نصيحة

احفظ هذا الرابط في مكان آمن:
```
index-50.html?admin=trendyol-secret
```

أو أنشئ bookmark في المتصفح للوصول السريع.
