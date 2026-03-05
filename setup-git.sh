#!/bin/bash

# سكريبت إعداد Git ورفع المشروع
# استخدام: ./setup-git.sh

set -e

REPO="husamgggggg/trendyol1"

echo "🔧 إعداد Git للمشروع..."

# التحقق من وجود Git
if ! command -v git &> /dev/null; then
    echo "❌ Git غير مثبت"
    echo "📥 تثبيت Git..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install -y git
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install git
    else
        echo "❌ يرجى تثبيت Git يدوياً من: https://git-scm.com/downloads"
        exit 1
    fi
fi

# تهيئة Git إذا لم يكن موجوداً
if [ ! -d ".git" ]; then
    echo "🔧 تهيئة Git repository..."
    git init
    git branch -M main
    
    # إضافة remote
    git remote add origin https://github.com/${REPO}.git 2>/dev/null || \
    git remote set-url origin https://github.com/${REPO}.git
    
    echo "✅ تم تهيئة Git"
else
    echo "✅ Git repository موجود بالفعل"
fi

# إضافة جميع الملفات
echo "📝 إضافة الملفات..."
git add .

# Commit
echo "💾 حفظ التغييرات..."
git commit -m "Initial commit: Trendyol Investment Platform" || echo "⚠️  لا توجد تغييرات جديدة"

echo ""
echo "✅ تم إعداد Git بنجاح!"
echo ""
echo "الخطوات التالية:"
echo "1. تأكد من إنشاء المستودع على GitHub:"
echo "   https://github.com/new"
echo "   اسم المستودع: trendyol1"
echo ""
echo "2. ثم شغّل:"
echo "   ./push-to-github.sh"
echo ""
echo "أو ارفع يدوياً:"
echo "   git push -u origin main"

