-- إصلاح RLS Policy للسماح للمستخدمين بإنشاء profiles
-- ============================================
-- انسخ هذا الكود والصقه في SQL Editor في Supabase Dashboard
-- ============================================

-- Policy للسماح للمستخدمين بإدراج profiles الخاصة بهم
DROP POLICY IF EXISTS "Users can insert own profile" ON public.users;
CREATE POLICY "Users can insert own profile"
ON public.users FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = auth_user_id);

-- ============================================
-- بعد تنفيذ هذا الكود، يجب أن يعمل إنشاء الحساب بشكل صحيح
-- ============================================

