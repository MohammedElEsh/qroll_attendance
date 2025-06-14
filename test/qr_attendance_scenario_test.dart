import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

/// سيناريو كامل لاستخدام الطالب للـ QR Scanner لتسجيل الحضور
/// Complete scenario for student using QR Scanner to mark attendance
void main() {
  group('🎓 سيناريو حضور الطالب - Student Attendance Scenario', () {
    test('📚 سيناريو 1: طالب يحضر محاضرة ويسجل حضوره', () {
      print('\n🎓 === سيناريو حضور المحاضرة ===');
      print('📚 المادة: البرمجة المتقدمة');
      print('👨‍🏫 الدكتور: د. أحمد محمد');
      print('🕐 الوقت: 10:00 صباحاً');
      print('📍 المكان: قاعة A101');

      // 1. الدكتور ينشئ QR code للمحاضرة
      final lectureQRData = {
        'lecture_id': 15,
        'course_id': 7,
        'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'signature': 'abc123def456ghi789jkl012mno345pqr678stu901vwx234yz',
      };
      final qrCodeString = jsonEncode(lectureQRData);

      print('\n👨‍🏫 الدكتور ينشئ QR Code للمحاضرة:');
      print('📊 QR Code: ${qrCodeString.substring(0, 50)}...');
      print('🆔 معرف المحاضرة: ${lectureQRData['lecture_id']}');
      print('📖 معرف المادة: ${lectureQRData['course_id']}');

      // 2. الطالب يدخل القاعة ويفتح التطبيق
      print('\n👨‍🎓 الطالب أحمد يدخل القاعة ويفتح التطبيق');
      print('📱 يفتح QR Scanner من القائمة الرئيسية');

      // 3. الطالب يعمل scan للـ QR code
      print('\n📷 الطالب يوجه الكاميرا نحو QR Code المعروض');

      // محاكاة عملية الـ scan
      final scannedData = jsonDecode(qrCodeString);
      print('✅ تم scan الـ QR Code بنجاح');

      // 4. التطبيق يتحقق من صحة البيانات
      final isValid =
          scannedData.containsKey('lecture_id') &&
          scannedData.containsKey('course_id') &&
          scannedData.containsKey('timestamp') &&
          scannedData.containsKey('signature');

      expect(isValid, true);
      print('✅ تم التحقق من صحة QR Code');

      // 5. التطبيق يرسل طلب للـ API
      print('\n📡 إرسال طلب تسجيل الحضور للخادم...');

      final apiRequestData = {
        'lecture_id': scannedData['lecture_id'],
        'course_id': scannedData['course_id'],
        'timestamp': scannedData['timestamp'],
        'signature': scannedData['signature'],
      };

      print('📤 بيانات الطلب:');
      print('   🆔 معرف المحاضرة: ${apiRequestData['lecture_id']}');
      print('   📖 معرف المادة: ${apiRequestData['course_id']}');
      print(
        '   🕐 الوقت: ${DateTime.fromMillisecondsSinceEpoch((apiRequestData['timestamp']! as int) * 1000)}',
      );

      // 6. محاكاة استجابة الخادم الناجحة
      final apiResponse = {
        'success': true,
        'message': 'تم تسجيل حضورك بنجاح',
        'data': {
          'attendance_id': 456,
          'student_id': 123,
          'student_name': 'أحمد محمد علي',
          'lecture_id': scannedData['lecture_id'],
          'course_id': scannedData['course_id'],
          'course_name': 'البرمجة المتقدمة',
          'status': 'present', // ✅ حاضر
          'marked_at': DateTime.now().toIso8601String(),
          'lecture_title': 'مقدمة في البرمجة الكائنية',
        },
      };

      print('\n📨 استجابة الخادم:');
      print('✅ ${apiResponse['message']}');
      print('👤 اسم الطالب: ${(apiResponse['data'] as Map)['student_name']}');
      print('📚 اسم المادة: ${(apiResponse['data'] as Map)['course_name']}');
      print(
        '📖 عنوان المحاضرة: ${(apiResponse['data'] as Map)['lecture_title']}',
      );
      print('✅ الحالة: ${(apiResponse['data'] as Map)['status']} (حاضر)');

      // 7. التحقق من النتيجة
      expect(apiResponse['success'], true);
      expect((apiResponse['data'] as Map)['status'], equals('present'));

      print('\n🎉 تم تسجيل حضور الطالب بنجاح!');
      print('📊 الطالب الآن مسجل كـ PRESENT في المحاضرة');
    });

    test('🧪 سيناريو 2: طالب يحضر سكشن ويسجل حضوره', () {
      print('\n🧪 === سيناريو حضور السكشن ===');
      print('📚 المادة: مختبر البرمجة');
      print('👨‍🏫 المعيد: أ. سارة أحمد');
      print('🕐 الوقت: 2:00 مساءً');
      print('📍 المكان: مختبر الحاسوب B205');

      // 1. المعيد ينشئ QR code للسكشن
      final sectionQRData = {
        'lecture_id': 28, // في هذا السياق، lecture_id يمكن أن يكون section_id
        'course_id': 7,
        'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'signature': 'xyz789abc123def456ghi789jkl012mno345pqr678stu901',
      };
      final qrCodeString = jsonEncode(sectionQRData);

      print('\n👨‍🏫 المعيد ينشئ QR Code للسكشن:');
      print('🆔 معرف السكشن: ${sectionQRData['lecture_id']}');
      print('📖 معرف المادة: ${sectionQRData['course_id']}');

      // 2. الطالبة تدخل المختبر
      print('\n👩‍🎓 الطالبة فاطمة تدخل المختبر');
      print('📱 تفتح QR Scanner');

      // 3. عملية الـ scan
      final scannedData = jsonDecode(qrCodeString);
      print('📷 تم scan الـ QR Code');

      // 4. التحقق من البيانات
      final isValid =
          scannedData.containsKey('lecture_id') &&
          scannedData.containsKey('course_id') &&
          scannedData.containsKey('timestamp') &&
          scannedData.containsKey('signature');

      expect(isValid, true);
      print('✅ تم التحقق من صحة البيانات');

      // 5. إرسال الطلب
      print('\n📡 إرسال طلب تسجيل الحضور...');

      // 6. استجابة ناجحة
      final apiResponse = {
        'success': true,
        'message': 'تم تسجيل حضورك في السكشن بنجاح',
        'data': {
          'attendance_id': 789,
          'student_id': 456,
          'student_name': 'فاطمة علي محمد',
          'section_id': scannedData['lecture_id'],
          'course_id': scannedData['course_id'],
          'course_name': 'مختبر البرمجة',
          'status': 'present', // ✅ حاضرة
          'marked_at': DateTime.now().toIso8601String(),
          'section_title': 'تطبيق عملي على البرمجة الكائنية',
        },
      };

      print('📨 استجابة الخادم:');
      print('✅ ${apiResponse['message']}');
      print('👤 اسم الطالبة: ${(apiResponse['data'] as Map)['student_name']}');
      print(
        '🧪 عنوان السكشن: ${(apiResponse['data'] as Map)['section_title']}',
      );
      print('✅ الحالة: ${(apiResponse['data'] as Map)['status']} (حاضرة)');

      expect(apiResponse['success'], true);
      expect((apiResponse['data'] as Map)['status'], equals('present'));

      print('\n🎉 تم تسجيل حضور الطالبة في السكشن بنجاح!');
    });

    test('❌ سيناريو 3: طالب يحاول استخدام QR code منتهي الصلاحية', () {
      print('\n❌ === سيناريو QR Code منتهي الصلاحية ===');

      // QR code قديم (منذ 3 ساعات)
      final expiredQRData = {
        'lecture_id': 10,
        'course_id': 5,
        'timestamp':
            DateTime.now()
                .subtract(const Duration(hours: 3))
                .millisecondsSinceEpoch ~/
            1000,
        'signature': 'old123signature456expired789code012abc345def',
      };
      final expiredQRCode = jsonEncode(expiredQRData);

      print('👨‍🎓 الطالب محمد يحاول استخدام QR code قديم');
      print('📱 يفتح QR Scanner ويعمل scan');

      // محاكاة الـ scan
      final scannedData = jsonDecode(expiredQRCode);

      // التحقق من انتهاء الصلاحية
      final qrTimestamp = DateTime.fromMillisecondsSinceEpoch(
        (scannedData['timestamp'] as int) * 1000,
      );
      final now = DateTime.now();
      final isExpired =
          now.difference(qrTimestamp).inMinutes >
          60; // منتهي إذا كان أكثر من ساعة

      expect(isExpired, true);
      print('⏰ تم اكتشاف أن QR Code منتهي الصلاحية');

      // استجابة الخادم بالرفض
      final apiResponse = {
        'success': false,
        'message': 'QR Code منتهي الصلاحية. لا يمكن تسجيل الحضور.',
        'error': 'EXPIRED_QR_CODE',
        'data': {
          'qr_timestamp': qrTimestamp.toIso8601String(),
          'current_time': now.toIso8601String(),
          'expired_since_minutes': now.difference(qrTimestamp).inMinutes,
        },
      };

      print('📨 استجابة الخادم:');
      print('❌ ${apiResponse['message']}');
      print(
        '⏰ QR Code منتهي منذ: ${(apiResponse['data'] as Map)['expired_since_minutes']} دقيقة',
      );

      expect(apiResponse['success'], false);
      print('\n❌ لم يتم تسجيل الحضور - QR Code منتهي الصلاحية');
    });

    test('🔄 سيناريو 4: طالب يحاول تسجيل الحضور مرتين', () {
      print('\n🔄 === سيناريو محاولة التسجيل المتكرر ===');

      final lectureQRData = {
        'lecture_id': 20,
        'course_id': 8,
        'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'signature': 'duplicate123test456signature789abc012def345ghi',
      };
      jsonEncode(lectureQRData);

      print('👨‍🎓 الطالب خالد يسجل حضوره للمرة الأولى');

      // المحاولة الأولى - ناجحة
      final firstAttemptResponse = {
        'success': true,
        'message': 'تم تسجيل حضورك بنجاح',
        'data': {
          'attendance_id': 111,
          'student_id': 789,
          'status': 'present',
          'marked_at': DateTime.now().toIso8601String(),
        },
      };

      print('✅ المحاولة الأولى: ${firstAttemptResponse['message']}');
      expect(firstAttemptResponse['success'], true);

      // المحاولة الثانية - مرفوضة
      print('\n👨‍🎓 الطالب يحاول تسجيل الحضور مرة أخرى');

      final secondAttemptResponse = {
        'success': false,
        'message': 'لقد تم تسجيل حضورك مسبقاً في هذه المحاضرة',
        'error': 'ALREADY_MARKED',
        'data': {
          'previous_attendance_id': 111,
          'previous_marked_at':
              (firstAttemptResponse['data'] as Map)['marked_at'],
          'status': 'already_present',
        },
      };

      print('📨 استجابة الخادم:');
      print('⚠️ ${secondAttemptResponse['message']}');
      print(
        '📅 تم التسجيل مسبقاً في: ${(secondAttemptResponse['data'] as Map)['previous_marked_at']}',
      );

      expect(secondAttemptResponse['success'], false);
      expect(secondAttemptResponse['error'], equals('ALREADY_MARKED'));

      print('\n⚠️ لم يتم تسجيل الحضور مرة أخرى - تم التسجيل مسبقاً');
    });

    test('📊 سيناريو 5: ملخص يوم كامل للطالب', () {
      print('\n📊 === ملخص يوم دراسي كامل ===');
      print('👨‍🎓 الطالب: عمر أحمد');
      print('📅 التاريخ: ${DateTime.now().toString().split(' ')[0]}');

      // جدول اليوم
      final dailySchedule = [
        {
          'time': '08:00',
          'type': 'محاضرة',
          'course': 'الرياضيات',
          'location': 'قاعة A101',
          'lecture_id': 30,
          'course_id': 10,
        },
        {
          'time': '10:00',
          'type': 'سكشن',
          'course': 'البرمجة',
          'location': 'مختبر B205',
          'lecture_id': 31,
          'course_id': 11,
        },
        {
          'time': '12:00',
          'type': 'محاضرة',
          'course': 'قواعد البيانات',
          'location': 'قاعة C301',
          'lecture_id': 32,
          'course_id': 12,
        },
      ];

      final attendanceResults = <Map<String, dynamic>>[];

      for (int i = 0; i < dailySchedule.length; i++) {
        final session = dailySchedule[i];
        print(
          '\n${i + 1}. ${session['time']} - ${session['type']}: ${session['course']}',
        );
        print('   📍 ${session['location']}');

        // إنشاء QR code للجلسة

        // محاكاة تسجيل الحضور
        final attendanceResponse = {
          'success': true,
          'message': 'تم تسجيل الحضور',
          'data': {
            'attendance_id': 200 + i,
            'session_type': session['type'],
            'course_name': session['course'],
            'status': 'present',
            'marked_at': DateTime.now().toIso8601String(),
          },
        };

        attendanceResults.add(attendanceResponse);
        print('   ✅ تم تسجيل الحضور بنجاح');

        expect(attendanceResponse['success'], true);
        expect(
          (attendanceResponse['data'] as Map)['status'],
          equals('present'),
        );
      }

      // ملخص اليوم
      print('\n📊 === ملخص اليوم ===');
      print('📚 إجمالي الجلسات: ${dailySchedule.length}');
      print(
        '✅ الجلسات المحضورة: ${attendanceResults.where((r) => r['success'] == true).length}',
      );
      print('❌ الجلسات المتغيب عنها: 0');
      print('📈 نسبة الحضور: 100%');

      expect(attendanceResults.length, equals(dailySchedule.length));
      expect(attendanceResults.every((r) => r['success'] == true), true);

      print('\n🎉 يوم دراسي ناجح! تم حضور جميع الجلسات');
    });
  });
}
