# أوامر Flutter السريعة لتطبيق المساعد الصحي

## 🚀 أوامر البناء والتشغيل

### تشغيل التطبيق
```bash
# تشغيل في وضع التطوير
flutter run

# تشغيل على جهاز محدد
flutter run -d <device_id>

# تشغيل في وضع الإصدار (للاختبار)
flutter run --release
```

### بناء التطبيق
```bash
# بناء APK للأندرويد
flutter build apk

# بناء APK للإصدار النهائي
flutter build apk --release

# بناء APK منقسم حسب المعمارية
flutter build apk --split-per-abi

# بناء App Bundle (للنشر في Google Play)
flutter build appbundle --release

# بناء للـ iOS
flutter build ios --release
```

## 🔧 أوامر إدارة المشروع

### إدارة التبعيات
```bash
# تثبيت التبعيات الجديدة
flutter pub get

# تحديث التبعيات
flutter pub upgrade

# تنظيف المشروع
flutter clean

# تنظيف وإعادة تثبيت
flutter clean && flutter pub get

# تحديث Flutter SDK
flutter upgrade
```

### الأجهزة والمحاكي
```bash
# عرض الأجهزة المتاحة
flutter devices

# تشغيل المحاكي
flutter emulators --launch <emulator_id>

# إنشاء محاكي جديد
flutter emulators --create --name <name>

# قائمة المحاكيات
flutter emulators
```

## 🧪 الاختبار والجودة

### تشغيل الاختبارات
```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل الاختبارات مع التغطية
flutter test --coverage

# تشغيل اختبارات محددة
flutter test test/bmi_calculator_test.dart

# تشغيل اختبارات التكامل
flutter test integration_test/
```

### تحليل الكود
```bash
# تحليل الكود بحثاً عن المشاكل
flutter analyze

# إصلاح المشاكل التلقائية
flutter fix --dry-run  # للمعاينة
flutter fix --apply    # للتطبيق

# تنسيق الكود
flutter format lib/
```

## 📱 أوامر النشر

### Google Play Store
```bash
# بناء App Bundle للنشر
flutter build appbundle --release

# إنشاء مفتاح التوقيع (مرة واحدة)
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# بناء مع مفتاح التوقيع
flutter build appbundle --release --keystore-path=upload-keystore.jks --keystore-password=<password> --key-password=<key-password> --key-alias=upload
```

### App Store (iOS)
```bash
# بناء للـ iOS
flutter build ios --release

# أرشفة المشروع
xcodebuild -workspace Runner.xcworkspace -scheme Runner archive

# تصدير للنشر
xcodebuild -exportArchive -archivePath Runner.xcarchive -exportPath . -exportOptionsPlist ExportOptions.plist
```

## 🔍 أوامر التصحيح والتطوير

### أدوات Flutter
```bash
# تشغيل Flutter Inspector
flutter run --debug

# عرض معلومات الجهاز
flutter doctor

# عرض معلومات المشروع
flutter doctor --verbose

# تحديث المكونات
flutter doctor --android-licenses
```

### إدارة الإصدارات
```bash
# تحديث إصدار التطبيق
flutter build apk --build-number=<number> --build-name=<version>

# إنشاء علامات Git للإصدارات
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin --tags
```

## 💾 أوامر قاعدة البيانات

### إدارة Shared Preferences
```bash
# مسح بيانات التطبيق (للاختبار)
adb shell pm clear com.example.app_1

# الوصول لمجلد البيانات
adb shell run-as com.example.app_1 ls /data/data/com.example.app_1/
```

## 🔐 أوامر الأمان

### إدارة المفاتيح
```bash
# إنشاء مفتاح للتوقيع
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# التحقق من المفتاح
keytool -list -v -keystore key.jks

# تصدير الشهادة
keytool -export -keystore key.jks -alias key -file certificate.pem
```

## 📊 أوامر الأداء والتحسين

### تحليل الأداء
```bash
# تشغيل مع تتبع الأداء
flutter run --profile

# إنشاء تقرير الأداء
flutter build apk --analyze-size

# تحليل الذاكرة
flutter run --dart-define=FLUTTER_MEMORY_DEBUG=true
```

### تحسين الحجم
```bash
# بناء مع الضغط
flutter build apk --obfuscate --split-debug-info=debug-info/

# إزالة الرموز غير المستخدمة
flutter build apk --tree-shake-icons

# ضغط الصور
flutter build apk --shrink
```

## 🚨 أوامر الطوارئ

### إصلاح المشاكل الشائعة
```bash
# إعادة إنشاء ملفات Android
flutter create . --platforms=android

# إعادة إنشاء ملفات iOS
flutter create . --platforms=ios

# إصلاح مشاكل Gradle
cd android && ./gradlew clean && cd ..

# إصلاح مشاكل CocoaPods
cd ios && pod install && cd ..
```

### تنظيف شامل
```bash
# تنظيف شامل للمشروع
flutter clean
flutter pub cache clean
rm -rf .dart_tool/
rm -rf build/
rm -rf android/.gradle/
flutter pub get
flutter run
```

---

## 💡 نصائح للمطورين

1. **استخدم `flutter doctor` بانتظام** للتحقق من سلامة البيئة
2. **احفظ العمل بانتظام** مع رسائل commit واضحة
3. **اختبر على أجهزة حقيقية** وليس المحاكي فقط
4. **استخدم Git Flow** لإدارة الفروع والإصدارات
5. **تابع أحدث إصدارات Flutter** للحصول على المميزات الجديدة
6. **استخدم `.env` files** للمفاتيح الحساسة وليس الكود
7. **اكتب اختبارات** للمميزات الجديدة
8. **استخدم Flutter Inspector** لتحليل واجهات المستخدم

---

**🎯 للمزيد من المعلومات، راجع:**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter CLI Reference](https://docs.flutter.dev/reference/flutter-cli)
- [Dart Documentation](https://dart.dev/guides)
