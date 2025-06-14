# 🔍 QR Scanner Test Suite

هذا الملف يحتوي على مجموعة شاملة من الاختبارات للتأكد من أن QR Scanner يعمل بشكل صحيح مع API الحضور.

## 📁 ملفات الاختبار

### 1. `qr_scanner_simple_test.dart` ⭐ (الأساسي)
**الاختبار الأسهل والأسرع للتشغيل**
```bash
flutter test test/qr_scanner_simple_test.dart
```

**ما يختبره:**
- ✅ إنشاء QR code صحيح
- ✅ التحقق من الحقول المطلوبة
- ✅ اكتشاف QR codes غير صحيحة
- ✅ تنسيق طلب API
- ✅ معالجة استجابات النجاح والفشل
- ✅ محاكاة تدفق الحضور الكامل
- ✅ التحقق من أن الطالب يُسجل **حاضر** وليس غائب

### 2. `qr_scanner_test.dart` (متقدم)
**اختبارات تفصيلية مع Mocking**
```bash
flutter test test/qr_scanner_test.dart
```

**ما يختبره:**
- 🔧 اختبارات مع Mock objects
- 🌐 محاكاة استجابات API مختلفة
- ❌ اختبار سيناريوهات الأخطاء
- 🔒 اختبار المصادقة والأمان

### 3. `qr_scanner_integration_test.dart` (تكامل)
**اختبارات التكامل مع UI**
```bash
flutter test integration_test/qr_scanner_integration_test.dart
```

**ما يختبره:**
- 📱 اختبار واجهة المستخدم
- 🎯 اختبار التفاعل مع الأزرار
- 📷 اختبار عناصر الكاميرا
- 🔄 اختبار التنقل بين الشاشات

## 🚀 كيفية تشغيل الاختبارات

### الاختبار السريع (مُوصى به للبداية)
```bash
flutter test test/qr_scanner_simple_test.dart -v
```

### تشغيل جميع الاختبارات
```bash
flutter test test/ -v
```

### تشغيل اختبار محدد
```bash
flutter test test/qr_scanner_simple_test.dart --name "Should create valid QR code"
```

## 📊 ما تتحقق منه الاختبارات

### ✅ QR Code Format
```json
{
  "lecture_id": 3,
  "course_id": 5,
  "timestamp": 1748440148,
  "signature": "93c28f6c0928804b6f5d628b6e7b35aba3494b7273ca690fe81d4"
}
```

### ✅ API Request Format
```
POST /student/attendance/scan
Headers:
  Authorization: Bearer <token>
  Accept: application/json
  Content-Type: multipart/form-data

Body (form-data):
  lecture_id: 3
  course_id: 5
  timestamp: 1748440148
  signature: 93c28f6c0928804b6f5d628b6e7b35aba3494b7273ca690fe81d4
```

### ✅ Success Response
```json
{
  "success": true,
  "message": "Attendance marked successfully",
  "data": {
    "attendance_id": 123,
    "status": "present"
  }
}
```

## 🎯 سيناريوهات الاختبار

### 1. ✅ الحضور الناجح
- طالب يعمل scan لـ QR code صحيح
- API يستجيب بنجاح
- الطالب يُسجل **حاضر** (present)

### 2. ❌ QR Code غير صحيح
- QR code مفقود حقول مطلوبة
- QR code ليس JSON صحيح
- QR code منتهي الصلاحية

### 3. 🔒 مشاكل المصادقة
- Token مفقود أو منتهي الصلاحية
- استجابة 401 Unauthorized

### 4. 🌐 مشاكل الشبكة
- انقطاع الاتصال
- Timeout
- خطأ في الخادم (500)

## 📈 نتائج الاختبار المتوقعة

عند تشغيل `qr_scanner_simple_test.dart` يجب أن ترى:

```
🧪 Testing QR Code Creation...
📊 Generated QR Code: {"lecture_id":3,"course_id":5,"timestamp":1748440148,"signature":"93c28f6c0928804b6f5d628b6e7b35aba3494b7273ca690fe81d4"}
✅ QR Code validation passed!

🧪 Testing Required Fields Validation...
✓ Field lecture_id: 3
✓ Field course_id: 5
✓ Field timestamp: 1748440148
✓ Field signature: 93c28f6c0928804b6f5d628b6e7b35aba3494b7273ca690fe81d4
✅ All required fields validation passed!

🧪 Testing Complete Attendance Flow...
1️⃣ QR Code generated
2️⃣ QR Code scanned and parsed
3️⃣ QR Code validation passed
4️⃣ API request prepared
5️⃣ API response received
✅ Complete attendance flow passed!
🎉 Student successfully marked as PRESENT (not absent)!

All tests passed! ✅
```

## 🔧 إضافة اختبارات جديدة

لإضافة اختبار جديد، أضف test case في أي من الملفات:

```dart
test('✅ Your new test description', () {
  print('\n🧪 Testing your feature...');
  
  // Your test code here
  expect(actualValue, expectedValue);
  
  print('✅ Your test passed!');
});
```

## 🐛 استكشاف الأخطاء

### إذا فشل اختبار:
1. **اقرأ رسالة الخطأ بعناية**
2. **تحقق من console logs**
3. **تأكد من أن API endpoint صحيح**
4. **تحقق من format البيانات**

### مشاكل شائعة:
- ❌ **Missing dependencies**: `flutter pub get`
- ❌ **Wrong API format**: تحقق من JSON structure
- ❌ **Network issues**: تحقق من الاتصال

## 📞 للمساعدة

إذا واجهت مشاكل في الاختبارات:
1. شغل الاختبار البسيط أولاً
2. تحقق من console output
3. تأكد من أن التطبيق يعمل بشكل طبيعي
4. راجع API documentation

---

**ملاحظة مهمة:** هذه الاختبارات تضمن أن QR Scanner يعمل بشكل صحيح وأن الطلاب يُسجلون **حاضرين** وليس غائبين عند عمل scan للـ QR code! 🎯
