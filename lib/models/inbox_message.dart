class InboxMessage {
  final int id;
  final int senderId;
  final String senderName;
  final String senderRole;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final String? subject;

  const InboxMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.subject,
  });

  /// Create InboxMessage from JSON response
  factory InboxMessage.fromJson(Map<String, dynamic> json) {
    return InboxMessage(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      senderName: json['sender_name'] ?? 'Unknown',
      senderRole: json['sender_role'] ?? 'User',
      message: json['message'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isRead: json['is_read'] ?? false,
      subject: json['subject'],
    );
  }

  /// Convert InboxMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_role': senderRole,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'subject': subject,
    };
  }

  /// Create a copy of this message with updated fields
  InboxMessage copyWith({
    int? id,
    int? senderId,
    String? senderName,
    String? senderRole,
    String? message,
    DateTime? createdAt,
    bool? isRead,
    String? subject,
  }) {
    return InboxMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderRole: senderRole ?? this.senderRole,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      subject: subject ?? this.subject,
    );
  }

  /// Get formatted date string for display
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      // Today - show time
      final hour = createdAt.hour.toString().padLeft(2, '0');
      final minute = createdAt.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week - show day name
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[createdAt.weekday - 1];
    } else {
      // Older - show date
      final day = createdAt.day.toString().padLeft(2, '0');
      final month = createdAt.month.toString().padLeft(2, '0');
      return '$day/$month';
    }
  }

  /// Get message preview (first 50 characters)
  String get preview {
    if (message.length <= 50) return message;
    return '${message.substring(0, 50)}...';
  }

  @override
  String toString() {
    return 'InboxMessage(id: $id, senderName: $senderName, message: $message, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InboxMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
