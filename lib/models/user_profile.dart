class UserProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String nationalId;
  final String birthDate;
  final String address;
  final String? image;
  final int roleId;
  final String roleName;
  final String academicId;
  final String createdAt;
  final String updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.nationalId,
    required this.birthDate,
    required this.address,
    this.image,
    required this.roleId,
    required this.roleName,
    required this.academicId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      nationalId: json['national_id'],
      birthDate: json['birth_date'],
      address: json['address'],
      image: json['image'],
      roleId: json['role_id'],
      roleName: json['role_name'],
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
      'birth_date': birthDate,
      'address': address,
      'image': image,
      'role_id': roleId,
      'role_name': roleName,
      'academic_id': academicId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
} 