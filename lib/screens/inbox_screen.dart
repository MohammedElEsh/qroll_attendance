import 'package:flutter/material.dart';
import '../models/inbox_message.dart';
import '../services/inbox_service.dart';
import '../widgets/app_drawer.dart';
import 'message_detail_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final InboxService _inboxService = InboxService();
  List<InboxMessage> _messages = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  /// Load messages from the API
  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);

    try {
      final response = await _inboxService.getInboxMessages();
      if (mounted) {
        setState(() {
          if (response.statusCode == 200 && response.data?['data'] != null) {            _messages = (response.data!['data'] as List)
                .map((json) => InboxMessage.fromJson(json))
                .toList()
              ..sort((a, b) => a.createdAt.compareTo(b.createdAt)); // Sort from oldest to newest
            _errorMessage = null;
          } else {
            _errorMessage = 'Failed to load messages';
            _messages = [];
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _messages = [];
          _isLoading = false;
        });
      }
    }
  }

  /// Navigate to message detail screen
  void _openMessage(InboxMessage message) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MessageDetailScreen(message: message),
      ),
    ).then((_) => _loadMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: Image.asset(
          'assets/image/Screenshot 2025-05-20 042959.png',
          height: 80,
          fit: BoxFit.contain,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60, // Increased width for ID
                  child: Text(
                    'ID',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Added spacing
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Added spacing
                Expanded(
                  flex: 3,
                  child: Text(
                    'Content',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Message list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7EF4E1),
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadMessages,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _messages.isEmpty
                        ? Center(
                            child: Text(
                              'No messages found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return InkWell(
                                onTap: () => _openMessage(message),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16, // Increased vertical padding
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade100,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 60, // Increased width for ID
                                        child: Text(
                                          message.id.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16), // Added spacing
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          message.formattedDate,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16), // Added spacing
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          message.preview,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                            fontWeight: message.isRead
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
