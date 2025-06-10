import 'package:flutter/material.dart';
import '../models/inbox_message.dart';

class MessageDetailScreen extends StatefulWidget {
  final InboxMessage message;

  const MessageDetailScreen({
    super.key,
    required this.message,
  });

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  late InboxMessage _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
  }



  /// Get full formatted date and time
  String _getFullDateTime() {
    final date = _message.createdAt;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    
    return '$day/$month/$year at $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Image.asset(
          'assets/image/Screenshot 2025-05-20 042959.png',
          height: 100,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and title
                  Row(
                    children: [
                      const Text(
                        'Message',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      if (!_message.isRead)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7EF4E1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'New',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Message content card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender information
                  Row(
                    children: [
                      // Sender avatar
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _getAvatarColor(_message.senderRole),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(_message.senderName),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Sender details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _message.senderName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getRoleBadgeColor(_message.senderRole),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _message.senderRole,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getRoleTextColor(_message.senderRole),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Date and time
                  Text(
                    _getFullDateTime(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subject (if available)
                  if (_message.subject != null && _message.subject!.isNotEmpty) ...[
                    Text(
                      'Subject: ${_message.subject}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Divider
                  Divider(color: Colors.grey[200]),
                  
                  const SizedBox(height: 16),
                  
                  // Message content
                  Text(
                    _message.message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Get initials from sender name
  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return 'U';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  /// Get avatar color based on sender role
  Color _getAvatarColor(String role) {
    switch (role.toLowerCase()) {
      case 'teacher':
      case 'instructor':
        return Colors.blue[600]!;
      case 'admin':
      case 'administrator':
        return Colors.red[600]!;
      case 'ta':
      case 'teaching assistant':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  /// Get role badge background color
  Color _getRoleBadgeColor(String role) {
    switch (role.toLowerCase()) {
      case 'teacher':
      case 'instructor':
        return Colors.blue[50]!;
      case 'admin':
      case 'administrator':
        return Colors.red[50]!;
      case 'ta':
      case 'teaching assistant':
        return Colors.green[50]!;
      default:
        return Colors.grey[100]!;
    }
  }

  /// Get role badge text color
  Color _getRoleTextColor(String role) {
    switch (role.toLowerCase()) {
      case 'teacher':
      case 'instructor':
        return Colors.blue[700]!;
      case 'admin':
      case 'administrator':
        return Colors.red[700]!;
      case 'ta':
      case 'teaching assistant':
        return Colors.green[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}
