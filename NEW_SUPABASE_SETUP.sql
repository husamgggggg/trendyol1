-- ============================================
-- إعداد مشروع Supabase جديد - جميع الجداول و Policies
-- ============================================
-- انسخ هذا الملف والصقه في SQL Editor في Supabase Dashboard
-- ============================================

-- 1. إنشاء الجداول
-- ============================================

-- جدول المستخدمين
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT,
  kyc_id TEXT,
  kyc_status TEXT DEFAULT 'pending',
  status TEXT DEFAULT 'pending',
  balance NUMERIC DEFAULT 0,
  profit_bal NUMERIC DEFAULT 0,
  pending_profit NUMERIC DEFAULT 0,
  bonus NUMERIC DEFAULT 0,
  ref_code TEXT UNIQUE,
  ref_by UUID REFERENCES public.users(id),
  refs_count INTEGER DEFAULT 0,
  join_date TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول الإيداعات
CREATE TABLE IF NOT EXISTS public.deposits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  user_name TEXT,
  amount NUMERIC NOT NULL,
  network TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول السحوبات
CREATE TABLE IF NOT EXISTS public.withdrawals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  user_name TEXT,
  amount NUMERIC NOT NULL,
  wallet TEXT NOT NULL,
  network TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول المعاملات
CREATE TABLE IF NOT EXISTS public.transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  amount NUMERIC NOT NULL,
  network TEXT,
  status TEXT,
  code_used TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول الأكواد
CREATE TABLE IF NOT EXISTS public.codes_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  code TEXT NOT NULL,
  profit_pct NUMERIC,
  used BOOLEAN DEFAULT FALSE,
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول الإعدادات
CREATE TABLE IF NOT EXISTS public.settings (
  id INTEGER PRIMARY KEY DEFAULT 1,
  tron_wallet TEXT,
  eth_wallet TEXT,
  support_email TEXT DEFAULT 'noreply@trendyol-invest.com',
  withdraw_fee NUMERIC DEFAULT 6,
  min_withdraw NUMERIC DEFAULT 50,
  telegram_link TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول المسؤولين
CREATE TABLE IF NOT EXISTS public.admin_profiles (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. تفعيل RLS على جميع الجداول
-- ============================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.deposits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.withdrawals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.codes_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_profiles ENABLE ROW LEVEL SECURITY;

-- 3. إنشاء Policies
-- ============================================

-- Policies للمستخدمين
DROP POLICY IF EXISTS "Users can insert own profile" ON public.users;
CREATE POLICY "Users can insert own profile"
ON public.users FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = auth_user_id);

DROP POLICY IF EXISTS "Users can read own profile" ON public.users;
CREATE POLICY "Users can read own profile"
ON public.users FOR SELECT
TO authenticated
USING (auth.uid()::text = auth_user_id::text);

DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
CREATE POLICY "Users can update own profile"
ON public.users FOR UPDATE
TO authenticated
USING (auth.uid()::text = auth_user_id::text);

DROP POLICY IF EXISTS "Admins can read all users" ON public.users;
CREATE POLICY "Admins can read all users"
ON public.users FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

DROP POLICY IF EXISTS "Admins can update all users" ON public.users;
CREATE POLICY "Admins can update all users"
ON public.users FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

-- Policies للسحوبات
DROP POLICY IF EXISTS "Users can insert their own withdrawals" ON public.withdrawals;
CREATE POLICY "Users can insert their own withdrawals"
ON public.withdrawals FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.users
    WHERE users.id = withdrawals.user_id
    AND (
      users.auth_user_id = auth.uid()
      OR users.auth_user_id IS NULL
    )
  )
);

DROP POLICY IF EXISTS "Users can select their own withdrawals" ON public.withdrawals;
CREATE POLICY "Users can select their own withdrawals"
ON public.withdrawals FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users
    WHERE users.id = withdrawals.user_id
    AND (
      users.auth_user_id = auth.uid()
      OR users.auth_user_id IS NULL
    )
  )
);

DROP POLICY IF EXISTS "Admins can select all withdrawals" ON public.withdrawals;
CREATE POLICY "Admins can select all withdrawals"
ON public.withdrawals FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

DROP POLICY IF EXISTS "Admins can update all withdrawals" ON public.withdrawals;
CREATE POLICY "Admins can update all withdrawals"
ON public.withdrawals FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

-- Policies للإيداعات
DROP POLICY IF EXISTS "Users can insert own deposits" ON public.deposits;
CREATE POLICY "Users can insert own deposits"
ON public.deposits FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.users
    WHERE users.id = deposits.user_id
    AND (
      users.auth_user_id = auth.uid()
      OR users.auth_user_id IS NULL
    )
  )
);

DROP POLICY IF EXISTS "Users can select own deposits" ON public.deposits;
CREATE POLICY "Users can select own deposits"
ON public.deposits FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users
    WHERE users.id = deposits.user_id
    AND (
      users.auth_user_id = auth.uid()
      OR users.auth_user_id IS NULL
    )
  )
);

DROP POLICY IF EXISTS "Admins can select all deposits" ON public.deposits;
CREATE POLICY "Admins can select all deposits"
ON public.deposits FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

DROP POLICY IF EXISTS "Admins can update all deposits" ON public.deposits;
CREATE POLICY "Admins can update all deposits"
ON public.deposits FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

-- Policies للمعاملات
DROP POLICY IF EXISTS "Users can insert own transactions" ON public.transactions;
CREATE POLICY "Users can insert own transactions"
ON public.transactions FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.users
    WHERE users.id = transactions.user_id
    AND (
      users.auth_user_id = auth.uid()
      OR users.auth_user_id IS NULL
    )
  )
);

DROP POLICY IF EXISTS "Users can select own transactions" ON public.transactions;
CREATE POLICY "Users can select own transactions"
ON public.transactions FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users
    WHERE users.id = transactions.user_id
    AND (
      users.auth_user_id = auth.uid()
      OR users.auth_user_id IS NULL
    )
  )
);

-- Policies للأكواد
DROP POLICY IF EXISTS "Admins can insert codes" ON public.codes_log;
CREATE POLICY "Admins can insert codes"
ON public.codes_log FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

DROP POLICY IF EXISTS "Admins can update codes" ON public.codes_log;
CREATE POLICY "Admins can update codes"
ON public.codes_log FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

DROP POLICY IF EXISTS "Users can select own codes" ON public.codes_log;
CREATE POLICY "Users can select own codes"
ON public.codes_log FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.users
    WHERE users.id = codes_log.user_id
    AND (
      users.auth_user_id = auth.uid()
      OR users.auth_user_id IS NULL
    )
  )
);

DROP POLICY IF EXISTS "Admins can select all codes" ON public.codes_log;
CREATE POLICY "Admins can select all codes"
ON public.codes_log FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

-- Policies للإعدادات
DROP POLICY IF EXISTS "Everyone can read settings" ON public.settings;
CREATE POLICY "Everyone can read settings"
ON public.settings FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "Admins can update settings" ON public.settings;
CREATE POLICY "Admins can update settings"
ON public.settings FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.admin_profiles
    WHERE admin_profiles.user_id = auth.uid()
  )
);

-- Policies لـ admin_profiles
DROP POLICY IF EXISTS "Users can select own admin profile" ON public.admin_profiles;
CREATE POLICY "Users can select own admin profile"
ON public.admin_profiles FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- 4. إضافة إعدادات أولية
-- ============================================

INSERT INTO public.settings (id, tron_wallet, eth_wallet, support_email, withdraw_fee, min_withdraw)
VALUES (1, '', '', 'noreply@trendyol-invest.com', 6, 50)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- تم! الآن يمكنك:
-- 1. إنشاء مستخدم أدمن في Authentication > Users
-- 2. إضافة user_id في admin_profiles
-- 3. تحديث SB_URL و SB_ANON في admin.html
-- ============================================

