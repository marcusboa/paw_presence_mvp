import 'package:flutter/material.dart';
import '../screens/pet_sitter_home_screen.dart';
import '../screens/pet_owner_home_screen.dart';

class RoleSwitchFAB extends StatelessWidget {
  final bool isPetSitter;
  
  const RoleSwitchFAB({
    super.key,
    required this.isPetSitter,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100, // Position above bottom navigation
      right: 16,
      child: FloatingActionButton.extended(
        onPressed: () => _switchRole(context),
        backgroundColor: isPetSitter ? Colors.orange : Colors.teal,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: Icon(
          isPetSitter ? Icons.pets : Icons.work,
          size: 20,
        ),
        label: Text(
          isPetSitter ? 'Pet Owner' : 'Pet Sitter',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        heroTag: "role_switch_fab", // Unique hero tag to avoid conflicts
      ),
    );
  }

  void _switchRole(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isPetSitter ? Icons.pets : Icons.work,
                color: isPetSitter ? Colors.orange : Colors.teal,
              ),
              const SizedBox(width: 8),
              Text(
                'Switch to ${isPetSitter ? 'Pet Owner' : 'Pet Sitter'}?',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          content: Text(
            'You will be switched to the ${isPetSitter ? 'Pet Owner' : 'Pet Sitter'} profile and taken to the home screen.',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _performRoleSwitch(context);
              },
              icon: Icon(
                isPetSitter ? Icons.pets : Icons.work,
                size: 16,
              ),
              label: const Text('Switch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPetSitter ? Colors.orange : Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _performRoleSwitch(BuildContext context) {
    // Navigate to the appropriate home screen and clear navigation stack
    if (isPetSitter) {
      // Switch to Pet Owner
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PetOwnerHomeScreen()),
        (route) => false,
      );
    } else {
      // Switch to Pet Sitter
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PetSitterHomeScreen()),
        (route) => false,
      );
    }

    // Show success message
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isPetSitter ? Icons.pets : Icons.work,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Switched to ${isPetSitter ? 'Pet Owner' : 'Pet Sitter'} profile',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            backgroundColor: isPetSitter ? Colors.orange : Colors.teal,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
          ),
        );
      }
    });
  }
}
