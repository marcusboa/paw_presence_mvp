import 'package:flutter/material.dart';
import '../services/milestone_service.dart';

class MilestonesScreen extends StatefulWidget {
  final int petId;
  final String petName;

  const MilestonesScreen({
    super.key,
    required this.petId,
    required this.petName,
  });

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Milestone> _allMilestones;
  late List<Milestone> _completedMilestones;
  late List<Milestone> _upcomingMilestones;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Get milestones data (for display purposes only)
    _allMilestones = MilestoneService.getPetMilestones(widget.petId);
    _completedMilestones = MilestoneService.getCompletedMilestones(widget.petId);
    _upcomingMilestones = MilestoneService.getUpcomingMilestones(widget.petId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final milestonePercentage = MilestoneService.getMilestonePercentage(widget.petId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.petName}\'s Milestones'),
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
            Tab(text: 'Upcoming'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Milestone Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(milestonePercentage * 100).toInt()}%',
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
                  value: milestonePercentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_completedMilestones.length} of ${_allMilestones.length} milestones achieved',
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
                // All milestones tab
                _buildMilestoneList(_allMilestones),
                
                // Completed milestones tab
                _buildMilestoneList(_completedMilestones),
                
                // Upcoming milestones tab
                _buildMilestoneList(_upcomingMilestones),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMilestoneList(List<Milestone> milestones) {
    if (milestones.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No milestones to display'),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final milestone = milestones[index];
        return MilestoneDetailCard(milestone: milestone);
      },
    );
  }
}
