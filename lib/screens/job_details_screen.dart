import 'package:flutter/material.dart';
import 'access_instructions_screen.dart';
import 'daily_updates_screen.dart';
import '../models/job.dart';
import '../services/demo_data_service.dart';
import '../services/image_service.dart';
import '../widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  
  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  late List<Map<String, dynamic>?> pets;
  late Map<String, dynamic>? owner;
  
  @override
  void initState() {
    super.initState();
    // Get pet and owner data
    pets = widget.job.petIds.map((id) => DemoDataService.getPetById(id)).toList();
    owner = DemoDataService.getPetOwnerById(widget.job.petOwnerId);
  }

  @override
  Widget build(BuildContext context) {
    final petNames = pets.where((pet) => pet != null).map((pet) => pet!['name'] as String).join(' & ');
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Job Details - $petNames',
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildJobHeader(),
            _buildPetProfilesSection(),
            _buildVeterinarianContactsSection(),
            _buildJobInfoSection(),
            _buildDailyUpdateSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildJobHeader() {
    final validPets = pets.where((pet) => pet != null).toList();
    final now = DateTime.now();
    final isOngoing = now.isAfter(widget.job.startDate) && now.isBefore(widget.job.endDate);
    final daysRemaining = widget.job.endDate.difference(now).inDays;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.deepPurple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Pet avatars section
              if (validPets.length == 1)
                // Single pet display
                Column(
                  children: [
                    ImageService.userAvatar(
                      userName: validPets.first!['name'] as String,
                      radius: 50,
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      validPets.first!['name'] as String,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${validPets.first!['type']} • ${validPets.first!['age']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                )
              else
                // Multiple pets display
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: validPets.take(3).map((pet) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ImageService.userAvatar(
                          userName: pet!['name'] as String,
                          radius: 35,
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      validPets.map((pet) => pet!['name'] as String).join(' & '),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${validPets.length} pets in this job',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 20),
              
              // Job status and timing
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isOngoing ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isOngoing ? Colors.green.withOpacity(0.5) : Colors.orange.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOngoing ? Icons.play_circle_filled : Icons.schedule,
                      color: isOngoing ? Colors.green.shade200 : Colors.orange.shade200,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOngoing ? 'In Progress' : 'Starting Soon',
                      style: TextStyle(
                        color: isOngoing ? Colors.green.shade200 : Colors.orange.shade200,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                daysRemaining > 0 
                    ? '$daysRemaining day${daysRemaining != 1 ? 's' : ''} remaining'
                    : 'Ending today',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPetProfilesSection() {
    final validPets = pets.where((pet) => pet != null).toList();
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            validPets.length == 1 ? 'Pet Profile' : 'Pet Profiles',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Pet profile cards
          ...validPets.map((pet) => _buildPetProfileCard(pet!)).toList(),
        ],
      ),
    );
  }
  
  Widget _buildPetProfileCard(Map<String, dynamic> pet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet header with avatar and basic info
            Row(
              children: [
                ImageService.userAvatar(
                  userName: pet['name'] as String,
                  radius: 30,
                  backgroundColor: Colors.deepPurple.shade100,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet['name'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pet['type']} • ${pet['age']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Health status indicators
                Column(
                  children: [
                    if (pet['vaccinated'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.vaccines, size: 14, color: Colors.green.shade700),
                            const SizedBox(width: 4),
                            Text(
                              'Vaccinated',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (pet['microchipped'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.memory, size: 14, color: Colors.blue.shade700),
                            const SizedBox(width: 4),
                            Text(
                              'Chipped',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Pet details grid
            Row(
              children: [
                Expanded(
                  child: _buildPetDetailItem(
                    Icons.monitor_weight,
                    'Weight',
                    pet['weight'] as String,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPetDetailItem(
                    Icons.cake,
                    'Age',
                    pet['age'] as String,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Personality section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.psychology, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Personality',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet['personality'] as String,
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Special needs section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.medical_services, color: Colors.amber.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Special Care Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet['specialNeeds'] as String,
                    style: TextStyle(
                      color: Colors.amber.shade800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPetDetailItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobInfoSection() {
    final startDate = widget.job.startDate;
    final endDate = widget.job.endDate;
    final duration = endDate.difference(startDate).inDays + 1;
    final dailyRate = 45; // This could be added to the Job model in the future
    final totalPayment = dailyRate * duration;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Job Information',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.calendar_today, 
            'Dates', 
            '${_formatDate(startDate)} - ${_formatDate(endDate)} ($duration days)'
          ),
          const SizedBox(height: 12),
          if (owner != null) ...[
            _buildInfoRow(Icons.location_on, 'Location', owner!['address'] as String),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.person, 'Owner', owner!['name'] as String),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.phone, 'Contact', owner!['phone'] as String),
            const SizedBox(height: 12),
          ],
          _buildInfoRow(Icons.attach_money, 'Payment', '\$$dailyRate/day (\$$totalPayment total)'),
          const SizedBox(height: 24),
          // Access Instructions Card
          Card(
            elevation: 2,
            color: Colors.amber.shade50,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccessInstructionsScreen(jobId: 1),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.vpn_key, color: Colors.amber.shade800),
                        const SizedBox(width: 8),
                        const Text(
                          'Apartment Access Instructions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.apartment, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Riverside Towers - Apt 4B'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.amber.shade800),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Complex entry requires gate code and lockbox access'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccessInstructionsScreen(jobId: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('View Details'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Special Instructions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Max needs to take his medication twice daily with meals. He loves afternoon walks and playing fetch in the backyard. Please make sure he has fresh water available at all times.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyUpdateSection() {
    final validPets = pets.where((pet) => pet != null).toList();
    final petNames = validPets.map((pet) => pet!['name'] as String).toList();
    
    // Generate dynamic updates based on the pets in this job
    final List<String> updates = _generateDynamicUpdates(petNames);
    
    // Sample completed tasks for demonstration
    final List<bool> completed = [true, true, false, true];
    final completionPercentage = completed.where((task) => task).length / completed.length;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Updates',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Progress indicator
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: completionPercentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(completionPercentage * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${completed.where((task) => task).length} of ${completed.length} tasks completed today',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 16),
          
          // Recent updates - showing 3 most recent updates
          ...updates.take(3).map((update) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    update,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
          
          // View all button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => DailyUpdatesScreen(
                        jobId: widget.job.id,
                        petName: petNames.join(' & '),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('View All Updates'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<String> _generateDynamicUpdates(List<String> petNames) {
    if (petNames.isEmpty) return ['No pets assigned to this job'];
    
    if (petNames.length == 1) {
      final petName = petNames.first;
      return [
        '$petName enjoyed their afternoon walk today!',
        'Fed $petName on schedule with their favorite treats.',
        '$petName had a great playtime session in the yard!',
        'Gave $petName their medication as instructed.',
      ];
    } else {
      final petNamesStr = petNames.join(' and ');
      return [
        '$petNamesStr had a wonderful walk together today!',
        'Both pets were fed on schedule and enjoyed their meals.',
        '$petNamesStr played together beautifully - they\'re great companions!',
        'Administered medications to both pets as per instructions.',
        'Both pets are happy and healthy today!',
      ];
    }
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: FilledButton(
              onPressed: () {
                // Handle confirmation action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job confirmed')),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Confirm'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: () {
                // Handle cancellation action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job cancelled')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccessInstructionsScreen(jobId: 1),
                  ),
                );
              },
              icon: const Icon(Icons.location_on),
              label: const Text('Access'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVeterinarianContactsSection() {
    final validPets = pets.where((pet) => pet != null).toList();
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Veterinarian Contacts',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Vet contact cards for each pet
          ...validPets.map((pet) => _buildPetVetContactsCard(pet!)).toList(),
        ],
      ),
    );
  }
  
  Widget _buildPetVetContactsCard(Map<String, dynamic> pet) {
    final primaryVet = pet['primaryVet'] as Map<String, dynamic>?;
    final emergencyVet = pet['emergencyVet'] as Map<String, dynamic>?;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet name header
            Row(
              children: [
                ImageService.userAvatar(
                  userName: pet['name'] as String,
                  radius: 20,
                  backgroundColor: Colors.deepPurple.withOpacity(0.1),
                ),
                const SizedBox(width: 12),
                Text(
                  '${pet['name']}\'s Veterinarians',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Primary vet card
            if (primaryVet != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Primary',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            primaryVet['name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      primaryVet['clinic'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          primaryVet['phone'] as String,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          primaryVet['email'] as String,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            
            // Emergency vet card
            if (emergencyVet != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Emergency',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            emergencyVet['name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      emergencyVet['clinic'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          emergencyVet['phone'] as String,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          emergencyVet['email'] as String,
                          style: const TextStyle(fontSize: 14),
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
}
