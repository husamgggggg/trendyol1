-- إصلاح RLS Policy للسماح للمسؤولين بإدراج أكواد
-- ============================================
-- انسخ هذا الكود والصقه في SQL Editor في Supabase Dashboard
-- ============================================

-- Policy للسماح للمسؤولين بإدراج أكواد
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

-- Policy للسماح للمسؤولين بتحديث أكواد
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

-- ============================================
-- بعد تنفيذ هذا الكود، يجب أن يعمل إرسال الأكواد بشكل صحيح
-- ============================================

