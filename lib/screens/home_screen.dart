import 'package:flutter/material.dart';
import '../main.dart';
import '../services/photo_album_service.dart';
import 'photo_album_screen.dart';
import 'role_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserRole userRole;

  const HomeScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.userRole == UserRole.petSitter ? 'Paw Presence - Sitter' : 'Paw Presence - Owner'),
        actions: [
          // Role indicator badge
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.userRole == UserRole.petSitter ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.userRole == UserRole.petSitter ? 'SITTER' : 'OWNER',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildFirstTab(),
          _buildMessagesTab(),
          _buildPetsTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _buildNavBarItems(),
      ),
    );
  }

  // Build different navigation items based on role
  List<BottomNavigationBarItem> _buildNavBarItems() {
    if (widget.userRole == UserRole.petSitter) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
        BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    } else {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
        BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    }
  }

  // First tab changes based on user role (Jobs for sitter, Bookings for owner)
  Widget _buildFirstTab() {
    if (widget.userRole == UserRole.petSitter) {
      return _buildJobsTab();
    } else {
      return _buildBookingsTab();
    }
  }

  // Jobs tab for pet sitter
  Widget _buildJobsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Jobs', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('SITTER VIEW',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    // Show a message that this is a demo
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This is a demo job. Navigate to the Jobs tab for active jobs.'),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.pets, size: 30, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pet ${index + 1}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Golden Retriever • 5 years old'),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text('Daily Visit',
                                      style: TextStyle(fontSize: 12, color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoChip(Icons.calendar_today, 'June 15-25'),
                            _buildInfoChip(Icons.access_time, '9:00 AM'),
                            _buildInfoChip(Icons.location_on, '0.8 miles'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                // Show a message that this is a demo
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('This is a demo job. Navigate to the Jobs tab for active jobs.'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.work_outline),
                              label: const Text('Start Visit'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.chat_outlined),
                              label: const Text('Message'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Bookings tab for pet owner
  Widget _buildBookingsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Bookings', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('OWNER VIEW',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${index + 15}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  const Text('June'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Daily Dog Walking',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text('Confirmed',
                                          style: TextStyle(fontSize: 12, color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text('9:00 AM - 11:00 AM'),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 12,
                                        backgroundImage: null,
                                        child: Icon(Icons.person, size: 12),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text('Sarah Johnson',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                                      const Text('4.9',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.chat_outlined),
                                label: const Text('Message'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.visibility),
                                label: const Text('View Updates'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Messages tab
  Widget _buildMessagesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Messages', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.userRole == UserRole.petSitter ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.userRole == UserRole.petSitter ? 'SITTER VIEW' : 'OWNER VIEW',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) {
              // Show different UI based on the user role
              if (widget.userRole == UserRole.petSitter) {
                return _buildPetSitterMessageItem(index);
              } else {
                return _buildPetOwnerMessageItem(index);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPetSitterMessageItem(int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text('Pet Owner ${index + 1}'),
        subtitle: const Text('Thanks for taking care of Max today!'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('10:30 AM', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildPetOwnerMessageItem(int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.work, color: Colors.white),
        ),
        title: Text('Pet Sitter ${index + 1}'),
        subtitle: const Text('I just completed walking Max - he had a great time!'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('2:15 PM', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  // Pets tab
  Widget _buildPetsTab() {
    // Sample pet data for display purposes
    final List<Map<String, dynamic>> petData = [
      {
        'id': 1,
        'name': 'Max',
        'type': 'Dog',
        'breed': 'Golden Retriever',
        'age': 5,
        'image': 'assets/images/golden_retriever.jpg'
      },
      {
        'id': 2,
        'name': 'Luna',
        'type': 'Cat',
        'breed': 'Siamese',
        'age': 3,
        'image': 'assets/images/siamese_cat.jpg'
      },
      {
        'id': 3,
        'name': 'Charlie',
        'type': 'Dog',
        'breed': 'Beagle',
        'age': 2,
        'image': 'assets/images/beagle.jpg'
      },
      {
        'id': 4,
        'name': 'Oliver',
        'type': 'Cat',
        'breed': 'Persian',
        'age': 4,
        'image': 'assets/images/persian_cat.jpg'
      },
    ];
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.userRole == UserRole.petSitter ? 'Client Pets' : 'My Pets', 
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              widget.userRole == UserRole.petOwner ? ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This feature is for display only'))
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Pet'),
              ) : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('SITTER VIEW',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: petData.length,
            itemBuilder: (context, index) {
              final pet = petData[index];
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${pet['name']}\'s profile is now available in job details'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            backgroundImage: pet['image'] != null 
                                ? AssetImage(pet['image'] as String) 
                                : null,
                            child: pet['image'] == null 
                                ? Icon(Icons.pets, size: 40, color: Colors.white) 
                                : null,
                          ),
                          // Small photo album icon on the bottom right
                          if (pet['image'] != null)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                // Get albums for this pet and show the first one if available
                                final petAlbums = PhotoAlbumService.getAlbumsByPet(pet['id'] as int);
                                if (petAlbums.isNotEmpty) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PhotoAlbumScreen(
                                        albumId: petAlbums.first.id,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No photo albums available for this pet yet.'),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.photo_library,
                                  color: Colors.deepPurple,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pet['name'] as String,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('${pet['breed']} • ${pet['age']} years'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Profile tab
  Widget _buildProfileTab() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.deepPurple.shade50,
          child: Column(
            children: [
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                widget.userRole == UserRole.petSitter ? 'Sarah Johnson' : 'John Smith',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.userRole == UserRole.petSitter ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.userRole == UserRole.petSitter ? 'PET SITTER' : 'PET OWNER',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileItem(Icons.account_circle, 'My Account'),
              _buildProfileItem(Icons.notifications, 'Notifications'),
              _buildProfileItem(widget.userRole == UserRole.petSitter ? Icons.work : Icons.pets, 
                widget.userRole == UserRole.petSitter ? 'Job Preferences' : 'Pet Care Preferences'),
              _buildProfileItem(Icons.payment, 'Payment Methods'),
              _buildProfileItem(Icons.settings, 'Settings'),
              _buildProfileItem(Icons.help, 'Help & Support'),
              const Divider(height: 32),
              _buildProfileItem(Icons.logout, 'Switch Role'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (title == 'Switch Role') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const RoleSelectionScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This feature is for display only'))
          );
        }
      },
    );
  }

// Helper widget for info chips
Widget _buildInfoChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.deepPurple),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
      ],
    ),
  );
}
}
