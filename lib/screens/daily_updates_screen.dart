import 'package:flutter/material.dart';
import '../services/daily_update_service.dart';

class DailyUpdatesScreen extends StatefulWidget {
  final int jobId;
  final String petName;

  const DailyUpdatesScreen({
    super.key,
    required this.jobId,
    required this.petName,
  });

  @override
  State<DailyUpdatesScreen> createState() => _DailyUpdatesScreenState();
}

class _DailyUpdatesScreenState extends State<DailyUpdatesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DailyUpdate> _allUpdates;
  late List<DailyUpdate> _completedUpdates;
  late List<DailyUpdate> _pendingUpdates;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Get daily updates data (for display purposes only)
    _allUpdates = DailyUpdateService.getSampleDailyUpdates(widget.jobId);
    _completedUpdates = DailyUpdateService.getCompletedUpdates(widget.jobId);
    _pendingUpdates = DailyUpdateService.getPendingUpdates(widget.jobId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completionPercentage = DailyUpdateService.getDailyCompletionPercentage(widget.jobId);
    final today = DateTime.now();
    final formattedDate = "${today.month}/${today.day}/${today.year}";
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Updates for ${widget.petName}'),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey.shade700,
              size: 20,
            ),
            tooltip: 'Go Back',
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date and Progress indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today: $formattedDate',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(completionPercentage * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: completionPercentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_completedUpdates.length} of ${_allUpdates.length} daily tasks completed',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All updates tab
                _buildUpdatesList(_allUpdates),
                
                // Completed updates tab
                _buildUpdatesList(_completedUpdates),
                
                // Pending updates tab
                _buildUpdatesList(_pendingUpdates),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This feature is for display only'))
          );
        },
        tooltip: 'Add new update',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUpdatesList(List<DailyUpdate> updates) {
    if (updates.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No updates to display'),
        ),
      );
    }
    
    // Group updates by category
    final Map<String, List<DailyUpdate>> categorizedUpdates = {};
    
    for (var update in updates) {
      if (!categorizedUpdates.containsKey(update.category)) {
        categorizedUpdates[update.category] = [];
      }
      categorizedUpdates[update.category]!.add(update);
    }
    
    // Sort updates by timestamp
    updates.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: updates.length,
      itemBuilder: (context, index) {
        final update = updates[index];
        return DailyUpdateCard(
          update: update,
          onToggle: () {
            // This would toggle the completion status in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('This feature is for display only')),
            );
          },
        );
      },
    );
  }
}
