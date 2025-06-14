import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

/// اختبار تنسيق التاريخ الجديد
/// Test for new date format
void main() {
  group('📅 اختبار تنسيق التاريخ الجديد', () {
    test('✅ اختبار تنسيق التاريخ dd/MM/yyyy', () {
      print('\n📅 اختبار تنسيق التاريخ الجديد...');

      // تواريخ مختلفة للاختبار
      final testDates = [
        "2025-05-26T16:54:26.000000Z",
        "2025-05-28T00:34:11.000000Z",
        "2025-12-31T23:59:59.000000Z",
        "2025-01-01T00:00:00.000000Z",
      ];

      final expectedFormats = [
        "26/05/2025",
        "28/05/2025",
        "31/12/2025",
        "01/01/2025",
      ];

      for (int i = 0; i < testDates.length; i++) {
        final dateString = testDates[i];
        final expected = expectedFormats[i];

        print('\n🔍 اختبار التاريخ ${i + 1}:');
        print('   📊 التاريخ الخام: $dateString');

        final formatted = _formatDate(dateString);
        print('   📅 التاريخ المنسق: $formatted');
        print('   ✅ المتوقع: $expected');

        expect(formatted, equals(expected));
        print('   ✅ نجح الاختبار!');
      }

      print('\n✅ تم اختبار جميع التواريخ بنجاح!');
    });

    test('✅ اختبار عرض التاريخ في المحاضرات', () {
      print('\n📚 اختبار عرض التاريخ في المحاضرات...');

      // محاكاة API response للمحاضرات
      final lectureResponse = {
        "lecture": {
          "id": 1,
          "course_id": 2,
          "name": "lecture1",
          "created_at": "2025-05-26T16:54:26.000000Z",
          "updated_at": "2025-05-26T16:54:26.000000Z",
          "deleted_at": null,
        },
        "status": "Absent",
      };

      // استخراج التاريخ كما يحدث في التطبيق
      final lectureData = lectureResponse['lecture'] as Map<String, dynamic>;
      final lectureDate = lectureData['created_at']?.toString() ?? '';

      print('📊 التاريخ الخام: $lectureDate');

      final formattedDate = _formatDate(lectureDate);
      print('📅 التاريخ المعروض: $formattedDate');

      expect(formattedDate, equals('26/05/2025'));
      print('✅ التاريخ يظهر بالشكل الصحيح!');
    });

    test('✅ اختبار عرض التاريخ في السكاشن', () {
      print('\n🧪 اختبار عرض التاريخ في السكاشن...');

      // محاكاة API response للسكاشن
      final sectionResponse = {
        "section": {
          "id": 1,
          "course_id": 2,
          "name": "section1",
          "created_at": "2025-05-27T14:30:00.000000Z",
          "updated_at": "2025-05-27T14:30:00.000000Z",
          "deleted_at": null,
        },
        "status": "Present",
      };

      // استخراج التاريخ كما يحدث في التطبيق
      final sectionData = sectionResponse['section'] as Map<String, dynamic>;
      final sectionDate = sectionData['created_at']?.toString() ?? '';

      print('📊 التاريخ الخام: $sectionDate');

      final formattedDate = _formatDate(sectionDate);
      print('📅 التاريخ المعروض: $formattedDate');

      expect(formattedDate, equals('27/05/2025'));
      print('✅ التاريخ يظهر بالشكل الصحيح!');
    });

    test('✅ اختبار مقارنة التنسيق القديم والجديد', () {
      print('\n🔄 مقارنة التنسيق القديم والجديد...');

      final testDate = "2025-05-26T16:54:26.000000Z";

      // التنسيق القديم (May 26, 2025)
      final oldFormat = _formatDateOld(testDate);
      print('📅 التنسيق القديم: $oldFormat');

      // التنسيق الجديد (26/05/2025)
      final newFormat = _formatDate(testDate);
      print('📅 التنسيق الجديد: $newFormat');

      expect(oldFormat, equals('May 26, 2025'));
      expect(newFormat, equals('26/05/2025'));

      print('✅ كلا التنسيقين يعمل بشكل صحيح!');
      print('🎯 التنسيق الجديد أكثر إيجازاً وأوضح!');
    });

    test('❌ اختبار التعامل مع تواريخ خاطئة', () {
      print('\n❌ اختبار التعامل مع تواريخ خاطئة...');

      final invalidDates = [
        "not-a-date",
        "",
        "invalid-format",
        "2025/13/45", // تنسيق خاطئ
      ];

      for (final invalidDate in invalidDates) {
        print('\n🔍 اختبار التاريخ الخاطئ: "$invalidDate"');

        final result = _formatDate(invalidDate);
        print('📅 النتيجة: $result');

        // يجب أن يعيد التاريخ الأصلي في حالة الخطأ
        expect(result, equals(invalidDate));
        print('✅ تم التعامل مع الخطأ بشكل صحيح!');
      }

      print('\n✅ تم اختبار جميع الحالات الخاطئة بنجاح!');
    });

    test('📊 اختبار سيناريو كامل للعرض', () {
      print('\n📊 اختبار سيناريو كامل للعرض...');

      // محاكاة قائمة محاضرات كاملة
      final lecturesData = [
        {
          "lecture": {
            "id": 1,
            "name": "lecture1",
            "created_at": "2025-05-26T08:00:00.000000Z",
          },
          "status": "Present",
        },
        {
          "lecture": {
            "id": 2,
            "name": "lecture2",
            "created_at": "2025-05-28T10:00:00.000000Z",
          },
          "status": "Absent",
        },
        {
          "lecture": {
            "id": 3,
            "name": "lecture3",
            "created_at": "2025-05-30T14:00:00.000000Z",
          },
          "status": "Present",
        },
      ];

      print('📚 عرض قائمة المحاضرات:');
      print('=' * 40);

      for (int i = 0; i < lecturesData.length; i++) {
        final lecture = lecturesData[i] as Map<String, dynamic>;
        final lectureData = lecture['lecture'] as Map<String, dynamic>;
        final status = lecture['status'];

        final date = lectureData['created_at']?.toString() ?? '';
        final formattedDate = _formatDate(date);

        final statusIcon = status == 'Present' ? '✅' : '❌';

        print('${i + 1}. $formattedDate $statusIcon $status');

        // التحقق من صحة التنسيق
        expect(formattedDate, matches(r'^\d{2}/\d{2}/\d{4}$'));
      }

      print('=' * 40);
      print('✅ تم عرض جميع المحاضرات بالتنسيق الجديد!');
    });
  });
}

/// دالة تنسيق التاريخ الجديدة (dd/MM/yyyy)
String _formatDate(String dateString) {
  try {
    final DateTime date = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(date);
  } catch (e) {
    return dateString;
  }
}

/// دالة تنسيق التاريخ القديمة (MMM dd, yyyy)
String _formatDateOld(String dateString) {
  try {
    final DateTime date = DateTime.parse(dateString);
    return DateFormat('MMM dd, yyyy').format(date);
  } catch (e) {
    return dateString;
  }
}
