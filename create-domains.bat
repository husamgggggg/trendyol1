@echo off
chcp 65001 >nul
echo ========================================
echo   إنشاء ملفات للنطاقين
echo ========================================
echo.

REM التحقق من وجود الملف الأصلي
if not exist "index-50.html" (
    echo ❌ خطأ: الملف index-50.html غير موجود!
    pause
    exit /b 1
)

echo ✅ الملف الأصلي موجود
echo.

REM إنشاء نسخة للنطاق الأول
if exist "index-domain1.html" (
    echo ⚠️  الملف index-domain1.html موجود بالفعل
    set /p overwrite1="هل تريد استبداله؟ (y/n): "
    if /i "%overwrite1%"=="y" (
        copy /Y index-50.html index-domain1.html >nul
        echo ✅ تم إنشاء index-domain1.html
    ) else (
        echo ⏭️  تم تخطي index-domain1.html
    )
) else (
    copy /Y index-50.html index-domain1.html >nul
    echo ✅ تم إنشاء index-domain1.html
)

echo.

REM إنشاء نسخة للنطاق الثاني
if exist "index-domain2.html" (
    echo ⚠️  الملف index-domain2.html موجود بالفعل
    set /p overwrite2="هل تريد استبداله؟ (y/n): "
    if /i "%overwrite2%"=="y" (
        copy /Y index-50.html index-domain2.html >nul
        echo ✅ تم إنشاء index-domain2.html
    ) else (
        echo ⏭️  تم تخطي index-domain2.html
    )
) else (
    copy /Y index-50.html index-domain2.html >nul
    echo ✅ تم إنشاء index-domain2.html
)

echo.
echo ========================================
echo   الخطوات التالية:
echo ========================================
echo.
echo 1. افتح index-domain1.html
echo 2. ابحث عن: supabase.createClient
echo 3. حدّث بيانات Supabase للنطاق الأول
echo 4. افتح index-domain2.html
echo 5. حدّث بيانات Supabase للنطاق الثاني
echo 6. ارفع الملفات على النطاقين
echo.
echo ========================================
pause

