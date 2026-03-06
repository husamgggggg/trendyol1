# Supabase User Auth Migration

هذه الخطوات مطلوبة لنقل دخول المستخدمين من كلمة مرور نصية داخل جدول `users` إلى `Supabase Auth` بشكل تدريجي.

## 1) نفّذ SQL التالي مرة واحدة

```sql
alter table public.users
  add column if not exists auth_user_id uuid;

create unique index if not exists users_auth_user_id_uidx
  on public.users(auth_user_id)
  where auth_user_id is not null;
```

## 2) ملاحظة مهمة

- التسجيلات الجديدة ستُنشئ حسابًا في `Supabase Auth`
- ثم تربط صف المستخدم في `public.users` عبر `auth_user_id`
- الحسابات القديمة ستبقى مدعومة مؤقتًا، وسيحاول النظام ربطها تلقائيًا عند تسجيل الدخول

## 3) تحسين أمني لاحق

بعد التأكد أن جميع المستخدمين صاروا يدخلون عبر `Supabase Auth`:

- يمكن حذف الاعتماد على عمود `password` من منطق التطبيق
- ويمكن لاحقًا تنظيف كلمات المرور القديمة من جدول `users`

