import 'package:flutter/material.dart';
import 'dart:async';

// [NEW] Job Page Screen - A detailed view of a specific job
class JobPageScreen extends StatefulWidget {
  final int jobId;
  final String petName;
  
  const JobPageScreen({
    super.key,
    required this.jobId,
    required this.petName,
  });

  @override
  State<JobPageScreen> createState() => _JobPageScreenState();
}

class _JobPageScreenState extends State<JobPageScreen> {
  // Mock data for the job details
  late Map<String, dynamic> _jobDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading data from a service
    Timer(const Duration(milliseconds: 500), () {
      _loadJobDetails();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _loadJobDetails() {
    // Mock job details data
    _jobDetails = {
      'petName': widget.petName,
      'petImage': 'assets/images/golden_retriever.jpg', // This is one of our actual assets
      'isActive': true,
      'startDate': '2025-07-20',
      'endDate': '2025-07-27',
      'owners': [
        {
          'name': 'John Smith',
          'phone': '(555) 123-4567',
          'email': 'john.smith@example.com',
          'preferredContact': 'Text message'
        },
        {
          'name': 'Sarah Smith',
          'phone': '(555) 987-6543',
          'email': 'sarah.smith@example.com',
          'preferredContact': 'Email'
        }
      ],
      'address': '123 Pet Avenue, Petville, NY 10001',
      'entryInstructions': 'Key is hidden under the flowerpot on the front porch. Security code is 1234.',
      'generalInstructions': 'Max needs to be walked twice a day. He likes to play fetch in the backyard. Please ensure fresh water is available at all times.',
      'dailySchedule': [
        {
          'time': '07:00 AM',
          'task': 'Morning Walk',
          'details': 'Walk for 20-30 minutes, usual route around the park'
        },
        {
          'time': '08:00 AM',
          'task': 'Breakfast',
          'details': '1 cup of dog food with medication mixed in (in kitchen cabinet)'
        },
        {
          'time': '12:00 PM',
          'task': 'Midday Check',
          'details': 'Quick potty break and fresh water'
        },
        {
          'time': '06:00 PM',
          'task': 'Evening Walk',
          'details': 'Walk for 30 minutes, can explore different routes'
        },
        {
          'time': '07:00 PM',
          'task': 'Dinner',
          'details': '1 cup of dog food (no medication at night)'
        }
      ],
      'vetInfo': {
        'name': 'Dr. Emma Wilson',
        'clinic': 'Petville Veterinary Clinic',
        'address': '456 Vet Street, Petville, NY 10002',
        'phone': '(555) 234-5678',
        'notes': 'Max is due for his annual checkup on July 25th. Please call if any concerning symptoms appear.'
      },
      'groomerInfo': {
        'name': 'Paws & Claws Grooming',
        'address': '789 Groom Lane, Petville, NY 10003',
        'phone': '(555) 345-6789',
        'notes': 'Max has an appointment on July 23rd at 2:00 PM. Drop-off only, they will call when ready for pickup.'
      },
      'emergencyInstructions': 'In case of emergency, contact the Petville Emergency Vet Hospital at (555) 911-PETS. They are open 24/7. Pet insurance information is available in the pet profile section of this app.'
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Page'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message owners feature is for demo only')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showJobOptions(context);
            },
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPetHeader(),
                  _buildJobStatus(),
                  _buildJobDates(),
                  _buildSectionHeader('Owners'),
                  _buildOwnersSection(),
                  _buildSectionHeader('Location & Access'),
                  _buildLocationSection(),
                  _buildSectionHeader('Job Instructions'),
                  _buildInstructionsSection(),
                  _buildSectionHeader('Daily Schedule'),
                  _buildDailySchedule(),
                  _buildSectionHeader('Veterinary Information'),
                  _buildVetSection(),
                  _buildSectionHeader('Groomer Information'),
                  _buildGroomerSection(),
                  _buildSectionHeader('Emergency Instructions'),
                  _buildEmergencySection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add daily update feature is for demo only')),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildPetHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Pet image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
              image: const DecorationImage(
                image: AssetImage('assets/images/golden_retriever.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Pet name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _jobDetails['petName'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.pets, color: Colors.deepPurple.shade300),
                    const SizedBox(width: 4),
                    const Text('Golden Retriever'),
                    const SizedBox(width: 8),
                    Icon(Icons.cake, color: Colors.deepPurple.shade300),
                    const SizedBox(width: 4),
                    const Text('4 years old'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobStatus() {
    final bool isActive = _jobDetails['isActive'];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? Colors.green.shade300 : Colors.orange.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.schedule,
            color: isActive ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            isActive ? 'Active Job' : 'Scheduled Job',
            style: TextStyle(
              color: isActive ? Colors.green.shade800 : Colors.orange.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDates() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.deepPurple.shade300),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(_jobDetails['startDate']),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'End Date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.deepPurple.shade300),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(_jobDetails['endDate']),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Format date string to readable format
  String _formatDate(String dateStr) {
    final parts = dateStr.split('-');
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    final year = parts[0];
    
    return '${months[month]} $day, $year';
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
  
  Widget _buildOwnersSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _jobDetails['owners'].length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade200,
        ),
        itemBuilder: (context, index) {
          final owner = _jobDetails['owners'][index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple.shade100,
              child: Text(
                owner['name'].substring(0, 1),
                style: TextStyle(
                  color: Colors.deepPurple.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(owner['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phone: ${owner['phone']}'),
                Text('Email: ${owner['email']}'),
                Text('Preferred Contact: ${owner['preferredContact']}'),
              ],
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.call),
              color: Colors.green,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling ${owner['name']} (demo)')),
                );
              },
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildLocationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.location_on, color: Colors.deepPurple.shade400),
            title: const Text('Address'),
            subtitle: Text(_jobDetails['address']),
            trailing: IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Open in Maps feature is for demo only')),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.vpn_key, color: Colors.deepPurple.shade400),
            title: const Text('Entry Instructions'),
            subtitle: Text(_jobDetails['entryInstructions']),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildInstructionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _jobDetails['generalInstructions'],
            style: TextStyle(color: Colors.grey.shade800),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('View detailed instructions feature is for demo only')),
              );
            },
            icon: const Icon(Icons.article),
            label: const Text('View Detailed Instructions'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDailySchedule() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var task in _jobDetails['dailySchedule'])
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                radius: 20,
                child: Text(
                  task['time'].substring(0, 5),
                  style: TextStyle(
                    color: Colors.deepPurple.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(task['task']),
              subtitle: Text(task['details']),
              trailing: IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Marked ${task['task']} as complete (demo)')),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildVetSection() {
    final vet = _jobDetails['vetInfo'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.medical_services, color: Colors.deepPurple.shade400),
            title: Text(vet['name']),
            subtitle: Text(vet['clinic']),
            trailing: IconButton(
              icon: const Icon(Icons.call),
              color: Colors.green,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling ${vet['name']} (demo)')),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Address'),
            subtitle: Text(vet['address']),
            trailing: IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Open vet in Maps feature is for demo only')),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Notes'),
            subtitle: Text(vet['notes']),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildGroomerSection() {
    final groomer = _jobDetails['groomerInfo'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.content_cut, color: Colors.deepPurple.shade400),
            title: Text(groomer['name']),
            trailing: IconButton(
              icon: const Icon(Icons.call),
              color: Colors.green,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling ${groomer['name']} (demo)')),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Address'),
            subtitle: Text(groomer['address']),
            trailing: IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Open groomer in Maps feature is for demo only')),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Notes'),
            subtitle: Text(groomer['notes']),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmergencySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emergency, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Text(
                'Emergency Instructions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(_jobDetails['emergencyInstructions']),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Emergency call feature is for demo only')),
                );
              },
              icon: const Icon(Icons.phone),
              label: const Text('CALL EMERGENCY VET'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showJobOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Message Owners'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message owners feature is for demo only')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_a_photo),
                title: const Text('Add Daily Update'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add daily update feature is for demo only')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Request Schedule Change'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request schedule change feature is for demo only')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel_outlined, color: Colors.red.shade700),
                title: Text('Cancel Job', style: TextStyle(color: Colors.red.shade700)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cancel job feature is for demo only')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
