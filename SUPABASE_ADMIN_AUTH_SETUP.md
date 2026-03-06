# Supabase Admin Auth Setup

نفّذ هذه الخطوات مرة واحدة حتى يعمل دخول الأدمن بدون أي كلمة مرور ثابتة داخل `admin.html`.

## 1) أنشئ مستخدم الأدمن في Supabase Auth

- افتح `Supabase Dashboard`
- ادخل `Authentication` -> `Users`
- أنشئ مستخدمًا جديدًا، مثال:
  - البريد: `admin@trendyol-invest.com`
  - كلمة مرور قوية جدًا

## 2) نفّذ SQL التالي في `SQL Editor`

```sql
create table if not exists public.admin_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admin_profiles enable row level security;

drop policy if exists admin_profiles_select_own on public.admin_profiles;
create policy admin_profiles_select_own
on public.admin_profiles
for select
to authenticated
using (auth.uid() = user_id);
```

## 3) اربط مستخدم الأدمن بالجدول

بعد إنشاء مستخدم الأدمن، انسخ `User UID` الخاص به من صفحة `Authentication -> Users` ثم نفّذ:

```sql
insert into public.admin_profiles (user_id)
values ('PUT_ADMIN_AUTH_USER_ID_HERE')
on conflict (user_id) do nothing;
```

## 4) بعد التنفيذ

- صفحة الأدمن ستطلب:
  - البريد الإلكتروني
  - كلمة المرور
- سيتم التحقق عبر `Supabase Auth`
- لن تبقى كلمة مرور الأدمن مكشوفة داخل ملفات الواجهة

## ملاحظة

حقل `كلمة مرور جديدة للأدمن` داخل الإعدادات أصبح يغيّر كلمة مرور مستخدم الأدمن الحالي عبر `Supabase Auth`.

