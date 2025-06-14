import 'package:flutter_test/flutter_test.dart';

/// اختبار عرض التاريخ في صفحات الحضور
/// Test for displaying dates in attendance screens
void main() {
  group('📅 اختبار عرض التاريخ في صفحات الحضور', () {
    test('✅ اختبار تنسيق API response للمحاضرات', () {
      print('\n📚 اختبار بيانات المحاضرات...');

      // محاكاة API response للمحاضرات (كما هو مرسل من الخادم)
      final lecturesResponse = [
        {
          "lecture": {
            "id": 1,
            "course_id": 2,
            "name": "lecture1",
            "created_at": "2025-05-26T16:54:26.000000Z",
            "updated_at": "2025-05-26T16:54:26.000000Z",
            "deleted_at": null,
          },
          "status": "Absent",
        },
        {
          "lecture": {
            "id": 2,
            "course_id": 2,
            "name": "lecture2",
            "created_at": "2025-05-28T00:34:11.000000Z",
            "updated_at": "2025-05-28T00:34:11.000000Z",
            "deleted_at": null,
          },
          "status": "Present",
        },
      ];

      print('📊 عدد المحاضرات: ${lecturesResponse.length}');

      for (int i = 0; i < lecturesResponse.length; i++) {
        final lecture = lecturesResponse[i] as Map<String, dynamic>;
        final lectureData = lecture['lecture'] as Map<String, dynamic>;

        print('\n📖 المحاضرة ${i + 1}:');
        print('   🆔 ID: ${lectureData['id']}');
        print('   📚 الاسم: ${lectureData['name']}');
        print('   📅 التاريخ: ${lectureData['created_at']}');
        print('   ✅ الحالة: ${lecture['status']}');

        // التحقق من وجود البيانات المطلوبة
        expect(lectureData['id'], isNotNull);
        expect(lectureData['name'], isNotNull);
        expect(lectureData['created_at'], isNotNull);
        expect(lecture['status'], isNotNull);

        // التحقق من تنسيق التاريخ
        final dateString = lectureData['created_at'] as String;
        expect(dateString, contains('T')); // ISO format
        expect(dateString, contains('Z')); // UTC timezone

        // محاولة تحويل التاريخ
        final parsedDate = DateTime.parse(dateString);
        expect(parsedDate, isA<DateTime>());

        print('   📅 التاريخ المحول: ${parsedDate.toString()}');
        print('   📅 التاريخ المنسق: ${_formatDate(dateString)}');
      }

      print('\n✅ تم اختبار بيانات المحاضرات بنجاح!');
    });

    test('✅ اختبار تنسيق API response للسكاشن', () {
      print('\n🧪 اختبار بيانات السكاشن...');

      // محاكاة API response للسكاشن (نفس التنسيق المتوقع)
      final sectionsResponse = [
        {
          "section": {
            "id": 1,
            "course_id": 2,
            "name": "section1",
            "created_at": "2025-05-26T14:30:00.000000Z",
            "updated_at": "2025-05-26T14:30:00.000000Z",
            "deleted_at": null,
          },
          "status": "Present",
        },
        {
          "section": {
            "id": 2,
            "course_id": 2,
            "name": "section2",
            "created_at": "2025-05-27T10:15:00.000000Z",
            "updated_at": "2025-05-27T10:15:00.000000Z",
            "deleted_at": null,
          },
          "status": "Absent",
        },
      ];

      print('📊 عدد السكاشن: ${sectionsResponse.length}');

      for (int i = 0; i < sectionsResponse.length; i++) {
        final section = sectionsResponse[i] as Map<String, dynamic>;
        final sectionData = section['section'] as Map<String, dynamic>;

        print('\n🧪 السكشن ${i + 1}:');
        print('   🆔 ID: ${sectionData['id']}');
        print('   📚 الاسم: ${sectionData['name']}');
        print('   📅 التاريخ: ${sectionData['created_at']}');
        print('   ✅ الحالة: ${section['status']}');

        // التحقق من وجود البيانات المطلوبة
        expect(sectionData['id'], isNotNull);
        expect(sectionData['name'], isNotNull);
        expect(sectionData['created_at'], isNotNull);
        expect(section['status'], isNotNull);

        // التحقق من تنسيق التاريخ
        final dateString = sectionData['created_at'] as String;
        final parsedDate = DateTime.parse(dateString);
        expect(parsedDate, isA<DateTime>());

        print('   📅 التاريخ المحول: ${parsedDate.toString()}');
        print('   📅 التاريخ المنسق: ${_formatDate(dateString)}');
      }

      print('\n✅ تم اختبار بيانات السكاشن بنجاح!');
    });

    test('📊 اختبار عرض البيانات في التطبيق', () {
      print('\n📱 اختبار عرض البيانات في التطبيق...');

      final lectureData = {
        "lecture": {
          "id": 1,
          "course_id": 2,
          "name": "مقدمة في البرمجة",
          "created_at": "2025-05-26T16:54:26.000000Z",
          "updated_at": "2025-05-26T16:54:26.000000Z",
          "deleted_at": null,
        },
        "status": "Present",
      };

      // محاكاة استخراج البيانات كما يحدث في التطبيق
      final lecture = lectureData['lecture'] as Map<String, dynamic>;
      final lectureName = lecture['name']?.toString() ?? 'Lecture 1';
      final lectureDate = lecture['created_at']?.toString() ?? '';
      final attendanceStatus = lectureData['status']?.toString() ?? 'Unknown';

      print('📖 اسم المحاضرة: $lectureName');
      print('📅 تاريخ المحاضرة: ${_formatDate(lectureDate)}');
      print('✅ حالة الحضور: $attendanceStatus');

      // التحقق من البيانات
      expect(lectureName, equals('مقدمة في البرمجة'));
      expect(attendanceStatus, equals('Present'));
      expect(lectureDate, isNotEmpty);

      // التحقق من تنسيق التاريخ
      final formattedDate = _formatDate(lectureDate);
      expect(formattedDate, isNotEmpty);
      expect(
        formattedDate,
        isNot(equals(lectureDate)),
      ); // يجب أن يكون مختلف عن التاريخ الخام

      print('\n✅ تم اختبار عرض البيانات بنجاح!');
    });

    test('🎨 اختبار ألوان حالة الحضور', () {
      print('\n🎨 اختبار ألوان حالة الحضور...');

      final attendanceStatuses = [
        {'status': 'Present', 'expectedColor': 'green'},
        {'status': 'Absent', 'expectedColor': 'red'},
        {'status': 'Late', 'expectedColor': 'orange'},
        {'status': 'Unknown', 'expectedColor': 'grey'},
      ];

      for (final statusData in attendanceStatuses) {
        final status = statusData['status']!;
        final expectedColor = statusData['expectedColor']!;

        // محاكاة منطق تحديد اللون
        String actualColor;
        switch (status.toLowerCase()) {
          case 'present':
          case 'attended':
            actualColor = 'green';
            break;
          case 'absent':
          case 'missed':
            actualColor = 'red';
            break;
          case 'late':
            actualColor = 'orange';
            break;
          default:
            actualColor = 'grey';
        }

        print('✅ الحالة: $status → اللون: $actualColor');
        expect(actualColor, equals(expectedColor));
      }

      print('\n✅ تم اختبار ألوان الحضور بنجاح!');
    });

    test('📅 اختبار تنسيقات التاريخ المختلفة', () {
      print('\n📅 اختبار تنسيقات التاريخ المختلفة...');

      final dateFormats = [
        "2025-05-26T16:54:26.000000Z",
        "2025-05-26T16:54:26Z",
        "2025-05-26 16:54:26",
        "2025-05-26",
      ];

      for (final dateString in dateFormats) {
        print('🔍 اختبار التاريخ: $dateString');

        try {
          final formattedDate = _formatDate(dateString);
          print('   ✅ التاريخ المنسق: $formattedDate');
          expect(formattedDate, isNotEmpty);
        } catch (e) {
          print('   ❌ خطأ في تنسيق التاريخ: $e');
          // في حالة الخطأ، يجب أن يعيد التاريخ الأصلي
          final fallbackDate = _formatDate(dateString);
          expect(fallbackDate, equals(dateString));
        }
      }

      print('\n✅ تم اختبار تنسيقات التاريخ بنجاح!');
    });

    test('🔄 اختبار سيناريو كامل للحضور', () {
      print('\n🔄 اختبار سيناريو كامل للحضور...');

      // محاكاة استجابة API كاملة
      final fullResponse = {
        "status": 200,
        "message": "Lectures attendance retrieved successfully",
        "data": [
          {
            "lecture": {
              "id": 1,
              "course_id": 2,
              "name": "المحاضرة الأولى - مقدمة",
              "created_at": "2025-05-26T08:00:00.000000Z",
              "updated_at": "2025-05-26T08:00:00.000000Z",
              "deleted_at": null,
            },
            "status": "Present",
          },
          {
            "lecture": {
              "id": 2,
              "course_id": 2,
              "name": "المحاضرة الثانية - المتغيرات",
              "created_at": "2025-05-28T10:00:00.000000Z",
              "updated_at": "2025-05-28T10:00:00.000000Z",
              "deleted_at": null,
            },
            "status": "Absent",
          },
          {
            "lecture": {
              "id": 3,
              "course_id": 2,
              "name": "المحاضرة الثالثة - الدوال",
              "created_at": "2025-05-30T08:00:00.000000Z",
              "updated_at": "2025-05-30T08:00:00.000000Z",
              "deleted_at": null,
            },
            "status": "Present",
          },
        ],
      };

      final lectures = fullResponse['data'] as List;
      print('📊 إجمالي المحاضرات: ${lectures.length}');

      int presentCount = 0;
      int absentCount = 0;

      for (int i = 0; i < lectures.length; i++) {
        final lecture = lectures[i];
        final lectureData = lecture['lecture'];
        final status = lecture['status'];

        print('\n📖 المحاضرة ${i + 1}:');
        print('   📚 ${lectureData['name']}');
        print('   📅 ${_formatDate(lectureData['created_at'])}');
        print('   ${status == 'Present' ? '✅' : '❌'} $status');

        if (status == 'Present') {
          presentCount++;
        } else {
          absentCount++;
        }
      }

      final attendancePercentage =
          (presentCount / lectures.length * 100).round();

      print('\n📊 === ملخص الحضور ===');
      print('✅ المحاضرات المحضورة: $presentCount');
      print('❌ المحاضرات المتغيب عنها: $absentCount');
      print('📈 نسبة الحضور: $attendancePercentage%');

      expect(presentCount, equals(2));
      expect(absentCount, equals(1));
      expect(attendancePercentage, equals(67));

      print('\n✅ تم اختبار السيناريو الكامل بنجاح!');
    });
  });
}

/// دالة تنسيق التاريخ (نسخة من التطبيق)
String _formatDate(String dateString) {
  try {
    final DateTime date = DateTime.parse(dateString);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  } catch (e) {
    return dateString;
  }
}
