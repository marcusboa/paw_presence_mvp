import 'package:flutter/material.dart';
import '../services/demo_data_service.dart';
import '../widgets/loading_widgets.dart';

// [NEW] Messages Screen
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with TickerProviderStateMixin {
  // Filter options
  String _currentFilter = 'All';
  final List<String> _filters = ['All', 'Unread', 'Recent'];

  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Simulate loading delay for demonstration
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search functionality coming soon!'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Search messages',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New message feature is for demo only'),
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Filter tabs
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: _filters.map((filter) {
                            final isSelected = filter == _currentFilter;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentFilter = filter;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? Colors.deepPurple 
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    filter,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey.shade700,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Message count
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: [
                            Text(
                              '${DemoDataService.getConversations().length} Conversations',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildConversationsList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter tabs skeleton
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(3, (index) => Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 16),
            // Message list skeleton
            for (int i = 0; i < 5; i++) ...[
              LoadingWidgets.shimmerListItem(),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    
    _fadeController.reset();
    
    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _fadeController.forward();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              const Text('Messages refreshed'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildConversationsList() {
    final conversations = DemoDataService.getConversations();

    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your conversations with pet owners will appear here',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _buildConversationItem(conversation);
      },
    );
  }

  Widget _buildConversationItem(Map<String, dynamic> conversation) {
    // Format timestamp
    final timestamp = conversation['timestamp'] as DateTime;
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    String timeText;
    if (difference.inMinutes < 60) {
      if (difference.inMinutes < 1) {
        timeText = 'Just now';
      } else {
        timeText = '${difference.inMinutes} min ago';
      }
    } else if (difference.inHours < 24) {
      timeText = '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      timeText = 'Yesterday';
    } else if (difference.inDays < 7) {
      timeText = '${difference.inDays}d ago';
    } else {
      timeText = '${(difference.inDays / 7).floor()}w ago';
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade200,
          child: Text(
            conversation['petOwnerName'][0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${conversation['petOwnerName']} • ${conversation['petName']}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (conversation['unreadCount'] > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${conversation['unreadCount']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              conversation['lastMessage'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: conversation['unreadCount'] > 0 
                    ? Colors.black87 
                    : Colors.grey.shade600,
                fontWeight: conversation['unreadCount'] > 0 
                    ? FontWeight.w500 
                    : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeText,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          _openConversation(context, conversation);
        },
      ),
    );
  }

  void _openConversation(BuildContext context, Map<String, dynamic> conversation) {
    // Show a detailed conversation view (for demo purposes, show a snackbar with conversation details)
    final messages = conversation['messages'] as List<dynamic>;
    final messageCount = messages.length;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${conversation['petOwnerName']} • ${conversation['petName']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conversation with ${conversation['petOwnerName']} about ${conversation['petName']}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Messages: $messageCount',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                'Last message: ${conversation['lastMessage']}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (conversation['unreadCount'] > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${conversation['unreadCount']} unread messages',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening chat with ${conversation['petOwnerName']}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Open Chat'),
            ),
          ],
        );
      },
    );
  }
}
