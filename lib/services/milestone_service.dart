import 'package:flutter/material.dart';

class Milestone {
  final int id;
  final String title;
  final String description;
  final DateTime dateAchieved;
  final bool isCompleted;
  final String category;
  final IconData icon;

  const Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.dateAchieved,
    required this.isCompleted,
    required this.category,
    required this.icon,
  });
}

class MilestoneService {
  // Sample milestones for display purposes only
  static List<Milestone> getPetMilestones(int petId) {
    // In a real app, this would fetch data from a database or API
    return [
      Milestone(
        id: 1,
        title: 'First Vet Visit',
        description: 'Max completed his first wellness check with Dr. Thompson',
        dateAchieved: DateTime(2020, 4, 15),
        isCompleted: true,
        category: 'Health',
        icon: Icons.medical_services,
      ),
      Milestone(
        id: 2,
        title: 'Basic Training Complete',
        description: 'Successfully learned basic commands: sit, stay, come',
        dateAchieved: DateTime(2020, 6, 10),
        isCompleted: true,
        category: 'Training',
        icon: Icons.school,
      ),
      Milestone(
        id: 3,
        title: 'First Birthday',
        description: 'Happy first birthday with special dog-friendly cake!',
        dateAchieved: DateTime(2021, 1, 5),
        isCompleted: true,
        category: 'Celebration',
        icon: Icons.cake,
      ),
      Milestone(
        id: 4,
        title: 'First Boarding Stay',
        description: 'Successfully stayed at Paw Palace Boarding for one week',
        dateAchieved: DateTime(2021, 7, 20),
        isCompleted: true,
        category: 'Experience',
        icon: Icons.home,
      ),
      Milestone(
        id: 5,
        title: 'Advanced Training',
        description: 'Completed intermediate training class with agility obstacles',
        dateAchieved: DateTime(2022, 2, 15),
        isCompleted: true,
        category: 'Training',
        icon: Icons.military_tech,
      ),
      Milestone(
        id: 6,
        title: 'Weight Goal Achieved',
        description: 'Reached healthy weight target after diet adjustment',
        dateAchieved: DateTime(2022, 5, 10),
        isCompleted: true,
        category: 'Health',
        icon: Icons.monitor_weight,
      ),
      Milestone(
        id: 7,
        title: 'Agility Competition',
        description: 'Ready for first local agility competition',
        dateAchieved: DateTime(2025, 8, 15), // Future date
        isCompleted: false,
        category: 'Competition',
        icon: Icons.sports,
      ),
      Milestone(
        id: 8,
        title: 'Therapy Dog Certification',
        description: 'Prepare for therapy dog certification for hospital visits',
        dateAchieved: DateTime(2025, 12, 1), // Future date
        isCompleted: false,
        category: 'Certification',
        icon: Icons.volunteer_activism,
      ),
    ];
  }

  // Get milestones by category
  static List<Milestone> getMilestonesByCategory(int petId, String category) {
    final allMilestones = getPetMilestones(petId);
    return allMilestones.where((milestone) => milestone.category == category).toList();
  }

  // Get completed milestones
  static List<Milestone> getCompletedMilestones(int petId) {
    final allMilestones = getPetMilestones(petId);
    return allMilestones.where((milestone) => milestone.isCompleted).toList();
  }

  // Get upcoming milestones
  static List<Milestone> getUpcomingMilestones(int petId) {
    final allMilestones = getPetMilestones(petId);
    return allMilestones.where((milestone) => !milestone.isCompleted).toList();
  }

  // Calculate milestone achievement percentage
  static double getMilestonePercentage(int petId) {
    final allMilestones = getPetMilestones(petId);
    final completedMilestones = getCompletedMilestones(petId);
    
    if (allMilestones.isEmpty) {
      return 0.0;
    }
    
    return completedMilestones.length / allMilestones.length;
  }
}

// Widget to display milestone details
class MilestoneDetailCard extends StatelessWidget {
  final Milestone milestone;
  
  const MilestoneDetailCard({
    super.key, 
    required this.milestone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: milestone.isCompleted 
                    ? Colors.green 
                    : Colors.grey,
                  child: Icon(milestone.icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        milestone.isCompleted 
                          ? 'Achieved on: ${_formatDate(milestone.dateAchieved)}'
                          : 'Target date: ${_formatDate(milestone.dateAchieved)}',
                        style: TextStyle(
                          color: milestone.isCompleted 
                            ? Colors.green 
                            : Colors.blueGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(milestone.category),
                  backgroundColor: _getCategoryColor(milestone.category),
                  labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(milestone.description),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Color _getCategoryColor(String category) {
    switch(category) {
      case 'Health':
        return Colors.teal;
      case 'Training':
        return Colors.indigo;
      case 'Celebration':
        return Colors.amber.shade800;
      case 'Experience':
        return Colors.purple;
      case 'Competition':
        return Colors.red;
      case 'Certification':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
