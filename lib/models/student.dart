class Student {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String nationalId;
  final String academicId;
  final String createdAt;
  final String updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.nationalId,
    required this.academicId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      nationalId: json['national_id'],
      academicId: json['academic_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'national_id': nationalId,
      'academic_id': academicId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
} 