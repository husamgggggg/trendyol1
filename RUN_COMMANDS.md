+# أوامر التشغيل - Trendyol Project

## 📋 نظرة عامة

هذا المشروع يحتوي على جزئين:
1. **أداة تحويل SVG إلى Java** (مشروع Gradle)
2. **منصة Trendyol الاستثمارية** (ملف HTML واحد)

---

## 🔧 الجزء الأول: أداة تحويل SVG إلى Java

### المتطلبات الأساسية
- ✅ Java JDK 8 أو أحدث
- ✅ Gradle (مضمن في المشروع)

### التحقق من التثبيت
```bash
# التحقق من Java
java -version

# يجب أن يظهر شيء مثل:
# java version "1.8.0_xxx" أو أحدث
```

### بناء المشروع (Build)

#### على Windows:
```cmd
# بناء المشروع وإنشاء JAR
gradlew.bat build

# أو
gradlew.bat jar
```

#### على Linux/Mac:
```bash
# إعطاء صلاحيات التنفيذ
chmod +x gradlew

# بناء المشروع
./gradlew build

# أو
./gradlew jar
```

### تشغيل الأداة

بعد البناء، ستجد ملف JAR في: `build/libs/android_svg_code_render-1.5.0.jar`

#### استخدام الأداة:
```bash
# الصيغة الأساسية
java -jar build/libs/android_svg_code_render-1.5.0.jar <inputfile.svg> [options]

# مثال بسيط
java -jar build/libs/android_svg_code_render-1.5.0.jar image.svg

# مثال مع خيارات
java -jar build/libs/android_svg_code_render-1.5.0.jar image.svg -p com.example -c MyVector -o Output.java
```

#### جميع الخيارات المتاحة:
```bash
java -jar build/libs/android_svg_code_render-1.5.0.jar <inputfile.svg> \
  [-p <package name>] \              # اسم الحزمة (افتراضي: vector_render)
  [-c <class name>] \                # اسم الكلاس (افتراضي: VectorRender_<filename>)
  [-o <outputfile.java>] \           # ملف الإخراج
  [-t <template file>] \             # ملف قالب مخصص
  [-aos <api version>] \             # الحد الأدنى لـ Android API (افتراضي: 14)
  [-rt <text replacement file>] \    # ملف استبدال النصوص
  [-rc <color replacement file>] \    # ملف استبدال الألوان
  [-tfp <typeface parameter name>]   # اسم معامل Typeface
```

#### أمثلة عملية:
```bash
# مثال 1: تحويل بسيط
java -jar build/libs/android_svg_code_render-1.5.0.jar logo.svg

# مثال 2: مع حزمة وكلاس مخصص
java -jar build/libs/android_svg_code_render-1.5.0.jar icon.svg \
  -p com.myapp.vectors \
  -c AppIcon \
  -o AppIcon.java

# مثال 3: لـ Android API 21
java -jar build/libs/android_svg_code_render-1.5.0.jar background.svg \
  -aos 21 \
  -p com.myapp.ui

# مثال 4: مع استبدال النصوص
java -jar build/libs/android_svg_code_render-1.5.0.jar template.svg \
  -rt text_replacements.txt \
  -rc color_replacements.txt
```

### عرض المساعدة
```bash
java -jar build/libs/android_svg_code_render-1.5.0.jar -h
# أو
java -jar build/libs/android_svg_code_render-1.5.0.jar -help
```

---

## 🌐 الجزء الثاني: منصة Trendyol الاستثمارية

### المتطلبات الأساسية
- ✅ متصفح ويب حديث (Chrome, Firefox, Edge)
- ✅ اتصال بالإنترنت (للاتصال بـ Supabase)
- ✅ حساب Supabase (للقاعدة البيانات)

### التشغيل السريع

#### الطريقة 1: فتح مباشر
```bash
# على Windows
start index-50.html

# على Linux
xdg-open index-50.html

# على Mac
open index-50.html
```

#### الطريقة 2: استخدام خادم محلي

**باستخدام Python:**
```bash
# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000

# ثم افتح المتصفح على:
# http://localhost:8000/index-50.html
```

**باستخدام Node.js (http-server):**
```bash
# تثبيت http-server (مرة واحدة)
npm install -g http-server

# تشغيل الخادم
http-server -p 8000

# ثم افتح المتصفح على:
# http://localhost:8000/index-50.html
```

**باستخدام PHP:**
```bash
php -S localhost:8000

# ثم افتح المتصفح على:
# http://localhost:8000/index-50.html
```

### إعداد قاعدة البيانات (Supabase)

#### 1. إنشاء مشروع Supabase
1. اذهب إلى [supabase.com](https://supabase.com)
2. أنشئ حساب جديد أو سجل الدخول
3. أنشئ مشروع جديد

#### 2. تحديث بيانات الاتصال
افتح ملف `index-50.html` وابحث عن:
```javascript
var DB=supabase.createClient('YOUR_SUPABASE_URL','YOUR_SUPABASE_KEY');
```

استبدل بـ:
- `YOUR_SUPABASE_URL`: رابط مشروعك من Supabase
- `YOUR_SUPABASE_KEY`: المفتاح العام (anon key)

#### 3. إنشاء الجداول

قم بتشغيل هذه الاستعلامات في SQL Editor في Supabase:

```sql
-- جدول المستخدمين
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  balance DECIMAL(10,2) DEFAULT 0,
  profit_bal DECIMAL(10,2) DEFAULT 0,
  pending_profit DECIMAL(10,2) DEFAULT 0,
  bonus DECIMAL(10,2) DEFAULT 0,
  ref_code TEXT UNIQUE,
  ref_by UUID REFERENCES users(id),
  refs_count INTEGER DEFAULT 0,
  status TEXT DEFAULT 'pending',
  kyc_id TEXT,
  kyc_status TEXT DEFAULT 'pending',
  join_date TIMESTAMPTZ DEFAULT NOW()
);

-- جدول سجل الأكواد
CREATE TABLE codes_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  code TEXT NOT NULL,
  profit_pct DECIMAL(3,1) NOT NULL,
  used BOOLEAN DEFAULT false,
  used_at TIMESTAMPTZ,
  slot INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول المعاملات
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  type TEXT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  network TEXT,
  status TEXT DEFAULT 'معلق',
  code_used TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول الإيداعات
CREATE TABLE deposits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  user_name TEXT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  network TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول السحوبات
CREATE TABLE withdrawals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  user_name TEXT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  wallet TEXT NOT NULL,
  network TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول الإعدادات
CREATE TABLE settings (
  id INTEGER PRIMARY KEY DEFAULT 1,
  tron_wallet TEXT,
  eth_wallet TEXT,
  support_email TEXT DEFAULT 'support@trendyol.invest',
  withdraw_fee DECIMAL(3,1) DEFAULT 6,
  min_withdraw DECIMAL(10,2) DEFAULT 50
);

-- جدول المديرين
CREATE TABLE admins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL
);

-- جدول سجل الجدولة
CREATE TABLE schedule_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date DATE NOT NULL,
  slot INTEGER NOT NULL,
  sent_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(date, slot)
);

-- إدراج إعدادات افتراضية
INSERT INTO settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING;

-- إدراج مدير افتراضي (كلمة المرور: admin123)
INSERT INTO admins (username, password) 
VALUES ('admin', 'admin123') 
ON CONFLICT (username) DO NOTHING;

-- إنشاء فهارس للأداء
CREATE INDEX idx_codes_user ON codes_log(user_id);
CREATE INDEX idx_codes_created ON codes_log(created_at);
CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_users_ref_by ON users(ref_by);
CREATE INDEX idx_users_status ON users(status);
```

#### 4. تفعيل Row Level Security (RLS)

في Supabase Dashboard:
1. اذهب إلى Authentication → Policies
2. فعّل RLS على جميع الجداول
3. أضف policies حسب الحاجة

---

## 🚀 أوامر سريعة للتشغيل

### للجزء الأول (SVG Converter):
```bash
# بناء المشروع
gradlew.bat build

# تشغيل مثال
java -jar build/libs/android_svg_code_render-1.5.0.jar test.svg -p com.example -c TestVector
```

### للجزء الثاني (Trendyol Platform):
```bash
# فتح مباشر
start index-50.html

# أو باستخدام خادم محلي
python -m http.server 8000
# ثم افتح: http://localhost:8000/index-50.html
```

---

## 🔍 استكشاف الأخطاء

### مشاكل Java:
```bash
# إذا ظهرت رسالة "JAVA_HOME is not set"
# على Windows:
set JAVA_HOME=C:\Program Files\Java\jdk-1.8.0_xxx

# على Linux/Mac:
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
```

### مشاكل Gradle:
```bash
# تنظيف المشروع وإعادة البناء
gradlew.bat clean build

# على Linux/Mac:
./gradlew clean build
```

### مشاكل Supabase:
- تأكد من تحديث URL و Key في `index-50.html`
- تأكد من إنشاء جميع الجداول
- تحقق من RLS policies
- راجع Console في المتصفح للأخطاء

---

## 📝 ملاحظات مهمة

1. **لأداة SVG**: تحتاج ملف SVG صالح كمدخل
2. **لمنصة Trendyol**: تحتاج إعداد Supabase أولاً
3. **الأمان**: كلمات المرور مخزنة كنص عادي (يُنصح بتشفيرها)
4. **البيئة**: يمكن تشغيل HTML مباشرة بدون خادم، لكن بعض الميزات قد تحتاج خادم

---

## 🎯 خطوات سريعة للبدء

### أداة SVG:
```bash
1. gradlew.bat build
2. java -jar build/libs/android_svg_code_render-1.5.0.jar yourfile.svg
```

### منصة Trendyol:
```bash
1. أنشئ مشروع Supabase
2. أنشئ الجداول (SQL أعلاه)
3. حدّث URL و Key في index-50.html
4. افتح index-50.html في المتصفح
5. سجّل حساب جديد أو استخدم admin/admin123
```

---

## 📞 الدعم

إذا واجهت مشاكل:
1. راجع Console في المتصفح (F12)
2. راجع ملف README.md الأصلي
3. راجع ملف ANALYSIS_AR.md للتحليل الكامل
