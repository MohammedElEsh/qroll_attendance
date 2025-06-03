/// User Profile Model
/// 
/// This model represents the user profile data structure
/// and provides methods to convert from/to JSON format
class UserProfile {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? nationalId;
  final String? academicId;
  final String? birthDate;
  final String? address;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.nationalId,
    this.academicId,
    this.birthDate,
    this.address,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor to create UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      nationalId: json['national_id']?.toString(),
      academicId: json['academic_id']?.toString(),
      birthDate: json['birth_date']?.toString(),
      address: json['address']?.toString(),
      image: json['image']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  /// Convert UserProfile to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'national_id': nationalId,
      'academic_id': academicId,
      'birth_date': birthDate,
      'address': address,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy of UserProfile with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? nationalId,
    String? academicId,
    String? birthDate,
    String? address,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      academicId: academicId ?? this.academicId,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if the profile is complete
  bool get isComplete {
    return name != null &&
        email != null &&
        phone != null &&
        nationalId != null;
  }

  /// Get display name (fallback to email if name is not available)
  String get displayName {
    return name?.isNotEmpty == true ? name! : email ?? 'مستخدم';
  }

  /// Format phone number for display
  String? get formattedPhone {
    if (phone == null || phone!.isEmpty) return null;

    // Simple formatting for Egyptian phone numbers
    if (phone!.startsWith('+20')) {
      return phone;
    } else if (phone!.startsWith('01')) {
      return '+20${phone!}';
    }
    return phone;
  }

  /// Format birth date for display
  String? get formattedBirthDate {
    if (birthDate == null || birthDate!.isEmpty) return null;

    try {
      final date = DateTime.parse(birthDate!);
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (e) {
      // If parsing fails, return the original string
      return birthDate;
    }
  }

  @override
  String toString() {
    return 'UserProfile{'
        'id: $id, '
        'name: $name, '
        'email: $email, '
        'phone: $phone, '
        'nationalId: $nationalId, '
        'academicId: $academicId, '
        'birthDate: $birthDate, '
        'address: $address'
        '}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.nationalId == nationalId &&
        other.academicId == academicId &&
        other.birthDate == birthDate &&
        other.address == address;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      phone,
      nationalId,
      academicId,
      birthDate,
      address,
    );
  }
}