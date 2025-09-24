import 'package:flutter/material.dart';
import 'messages_screen.dart';
import 'job_page_screen.dart';
import '../services/demo_data_service.dart';
import '../models/job.dart';
import '../widgets/loading_widgets.dart';
import '../services/image_service.dart';

class JobsMenuScreen extends StatefulWidget {
  const JobsMenuScreen({super.key});

  @override
  State<JobsMenuScreen> createState() => _JobsMenuScreenState();
}

class _JobsMenuScreenState extends State<JobsMenuScreen>
    with TickerProviderStateMixin {
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
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs Menu'),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('Active Jobs', Icons.work),
                          const SizedBox(height: 12),
                          _buildActiveJobsList(),
                          
                          const SizedBox(height: 24),
                          
                          _buildSectionHeader('Past Jobs', Icons.history),
                          const SizedBox(height: 12),
                          _buildPastJobsList(),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header skeleton
            Container(
              height: 24,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            // Job cards skeleton
            for (int i = 0; i < 2; i++) LoadingWidgets.shimmerJobCard(),
            const SizedBox(height: 24),
            // Another section header skeleton
            Container(
              height: 24,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            // More job cards skeleton
            for (int i = 0; i < 3; i++) LoadingWidgets.shimmerJobCard(),
          ],
        ),
      ),
    );
  }


  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveJobsList() {
    final activeJobs = DemoDataService.getActiveJobs();

    if (activeJobs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.work_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No active jobs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your active pet sitting jobs will appear here',
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activeJobs.length,
      itemBuilder: (context, index) {
        final job = activeJobs[index];
        final pet = DemoDataService.getPetById(job.petIds.first);
        final owner = DemoDataService.getPetOwnerById(job.petOwnerId);
        
        if (pet == null || owner == null) return const SizedBox.shrink();
        
        final daysRemaining = job.endDate.difference(DateTime.now()).inDays;
        
        return _buildActiveJobCard(
          context,
          job: job,
          petName: pet['name'],
          petType: pet['type'],
          ownerName: owner['name'],
          days: daysRemaining > 0 ? daysRemaining : 0,
          imageUrl: pet['imageUrl'],
        );
      },
    );
  }

  Widget _buildPastJobsList() {
    final pastJobs = DemoDataService.getPastJobs();

    if (pastJobs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No past jobs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your completed pet sitting jobs will appear here',
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pastJobs.length,
      itemBuilder: (context, index) {
        final job = pastJobs[index];
        final pet = DemoDataService.getPetById(job.petIds.first);
        final owner = DemoDataService.getPetOwnerById(job.petOwnerId);
        
        if (pet == null || owner == null) return const SizedBox.shrink();
        
        // Format end date
        final endDate = '${job.endDate.day} ${_getMonthName(job.endDate.month)} ${job.endDate.year}';
        
        return _buildPastJobCard(
          context,
          job: job,
          petName: pet['name'],
          petType: pet['type'],
          ownerName: owner['name'],
          endDate: endDate,
          imageUrl: pet['imageUrl'],
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildActiveJobCard(
    BuildContext context, {
    required Job job,
    required String petName,
    required String petType,
    required String ownerName,
    required int days,
    required String imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobPageScreen(
                jobId: 1, // Using a demo jobId
                petName: petName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced pet image with loading states
                  ImageService.enhancedImage(
                    imageUrl: imageUrl,
                    width: 60,
                    height: 60,
                    borderRadius: BorderRadius.circular(8),
                    errorWidget: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      child: Icon(
                        Icons.pets,
                        size: 30,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Job info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              petName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Day $days',
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$petType • $ownerName',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Scheduled visits: 2 times daily',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobPageScreen(
                            jobId: 1, // Using a demo jobId
                            petName: petName,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade50,
                      foregroundColor: Colors.deepPurple,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to Messages Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MessagesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Message Owner'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPastJobCard(
    BuildContext context, {
    required Job job,
    required String petName,
    required String petType,
    required String ownerName,
    required String endDate,
    required String imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.grey.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobPageScreen(
                jobId: 2, // Using a demo jobId
                petName: petName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet image (desaturated for past jobs)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.matrix([
                        0.5, 0.5, 0.5, 0, 0,
                        0.5, 0.5, 0.5, 0, 0,
                        0.5, 0.5, 0.5, 0, 0,
                        0, 0, 0, 1, 0,
                      ]),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              petType == 'Dog' ? Icons.pets : Icons.catching_pokemon,
                              size: 30,
                              color: Colors.grey.shade500,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Job info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              petName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Completed: $endDate',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$petType • $ownerName',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobPageScreen(
                            jobId: 2, // Using a demo jobId
                            petName: petName,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.grey.shade700,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to Messages Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MessagesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Message Owner'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
