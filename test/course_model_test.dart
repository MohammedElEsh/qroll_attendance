import 'package:flutter_test/flutter_test.dart';
import 'package:qroll_attendance/models/course.dart';

void main() {
  group('Course Model Tests', () {
    test('should parse API response correctly', () {
      // Sample data from your API response
      final Map<String, dynamic> apiResponse = {
        "id": 2,
        "name": "AI2",
        "doctor_id": 5,
        "teacher_id": 7,
        "created_at": "2025-05-25T18:15:06.000000Z",
        "updated_at": "2025-05-26T08:09:07.000000Z",
        "deleted_at": null,
        "pivot": {
          "student_id": 7,
          "course_id": 2
        }
      };

      // Parse the course
      final course = Course.fromJson(apiResponse);

      // Verify the parsing
      expect(course.id, equals('2'));
      expect(course.name, equals('AI2'));
      expect(course.doctorId, equals('5'));
      expect(course.teacherId, equals('7'));
      expect(course.displayName, equals('AI2'));
      expect(course.createdAt, isNotNull);
      expect(course.updatedAt, isNotNull);
    });

    test('should parse multiple courses from API array', () {
      // Sample array from your API response
      final List<Map<String, dynamic>> apiArray = [
        {
          "id": 2,
          "name": "AI2",
          "doctor_id": 5,
          "teacher_id": 7,
          "created_at": "2025-05-25T18:15:06.000000Z",
          "updated_at": "2025-05-26T08:09:07.000000Z",
          "deleted_at": null,
          "pivot": {
            "student_id": 7,
            "course_id": 2
          }
        },
        {
          "id": 4,
          "name": "yahya zakaria",
          "doctor_id": 6,
          "teacher_id": 8,
          "created_at": "2025-05-25T22:09:26.000000Z",
          "updated_at": "2025-05-25T22:09:26.000000Z",
          "deleted_at": null,
          "pivot": {
            "student_id": 7,
            "course_id": 4
          }
        }
      ];

      // Parse the courses
      final courses = apiArray.map((json) => Course.fromJson(json)).toList();

      // Verify the parsing
      expect(courses.length, equals(2));
      expect(courses[0].name, equals('AI2'));
      expect(courses[1].name, equals('yahya zakaria'));
      expect(courses[0].displayName, equals('AI2'));
      expect(courses[1].displayName, equals('yahya zakaria'));
    });

    test('should handle missing fields gracefully', () {
      // Minimal course data
      final Map<String, dynamic> minimalData = {
        "id": 1,
        "name": "Test Course"
      };

      // Parse the course
      final course = Course.fromJson(minimalData);

      // Verify the parsing
      expect(course.id, equals('1'));
      expect(course.name, equals('Test Course'));
      expect(course.doctorId, isNull);
      expect(course.teacherId, isNull);
      expect(course.displayName, equals('Test Course'));
    });
  });
}
