# Supabase Edge Signup Setup

هذه الخطوات تنقل التسجيل من `DB.auth.signUp()` المباشر إلى `Edge Function` اسمها `register-user`.

## 1) ثبت Supabase CLI

```bash
npm install -g supabase
```

## 2) سجّل الدخول واربط المشروع

```bash
supabase login
supabase link --project-ref hnytoognlhubnopmgfay
```

## 3) انشر الوظيفة

من داخل مجلد المشروع:

```bash
cd "c:\Users\it 021\Desktop\trendyol"
supabase functions deploy register-user --no-verify-jwt
```

`--no-verify-jwt` مطلوب لأن صفحة التسجيل تستدعي الوظيفة قبل وجود جلسة مستخدم.

## 4) تأكد من متغيرات البيئة

في Supabase Dashboard:

- `Project Settings`
- `Edge Functions`
- `Secrets`

تأكد من وجود:

- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

عادة `SUPABASE_URL` موجود تلقائيًا. إذا احتجت إضافته:

```bash
supabase secrets set SUPABASE_URL=https://hnytoognlhubnopmgfay.supabase.co
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=YOUR_SERVICE_ROLE_KEY
```

## 5) ارفع ملفات الواجهة يدويًا

- ارفع `admin.html` إلى `public_html/admin.html`
- ارفع `android-svg-code-render-master/index-50.html` إلى `public_html/index.html`

ثم امسح الكاش:

- Hostinger: `Clear cache`
- Cloudflare: `Purge Everything`

## 6) اختبار سريع

بعد النشر:

- افتح صفحة التسجيل
- جرّب إنشاء حساب جديد
- في Network يجب أن ترى طلبًا إلى:

```text
https://hnytoognlhubnopmgfay.supabase.co/functions/v1/register-user
```

إذا نجح، سيُنشأ مستخدم `Auth` وصف في `public.users` ثم يتم تسجيل دخوله تلقائيًا.

## ملاحظة

هذا يلغي الاعتماد على `signup` المباشر من المتصفح، لكنه لا يغني عن حماية إضافية. للإنتاج يفضّل لاحقًا إضافة `Cloudflare Turnstile` أو أي CAPTCHA قبل استدعاء الوظيفة.

