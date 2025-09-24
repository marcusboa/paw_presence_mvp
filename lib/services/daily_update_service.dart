import 'package:flutter/material.dart';

class DailyUpdate {
  final int id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String category;
  final IconData icon;
  final bool completed;
  
  const DailyUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    required this.icon,
    this.completed = false,
  });
}

class DailyUpdateService {
  // Sample daily updates for display purposes only
  static List<DailyUpdate> getSampleDailyUpdates(int jobId) {
    // In a real app, this would fetch data from a database or API
    // and would reset daily
    
    // Get today's date
    final today = DateTime.now();
    
    return [
      DailyUpdate(
        id: 1,
        title: 'Morning Medication',
        description: 'Gave Fluffy her thyroid pill with breakfast',
        timestamp: DateTime(today.year, today.month, today.day, 8, 30),
        category: 'Medication',
        icon: Icons.medication,
        completed: true,
      ),
      DailyUpdate(
        id: 2,
        title: 'Morning Walk',
        description: '30 minute walk around the neighborhood park',
        timestamp: DateTime(today.year, today.month, today.day, 9, 15),
        category: 'Exercise',
        icon: Icons.directions_walk,
        completed: true,
      ),
      DailyUpdate(
        id: 3,
        title: 'Fresh Water',
        description: 'Refreshed water bowl with filtered water',
        timestamp: DateTime(today.year, today.month, today.day, 10, 0),
        category: 'Care',
        icon: Icons.water_drop,
        completed: true,
      ),
      DailyUpdate(
        id: 4,
        title: 'Playtime',
        description: 'Played fetch in the backyard for 20 minutes',
        timestamp: DateTime(today.year, today.month, today.day, 11, 30),
        category: 'Exercise',
        icon: Icons.sports_baseball,
        completed: true,
      ),
      DailyUpdate(
        id: 5,
        title: 'Lunch',
        description: '1 cup of kibble with wet food topper',
        timestamp: DateTime(today.year, today.month, today.day, 12, 30),
        category: 'Meal',
        icon: Icons.lunch_dining,
        completed: true,
      ),
      DailyUpdate(
        id: 6,
        title: 'Afternoon Walk',
        description: 'Quick 15 minute potty walk',
        timestamp: DateTime(today.year, today.month, today.day, 15, 0),
        category: 'Exercise',
        icon: Icons.directions_walk,
        completed: true,
      ),
      DailyUpdate(
        id: 7,
        title: 'Evening Medication',
        description: 'Gave Fluffy her joint supplement',
        timestamp: DateTime(today.year, today.month, today.day, 18, 0),
        category: 'Medication',
        icon: Icons.medication,
        completed: false,
      ),
      DailyUpdate(
        id: 8,
        title: 'Dinner',
        description: '1 cup of kibble with dental treat after',
        timestamp: DateTime(today.year, today.month, today.day, 18, 30),
        category: 'Meal',
        icon: Icons.dinner_dining,
        completed: false,
      ),
      DailyUpdate(
        id: 9,
        title: 'Evening Walk',
        description: '20 minute neighborhood stroll',
        timestamp: DateTime(today.year, today.month, today.day, 20, 0),
        category: 'Exercise',
        icon: Icons.nightlight,
        completed: false,
      ),
    ];
  }

  // Get updates by category
  static List<DailyUpdate> getUpdatesByCategory(int jobId, String category) {
    final allUpdates = getSampleDailyUpdates(jobId);
    return allUpdates.where((update) => update.category == category).toList();
  }

  // Get completed updates
  static List<DailyUpdate> getCompletedUpdates(int jobId) {
    final allUpdates = getSampleDailyUpdates(jobId);
    return allUpdates.where((update) => update.completed).toList();
  }

  // Get pending updates
  static List<DailyUpdate> getPendingUpdates(int jobId) {
    final allUpdates = getSampleDailyUpdates(jobId);
    return allUpdates.where((update) => !update.completed).toList();
  }

  // Calculate completion percentage for the day
  static double getDailyCompletionPercentage(int jobId) {
    final allUpdates = getSampleDailyUpdates(jobId);
    final completedUpdates = getCompletedUpdates(jobId);
    
    if (allUpdates.isEmpty) {
      return 0.0;
    }
    
    return completedUpdates.length / allUpdates.length;
  }
}

// Widget to display a daily update card
class DailyUpdateCard extends StatelessWidget {
  final DailyUpdate update;
  final VoidCallback? onToggle;
  
  const DailyUpdateCard({
    super.key, 
    required this.update,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timestamp column
            Column(
              children: [
                Text(
                  _formatTime(update.timestamp),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(update.category).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    update.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getCategoryColor(update.category),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Update content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    update.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(update.description),
                ],
              ),
            ),
            // Status checkbox
            IconButton(
              onPressed: () {
                if (onToggle != null) {
                  onToggle!();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This feature is for display only')),
                  );
                }
              },
              icon: Icon(
                update.completed ? Icons.check_circle : Icons.circle_outlined,
                color: update.completed ? Colors.green : Colors.grey,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    String hour = time.hour > 12 ? '${time.hour - 12}' : '${time.hour}';
    String minute = time.minute.toString().padLeft(2, '0');
    String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Color _getCategoryColor(String category) {
    switch(category) {
      case 'Medication':
        return Colors.red;
      case 'Exercise':
        return Colors.blue;
      case 'Meal':
        return Colors.orange;
      case 'Care':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
