import 'package:flutter/material.dart';
import 'job_details_screen.dart';
import 'invoice_screen.dart';
import 'jobs_menu_screen.dart'; // [NEW] Import Jobs Menu Screen
import 'messages_screen.dart'; // [NEW] Import Messages Screen
import 'profile_screen.dart'; // [NEW] Import Profile Screen
import '../services/demo_data_service.dart'; // [NEW] Import Demo Data Service
import '../widgets/loading_widgets.dart'; // [NEW] Import Loading Widgets
import '../services/image_service.dart'; // [NEW] Import Image Service
import '../models/job.dart'; // [NEW] Import Job Model
import '../widgets/role_switch_fab.dart';

// [NEW] Pet Sitter Home Screen
class PetSitterHomeScreen extends StatefulWidget {
  const PetSitterHomeScreen({super.key});

  @override
  State<PetSitterHomeScreen> createState() => _PetSitterHomeScreenState();
}

class _PetSitterHomeScreenState extends State<PetSitterHomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late int _notifications;
  late int _unreadMessages;
  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (mounted) {
      _updateCounts();
      setState(() {
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  void _updateCounts() {
    setState(() {
      _notifications = DemoDataService.getUnreadNotificationCount();
      _unreadMessages = DemoDataService.getUnreadMessageCount();
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      
      // Add haptic feedback
      // HapticFeedback.selectionClick(); // Uncomment if you want haptic feedback
      
      // Show loading state briefly for tab transitions
      if (index != 0) { // Don't show loading for home tab
        _showTabTransitionLoading();
      }
    }
  }

  void _showTabTransitionLoading() {
    // Brief loading indication for tab transitions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            const Text('Loading...'),
          ],
        ),
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
      ),
    );
  }

  // Enhanced camera access with pet owner selection and chat integration
  Future<void> _openCamera() async {
    try {
      // Show loading dialog with animation
      final result = await ImageService.capturePhoto(context);
      
      if (result != null && mounted) {
        // Show pet owner selection dropdown
        _showPetOwnerSelectionDialog(result);
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error accessing camera: $e');
    }
  }
  
  // Show dropdown dialog to select pet owner for photo sharing
  void _showPetOwnerSelectionDialog(String photoPath) {
    final activeJobs = DemoDataService.getActiveJobs();
    
    if (activeJobs.isEmpty) {
      _showErrorMessage('No active jobs found. Take photos during active pet sitting jobs.');
      return;
    }
    
    // Get unique pet owners from active jobs
    final Map<int, Map<String, dynamic>> uniqueOwners = {};
    for (final job in activeJobs) {
      final owner = DemoDataService.getPetOwnerById(job.petOwnerId);
      final pets = job.petIds.map((id) => DemoDataService.getPetById(id)).where((pet) => pet != null).toList();
      
      if (owner != null && pets.isNotEmpty) {
        uniqueOwners[job.petOwnerId] = {
          'owner': owner,
          'pets': pets,
          'job': job,
        };
      }
    }
    
    if (uniqueOwners.isEmpty) {
      _showErrorMessage('No valid pet owners found for active jobs.');
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.photo_camera, color: Colors.deepPurple),
              const SizedBox(width: 12),
              const Text('Send Photo To'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select the pet owner to send this photo to:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: Column(
                      children: uniqueOwners.entries.map((entry) {
                        final ownerData = entry.value;
                        final owner = ownerData['owner'] as Map<String, dynamic>;
                        final pets = ownerData['pets'] as List<Map<String, dynamic>?>;
                        final job = ownerData['job'] as Job;
                        
                        final petNames = pets.map((pet) => pet!['name'] as String).join(' & ');
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple.withOpacity(0.1),
                              child: Text(
                                (owner['name'] as String).substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              owner['name'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pet(s): $petNames'),
                                Text(
                                  'Job: ${_formatJobDuration(job)}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.withOpacity(0.3)),
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              _sendPhotoToOwner(photoPath, owner, petNames);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  
  // Send photo to selected pet owner's chat
  void _sendPhotoToOwner(String photoPath, Map<String, dynamic> owner, String petNames) {
    // Simulate sending photo to chat
    _showSuccessMessage(
      'Photo sent to ${owner['name']} about $petNames!',
      Icons.send,
    );
    
    // Show additional confirmation with chat preview
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text('Photo Sent!'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.photo, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sent to: ${owner['name']}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'About: $petNames',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Message: "Here\'s a photo of $petNames! 📸"',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'The photo has been added to your conversation with this pet owner.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
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
                    // Navigate to Messages tab to show the conversation
                    setState(() {
                      _selectedIndex = 2; // Messages tab
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('View Chat'),
                ),
              ],
            );
          },
        );
      }
    });
  }
  
  // Helper method to format job duration
  String _formatJobDuration(Job job) {
    final now = DateTime.now();
    final daysRemaining = job.endDate.difference(now).inDays;
    
    if (daysRemaining > 0) {
      return '$daysRemaining day${daysRemaining != 1 ? 's' : ''} remaining';
    } else if (daysRemaining == 0) {
      return 'Ending today';
    } else {
      return 'Recently completed';
    }
  }

  void _showSuccessMessage(String message, IconData icon) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: LoadingWidgets.successAnimation(
          message: message,
          icon: icon,
          color: Colors.green,
        ),
      ),
    );
    
    // Auto dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          _buildCurrentTab(),
          const RoleSwitchFAB(isPetSitter: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.message),
                if (_unreadMessages > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$_unreadMessages',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCurrentTab() {
    if (_isLoading && _selectedIndex == 0) {
      return LoadingWidgets.homeScreenSkeleton();
    }
    
    Widget content;
    switch (_selectedIndex) {
      case 0:
        content = _buildHomeTab();
        break;
      case 1:
        content = const JobsMenuScreen();
        break;
      case 2:
        content = const MessagesScreen();
        break;
      case 3:
        content = const ProfileScreen();
        break;
      default:
        content = _buildHomeTab();
    }
    
    // Add fade animation for home tab
    if (_selectedIndex == 0) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: content,
      );
    }
    
    return content;
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header with profile and notifications
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  // Enhanced profile picture with animation
                  Hero(
                    tag: 'profile_avatar',
                    child: ImageService.userAvatar(
                      userName: 'Sally Sitter',
                      radius: 25,
                      backgroundColor: Colors.deepPurple.shade200,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Welcome text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Sally Sitter',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notification bell with badge
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, size: 26),
                        onPressed: () => _showNotifications(context),
                      ),
                      if (_notifications > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$_notifications',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Active Jobs Banner
          SliverToBoxAdapter(
            child: _buildActiveJobsBanner(),
          ),
          
          // Quick actions section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Quick action buttons
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                _buildActionCard(
                  icon: Icons.camera_alt,
                  title: 'Take Photo',
                  color: Colors.blue,
                  onTap: _openCamera,
                ),
                _buildActionCard(
                  icon: Icons.work_outline,
                  title: 'New Job',
                  color: Colors.green,
                  onTap: () {
                    // Navigate to Jobs tab to see all jobs
                    _onItemTapped(1);
                  },
                ),
                _buildActionCard(
                  icon: Icons.receipt_long,
                  title: 'Invoices',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InvoiceScreen()),
                    );
                  },
                ),
              ]),
            ),
          ),
          
          // Recent activity section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Recent activity list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildActivityItem(index);
              },
              childCount: 5,
            ),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveJobsBanner() {
    final activeJobs = DemoDataService.getActiveJobs();
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.deepPurple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.work_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Jobs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${activeJobs.length} job${activeJobs.length != 1 ? 's' : ''} in progress',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _onItemTapped(1), // Navigate to Jobs tab
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Active Jobs List
          if (activeJobs.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.pets,
                      color: Colors.white.withOpacity(0.7),
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No Active Jobs',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your active jobs will appear here',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: activeJobs.take(3).map((job) => _buildActiveJobItem(job)).toList(),
            ),
          
          if (activeJobs.length > 3)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: InkWell(
                onTap: () => _onItemTapped(1), // Navigate to Jobs tab
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View ${activeJobs.length - 3} more job${activeJobs.length - 3 != 1 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildActiveJobItem(Job job) {
    final pets = job.petIds.map((id) => DemoDataService.getPetById(id)).where((pet) => pet != null).toList();
    final owner = DemoDataService.getPetOwnerById(job.petOwnerId);
    final now = DateTime.now();
    final isOngoing = now.isAfter(job.startDate) && now.isBefore(job.endDate);
    final daysRemaining = job.endDate.difference(now).inDays;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailsScreen(job: job),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            // Pet Avatar(s)
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: pets.isNotEmpty
                      ? ImageService.userAvatar(
                          userName: pets.first!['name'] as String,
                          radius: 25,
                          backgroundColor: Colors.white.withOpacity(0.3),
                        )
                      : const Icon(
                          Icons.pets,
                          color: Colors.white,
                          size: 24,
                        ),
                ),
                if (pets.length > 1)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade800,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        '+${pets.length - 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Job Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pets.isNotEmpty 
                              ? pets.length == 1 
                                  ? pets.first!['name'] as String
                                  : '${pets.first!['name']} +${pets.length - 1}'
                              : 'Pet Care',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isOngoing ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isOngoing ? Colors.green.withOpacity(0.5) : Colors.orange.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          isOngoing ? 'In Progress' : 'Starting Soon',
                          style: TextStyle(
                            color: isOngoing ? Colors.green.shade200 : Colors.orange.shade200,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (owner != null)
                    Text(
                      owner['name'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withOpacity(0.7),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        daysRemaining > 0 
                            ? '$daysRemaining day${daysRemaining != 1 ? 's' : ''} remaining'
                            : 'Ending today',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withOpacity(0.6),
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = DemoDataService.getRecentActivity();
    
    if (index >= activities.length) return const SizedBox.shrink();
    
    final activity = activities[index];
    IconData iconData;
    Color iconColor;
    
    switch (activity['icon']) {
      case 'check_circle':
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case 'photo_camera':
        iconData = Icons.photo_camera;
        iconColor = Colors.blue;
        break;
      case 'message':
        iconData = Icons.message;
        iconColor = Colors.purple;
        break;
      case 'handshake':
        iconData = Icons.handshake;
        iconColor = Colors.orange;
        break;
      case 'star':
        iconData = Icons.star;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.info;
        iconColor = Colors.grey;
    }
    
    // Format timestamp
    final timestamp = activity['timestamp'] as DateTime;
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    String timeText;
    if (difference.inMinutes < 60) {
      timeText = '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      timeText = '${difference.inHours} hours ago';
    } else {
      timeText = '${difference.inDays} days ago';
    }
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['description'] as String,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                if (activity['details'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    activity['details'] as String,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  timeText,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(index);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationItem(int index) {
    final notifications = DemoDataService.getNotifications();
    
    if (index >= notifications.length) return const SizedBox.shrink();
    
    final notification = notifications[index];
    
    // Get icon data from string
    IconData iconData;
    switch (notification['icon']) {
      case 'pets':
        iconData = Icons.pets;
        break;
      case 'message':
        iconData = Icons.message;
        break;
      case 'payment':
        iconData = Icons.payment;
        break;
      case 'calendar_today':
        iconData = Icons.calendar_today;
        break;
      case 'star':
        iconData = Icons.star;
        break;
      case 'photo_camera':
        iconData = Icons.photo_camera;
        break;
      default:
        iconData = Icons.notifications;
    }
    
    // Get color from string
    Color iconColor;
    switch (notification['color']) {
      case 'blue':
        iconColor = Colors.blue;
        break;
      case 'green':
        iconColor = Colors.green;
        break;
      case 'purple':
        iconColor = Colors.purple;
        break;
      case 'orange':
        iconColor = Colors.orange;
        break;
      case 'amber':
        iconColor = Colors.amber;
        break;
      case 'teal':
        iconColor = Colors.teal;
        break;
      default:
        iconColor = Colors.grey;
    }
    
    // Format timestamp
    final timestamp = notification['timestamp'] as DateTime;
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    String timeText;
    if (difference.inMinutes < 60) {
      if (difference.inMinutes < 1) {
        timeText = 'Just now';
      } else {
        timeText = '${difference.inMinutes} minutes ago';
      }
    } else if (difference.inHours < 24) {
      timeText = '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      timeText = 'Yesterday';
    } else {
      timeText = '${difference.inDays} days ago';
    }
    
    return GestureDetector(
      onTap: () {
        // Mark notification as read when tapped
        if (notification['unread'] == true) {
          DemoDataService.markNotificationAsRead(notification['id']);
          _updateCounts();
        }
        
        // Handle different notification types
        switch (notification['type']) {
          case 'message':
            setState(() {
              _selectedIndex = 2; // Navigate to Messages tab
            });
            break;
          case 'job_request':
            setState(() {
              _selectedIndex = 1; // Navigate to Jobs tab
            });
            break;
          case 'payment':
          case 'job_completion':
          case 'reminder':
          case 'album':
            // Show a snackbar for these types
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opened ${notification['title']}'),
                duration: const Duration(seconds: 2),
              ),
            );
            break;
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification['unread'] as bool ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification['unread'] as bool ? Colors.blue.shade100 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'] as String,
                          style: TextStyle(
                            fontWeight: notification['unread'] as bool ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (notification['actionRequired'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'ACTION',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['description'] as String,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeText,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (notification['unread'] as bool)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
