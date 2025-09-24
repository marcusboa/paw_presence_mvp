import 'package:flutter/material.dart';
import '../main.dart';
import 'pet_sitter_home_screen.dart';  // [NEW] Import Pet Sitter Home Screen
import 'pet_owner_home_screen.dart';  // [NEW] Import Enhanced Pet Owner Home Screen

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Color.fromARGB(255, 103, 58, 183)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo and name
                  const Icon(
                    Icons.pets,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Paw Presence',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Demo Mode Selection',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Role selection cards
                  const Text(
                    'Select Your Role',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Pet Sitter Role Card
                  _buildRoleCard(
                    context,
                    'Pet Sitter',
                    'Access jobs, send daily updates, and manage schedules',
                    Icons.work,
                    UserRole.petSitter,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Pet Owner Role Card
                  _buildRoleCard(
                    context,
                    'Pet Owner',
                    'View pet profiles, receive updates, and manage bookings',
                    Icons.person,
                    UserRole.petOwner,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Demo mode explanation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'This is a demonstration app showing two different user experiences. '
                      'Select a role to see features relevant to that user type.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String title, String description, 
      IconData icon, UserRole role) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (role == UserRole.petSitter) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const PetSitterHomeScreen(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const PetOwnerHomeScreen(),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                radius: 30,
                child: Icon(
                  icon,
                  color: Colors.deepPurple,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
