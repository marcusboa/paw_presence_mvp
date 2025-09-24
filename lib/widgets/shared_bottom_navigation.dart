import 'package:flutter/material.dart';
import '../screens/pet_sitter_home_screen.dart';
import '../screens/pet_owner_home_screen.dart';
import '../screens/jobs_menu_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/pets_menu_screen.dart';
import '../screens/profile_screen.dart';

enum UserRole { petSitter, petOwner }

class SharedBottomNavigation extends StatelessWidget {
  final UserRole userRole;
  final int currentIndex;
  final int? unreadMessages;

  const SharedBottomNavigation({
    super.key,
    required this.userRole,
    required this.currentIndex,
    this.unreadMessages,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onItemTapped(context, index),
      items: _buildNavigationItems(),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    if (userRole == UserRole.petSitter) {
      return [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'Jobs',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.message),
              if (unreadMessages != null && unreadMessages! > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$unreadMessages',
                      style: const TextStyle(
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
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else {
      return [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.message),
              if (unreadMessages != null && unreadMessages! > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$unreadMessages',
                      style: const TextStyle(
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
        const BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: 'Pets',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    if (userRole == UserRole.petSitter) {
      switch (index) {
        case 0: // Home
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const PetSitterHomeScreen()),
            (route) => false,
          );
          break;
        case 1: // Jobs
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const JobsMenuScreen()),
          );
          break;
        case 2: // Messages
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MessagesScreen()),
          );
          break;
        case 3: // Profile
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
          break;
      }
    } else {
      switch (index) {
        case 0: // Home
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const PetOwnerHomeScreen()),
            (route) => false,
          );
          break;
        case 1: // Messages
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MessagesScreen()),
          );
          break;
        case 2: // Pets
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PetsMenuScreen()),
          );
          break;
        case 3: // Profile
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
          break;
      }
    }
  }
}
