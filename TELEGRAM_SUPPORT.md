# تحديث نظام الدعم - Telegram

## ✅ التغييرات المطبقة

تم تحديث نظام الدعم من البريد الإلكتروني إلى Telegram.

### التغييرات:

1. ✅ **إزالة البريد الإلكتروني** من نافذة الدعم
2. ✅ **إضافة Telegram** كوسيلة التواصل الوحيدة
3. ✅ **إضافة زر "للتواصل اضغط هنا"** يفتح Telegram مباشرة
4. ✅ **إضافة حقل في لوحة الإدارة** لإضافة يوزر Telegram
5. ✅ **إزالة زر "فتح البريد"**

---

## 🔧 كيفية الإعداد

### 1. إضافة حقل `telegram_username` في قاعدة البيانات

افتح Supabase SQL Editor وقم بتشغيل:

```sql
-- إضافة عمود telegram_username إلى جدول settings
ALTER TABLE settings 
ADD COLUMN IF NOT EXISTS telegram_username TEXT;

-- تحديث القيمة الافتراضية (اختياري)
UPDATE settings 
SET telegram_username = '@your_telegram_username' 
WHERE id = 1;
```

### 2. إعداد يوزر Telegram من لوحة التحكم

1. ادخل إلى لوحة التحكم الإدارية
2. اذهب إلى قسم "⚙️ الإعدادات"
3. ابحث عن حقل "يوزر Telegram للدعم"
4. أدخل يوزر Telegram (مثال: `@username` أو `username`)
5. اضغط "💾 حفظ الإعدادات"

---

## 📱 كيفية استخدام نظام الدعم الجديد

### للمستخدمين:

1. اضغط على زر "💬 الدعم" في أي مكان في الموقع
2. ستظهر نافذة الدعم مع:
   - أيقونة Telegram 📱
   - نص "تواصل معنا عبر Telegram"
   - يوزر Telegram الحالي
   - زر "📱 للتواصل اضغط هنا"
3. اضغط على الزر
4. سيتم فتح Telegram مباشرة في نافذة جديدة

### للمديرين:

1. ادخل إلى لوحة التحكم
2. اذهب إلى "⚙️ الإعدادات"
3. ابحث عن "يوزر Telegram للدعم"
4. أدخل يوزر Telegram (مثال: `@support` أو `support`)
5. احفظ الإعدادات

---

## 🔄 التحديثات في الكود

### المتغيرات:
```javascript
// قبل:
var C={tron:'',eth:'',email:'support@trendyol.invest',fee:6,mw:50};

// بعد:
var C={tron:'',eth:'',telegram:'',fee:6,mw:50};
```

### قاعدة البيانات:
```sql
-- الحقل القديم (يمكن حذفه لاحقاً):
support_email TEXT

-- الحقل الجديد:
telegram_username TEXT
```

### الوظيفة الجديدة:
```javascript
function openTelegram(){
  var username=C.telegram||'';
  if(!username||username===''){
    tst('err','خطأ','لم يتم إعداد يوزر Telegram بعد');
    return;
  }
  username=username.replace('@','');
  var tgUrl='https://t.me/'+username;
  window.open(tgUrl,'_blank');
}
```

---

## 📋 مثال على الاستخدام

### إعداد يوزر Telegram:

1. **في Supabase:**
```sql
UPDATE settings 
SET telegram_username = '@trendyol_support' 
WHERE id = 1;
```

2. **أو من لوحة التحكم:**
   - اذهب إلى الإعدادات
   - أدخل: `@trendyol_support`
   - احفظ

### عندما يضغط المستخدم على "للتواصل اضغط هنا":
- سيتم فتح: `https://t.me/trendyol_support`
- في نافذة جديدة
- مباشرة في Telegram (إذا كان مثبتاً) أو في المتصفح

---

## ⚠️ ملاحظات مهمة

1. **يوزر Telegram يجب أن يكون صحيحاً:**
   - يمكن إدخاله مع `@` أو بدونه
   - الكود يزيل `@` تلقائياً

2. **إذا لم يتم إعداد يوزر Telegram:**
   - سيظهر "لم يُضبط" في نافذة الدعم
   - عند الضغط على الزر، ستظهر رسالة خطأ

3. **الحقل القديم `support_email`:**
   - يمكن حذفه من قاعدة البيانات لاحقاً
   - أو تركه للاحتياط

---

## 🔍 استكشاف الأخطاء

### المشكلة: لا يفتح Telegram
**الحل:**
- تأكد من إدخال يوزر Telegram بشكل صحيح
- تأكد من أن اليوزر موجود في Telegram
- جرب فتح الرابط يدوياً: `https://t.me/username`

### المشكلة: "لم يتم إعداد يوزر Telegram بعد"
**الحل:**
1. ادخل إلى لوحة التحكم
2. اذهب إلى الإعدادات
3. أضف يوزر Telegram
4. احفظ الإعدادات

### المشكلة: خطأ في قاعدة البيانات
**الحل:**
```sql
-- تأكد من وجود العمود
ALTER TABLE settings 
ADD COLUMN IF NOT EXISTS telegram_username TEXT;

-- أضف قيمة افتراضية
UPDATE settings 
SET telegram_username = '@your_username' 
WHERE id = 1;
```

---

## ✅ الخلاصة

الآن نظام الدعم يعمل بالكامل عبر Telegram:
- ✅ نافذة دعم جديدة مع Telegram
- ✅ زر "للتواصل اضغط هنا"
- ✅ حقل في لوحة الإدارة لإضافة يوزر Telegram
- ✅ فتح Telegram مباشرة عند الضغط على الزر

**لا تنسى:**
1. إضافة عمود `telegram_username` في قاعدة البيانات
2. إضافة يوزر Telegram من لوحة التحكم
3. اختبار النظام بالضغط على زر الدعم
