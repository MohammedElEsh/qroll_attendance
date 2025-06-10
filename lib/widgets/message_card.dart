// / Reusable widget for displaying inbox messages in a card format.
// / Follows the app's design system with consistent styling and interactions.

import 'package:flutter/material.dart';
import '../models/inbox_message.dart';

class MessageCard extends StatelessWidget {
  final InboxMessage message;
  final VoidCallback? onTap;
  final bool showUnreadIndicator;

  const MessageCard({
    super.key,
    required this.message,
    this.onTap,
    this.showUnreadIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      color: message.isRead ? Colors.white : Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sender avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getAvatarColor(message.senderRole),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    _getInitials(message.senderName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Message content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender name and role
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            message.senderName,
                            style: TextStyle(
                              fontWeight: message.isRead ? FontWeight.w500 : FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showUnreadIndicator && !message.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF7EF4E1),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 2),
                    
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRoleBadgeColor(message.senderRole),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message.senderRole,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getRoleTextColor(message.senderRole),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Subject (if available)
                    if (message.subject != null && message.subject!.isNotEmpty) ...[
                      Text(
                        message.subject!,
                        style: TextStyle(
                          fontWeight: message.isRead ? FontWeight.w500 : FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                    
                    // Message preview
                    Text(
                      message.preview,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Time and chevron
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
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
