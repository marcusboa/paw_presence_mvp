import 'package:flutter/material.dart';
import '../screens/receipt_management_screen.dart';
import '../screens/business_insurance_screen.dart';
import '../screens/signin_screen.dart';
import '../services/receipt_service.dart';
import '../models/receipt.dart';

// [NEW] Profile Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings feature is for demo only'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
            // Profile header with user info
            _buildProfileHeader(context),
            
            const SizedBox(height: 24),
            
            // Account settings options
            _buildSettingsSectionTitle('Account Settings'),
            _buildSettingsOption(
              context,
              icon: Icons.lock,
              title: 'Password & Security',
              subtitle: 'Update your password and security settings',
              iconColor: Colors.blue,
            ),
            _buildSettingsOption(
              context,
              icon: Icons.contact_phone,
              title: 'Email & Telephone',
              subtitle: 'Manage your contact information',
              iconColor: Colors.green,
            ),
            
            const Divider(),
            
            // App settings options
            _buildSettingsSectionTitle('App Settings'),
            _buildSettingsOption(
              context,
              icon: Icons.notifications,
              title: 'Notification Settings',
              subtitle: 'Configure how you receive notifications',
              iconColor: Colors.orange,
            ),
            _buildSettingsOption(
              context,
              icon: Icons.tune,
              title: 'App Preferences',
              subtitle: 'Customize your app experience',
              iconColor: Colors.purple,
            ),
            
            const Divider(),
            
            // Business Insurance
            _buildSettingsSectionTitle('Business Insurance'),
            _buildSettingsOption(
              context,
              icon: Icons.security,
              title: 'Insurance Information',
              subtitle: 'Upload and manage your business insurance documents',
              iconColor: Colors.teal,
              onTap: () => _navigateToInsuranceManager(context),
            ),
            
            const Divider(),
            
            // Receipt Management
            _buildSettingsSectionTitle('Receipt Management'),
            _buildSettingsOption(
              context,
              icon: Icons.receipt_long,
              title: 'Receipt Manager',
              subtitle: 'Capture and manage expense receipts',
              iconColor: Colors.deepPurple,
              onTap: () => _navigateToReceiptManager(context),
            ),
            _buildSettingsOption(
              context,
              icon: Icons.camera_alt,
              title: 'Quick Receipt Capture',
              subtitle: 'Take a photo of a receipt instantly',
              iconColor: Colors.green,
              onTap: () => _showQuickReceiptCapture(context),
            ),
            
            const Divider(),
            
            // Legal & Support
            _buildSettingsSectionTitle('Legal & Support'),
            _buildSettingsOption(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              iconColor: Colors.teal,
            ),
            _buildSettingsOption(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'Learn how we protect your data',
              iconColor: Colors.indigo,
            ),
            _buildSettingsOption(
              context,
              icon: Icons.description,
              title: 'Terms of Service',
              subtitle: 'Read our terms and conditions',
              iconColor: Colors.deepOrange,
            ),
            
            const SizedBox(height: 24),
            
            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Version info
            Text(
              'Paw Presence v1.0.0',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // User avatar and basic info
          Row(
            children: [
              // Profile picture
              Hero(
                tag: 'profile-picture',
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Change profile photo feature is for demo only'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.deepPurple.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // User name and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sally Sitter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pet Sitter since June 2025',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Edit profile button
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit profile feature is for demo only'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Profile stats
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('42', 'Jobs'),
                _buildVerticalDivider(),
                _buildStatColumn('2.5', 'Years'),
                _buildVerticalDivider(),
                _buildStatColumn('18', 'Pets'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildSettingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title feature is for demo only'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                // Close dialog
                Navigator.of(context).pop();
                
                // Navigate to sign-in screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false, // Remove all previous routes
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('LOG OUT'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToReceiptManager(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReceiptManagementScreen(),
      ),
    );
  }

  void _navigateToInsuranceManager(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BusinessInsuranceScreen(),
      ),
    );
  }

  void _showQuickReceiptCapture(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Quick Receipt Capture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Take Photo'),
                subtitle: const Text('Capture receipt with camera'),
                onTap: () {
                  Navigator.pop(context);
                  _quickCaptureFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select existing photo'),
                onTap: () {
                  Navigator.pop(context);
                  _quickCaptureFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _quickCaptureFromCamera() {
    _showJobSelectionForQuickCapture(true);
  }

  void _quickCaptureFromGallery() {
    _showJobSelectionForQuickCapture(false);
  }

  void _showJobSelectionForQuickCapture(bool fromCamera) {
    final activeJobs = ReceiptService.getActiveJobsForReceipts();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Job'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Which job is this receipt for?'),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: activeJobs.length,
                  itemBuilder: (context, index) {
                    final job = activeJobs[index];
                    return ListTile(
                      title: Text('${job['petOwnerName']} • ${job['petName']}'),
                      subtitle: Text(job['jobTitle']),
                      onTap: () {
                        Navigator.pop(context);
                        _captureReceiptForJob(job, fromCamera);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _captureReceiptForJob(Map<String, dynamic> job, bool fromCamera) async {
    Receipt? receipt;
    
    if (fromCamera) {
      receipt = await ReceiptService.captureReceiptPhoto(
        jobId: job['jobId'],
        petOwnerId: job['petOwnerId'],
        petOwnerName: job['petOwnerName'],
        petName: job['petName'],
      );
    } else {
      receipt = await ReceiptService.pickReceiptPhoto(
        jobId: job['jobId'],
        petOwnerId: job['petOwnerId'],
        petOwnerName: job['petOwnerName'],
        petName: job['petName'],
      );
    }

    if (receipt != null) {
      _showReceiptCapturedDialog(receipt);
    }
  }

  void _showReceiptCapturedDialog(Receipt receipt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Receipt Captured!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('What would you like to do with this receipt?'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _sendReceiptNow(receipt);
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Send Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _fileForLater(receipt);
                      },
                      icon: const Icon(Icons.folder),
                      label: const Text('File for Later'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToReceiptManager(context);
              },
              child: const Text('View All Receipts'),
            ),
          ],
        );
      },
    );
  }

  void _sendReceiptNow(Receipt receipt) {
    ReceiptService.sendReceiptToOwner(receipt.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Receipt sent to ${receipt.petOwnerName}'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _fileForLater(Receipt receipt) {
    ReceiptService.fileReceiptForLater(receipt.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.folder, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Receipt filed for end-of-job delivery'),
          ],
        ),
        backgroundColor: Colors.purple,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
