#!/bin/bash

echo "========================================"
echo "  إنشاء ملفات للنطاقين"
echo "========================================"
echo ""

# التحقق من وجود الملف الأصلي
if [ ! -f "index-50.html" ]; then
    echo "❌ خطأ: الملف index-50.html غير موجود!"
    exit 1
fi

echo "✅ الملف الأصلي موجود"
echo ""

# إنشاء نسخة للنطاق الأول
if [ -f "index-domain1.html" ]; then
    read -p "⚠️  الملف index-domain1.html موجود بالفعل. هل تريد استبداله؟ (y/n): " overwrite1
    if [ "$overwrite1" = "y" ] || [ "$overwrite1" = "Y" ]; then
        cp index-50.html index-domain1.html
        echo "✅ تم إنشاء index-domain1.html"
    else
        echo "⏭️  تم تخطي index-domain1.html"
    fi
else
    cp index-50.html index-domain1.html
    echo "✅ تم إنشاء index-domain1.html"
fi

echo ""

# إنشاء نسخة للنطاق الثاني
if [ -f "index-domain2.html" ]; then
    read -p "⚠️  الملف index-domain2.html موجود بالفعل. هل تريد استبداله؟ (y/n): " overwrite2
    if [ "$overwrite2" = "y" ] || [ "$overwrite2" = "Y" ]; then
        cp index-50.html index-domain2.html
        echo "✅ تم إنشاء index-domain2.html"
    else
        echo "⏭️  تم تخطي index-domain2.html"
    fi
else
    cp index-50.html index-domain2.html
    echo "✅ تم إنشاء index-domain2.html"
fi

echo ""
echo "========================================"
echo "  الخطوات التالية:"
echo "========================================"
echo ""
echo "1. افتح index-domain1.html"
echo "2. ابحث عن: supabase.createClient"
echo "3. حدّث بيانات Supabase للنطاق الأول"
echo "4. افتح index-domain2.html"
echo "5. حدّث بيانات Supabase للنطاق الثاني"
echo "6. ارفع الملفات على النطاقين"
echo ""
echo "========================================"

