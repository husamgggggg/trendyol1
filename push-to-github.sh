#!/bin/bash

# سكريبت رفع المشروع إلى GitHub
# استخدام: ./push-to-github.sh

set -e

REPO="husamgggggg/trendyol1"
GITHUB_URL="https://github.com/${REPO}.git"

echo "📤 رفع المشروع إلى GitHub..."

# التحقق من وجود Git
if ! command -v git &> /dev/null; then
    echo "❌ Git غير مثبت. يرجى تثبيته أولاً"
    exit 1
fi

# التحقق من وجود .git
if [ ! -d ".git" ]; then
    echo "🔧 تهيئة Git repository..."
    git init
    git branch -M main
fi

# إضافة remote إذا لم يكن موجوداً
if ! git remote | grep -q "origin"; then
    echo "🔗 إضافة remote repository..."
    git remote add origin ${GITHUB_URL}
else
    echo "🔄 تحديث remote repository..."
    git remote set-url origin ${GITHUB_URL}
fi

# إضافة جميع الملفات
echo "📝 إضافة الملفات..."
git add .

# Commit
echo "💾 حفظ التغييرات..."
git commit -m "Initial commit: Trendyol Investment Platform" || echo "⚠️  لا توجد تغييرات جديدة"

# رفع إلى GitHub
echo "🚀 رفع إلى GitHub..."
git push -u origin main || {
    echo "❌ فشل الرفع. قد تحتاج إلى:"
    echo "   1. إنشاء المستودع على GitHub أولاً"
    echo "   2. إعداد المصادقة (SSH key أو Personal Access Token)"
    echo ""
    echo "لإنشاء المستودع يدوياً:"
    echo "   - اذهب إلى: https://github.com/new"
    echo "   - اسم المستودع: trendyol1"
    echo "   - لا تضع README أو .gitignore (موجودان بالفعل)"
    exit 1
}

echo "✅ تم رفع المشروع بنجاح إلى GitHub!"
echo "🌐 المستودع: https://github.com/${REPO}"

