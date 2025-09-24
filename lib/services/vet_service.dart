import 'package:flutter/material.dart';

class VetContact {
  final int id;
  final String name;
  final String clinicName;
  final String address;
  final String phone;
  final String email;
  final String specialization;
  final bool isPrimary;
  final bool isEmergency;
  final List<String> availableHours;
  final String imageUrl;

  const VetContact({
    required this.id,
    required this.name,
    required this.clinicName,
    required this.address,
    required this.phone,
    required this.email,
    this.specialization = 'General',
    this.isPrimary = false,
    this.isEmergency = false,
    this.availableHours = const ['Mon-Fri: 9:00 AM - 5:00 PM'],
    this.imageUrl = '',
  });
}

class VetService {
  // Sample vet contacts for display purposes
  static List<VetContact> getVetContacts(int petId) {
    // In a real app, this would fetch data from a database or API based on the pet ID
    return [
      VetContact(
        id: 1,
        name: 'Dr. Sarah Johnson',
        clinicName: 'City Pet Clinic',
        address: '123 Main Street, Anytown, USA 12345',
        phone: '(555) 123-4567',
        email: 'dr.johnson@citypetclinic.com',
        specialization: 'General Veterinarian',
        isPrimary: true,
        isEmergency: false,
        availableHours: ['Mon-Fri: 9:00 AM - 5:00 PM', 'Sat: 10:00 AM - 2:00 PM'],
      ),
      VetContact(
        id: 2,
        name: 'Dr. Michael Chen',
        clinicName: 'Emergency Animal Hospital',
        address: '456 Oak Avenue, Anytown, USA 12345',
        phone: '(555) 987-6543',
        email: 'dr.chen@emergencyanimalhospital.com',
        specialization: 'Emergency Medicine',
        isPrimary: false,
        isEmergency: true,
        availableHours: ['24/7 Emergency Service'],
      ),
      VetContact(
        id: 3,
        name: 'Dr. Emily Rodriguez',
        clinicName: 'Healthy Paws Veterinary',
        address: '789 Pine Street, Anytown, USA 12345',
        phone: '(555) 456-7890',
        email: 'dr.rodriguez@healthypaws.com',
        specialization: 'Dermatology',
        isPrimary: false,
        isEmergency: false,
        availableHours: ['Tue & Thu: 10:00 AM - 6:00 PM', 'Fri: 9:00 AM - 3:00 PM'],
      ),
    ];
  }

  // Get primary vet contact
  static VetContact? getPrimaryVet(int petId) {
    final contacts = getVetContacts(petId);
    for (var contact in contacts) {
      if (contact.isPrimary) {
        return contact;
      }
    }
    return contacts.isNotEmpty ? contacts.first : null;
  }

  // Get emergency vet contact
  static VetContact? getEmergencyVet(int petId) {
    final contacts = getVetContacts(petId);
    for (var contact in contacts) {
      if (contact.isEmergency) {
        return contact;
      }
    }
    return null;
  }
}

// Widget to display vet contact details in a card
class VetContactCard extends StatelessWidget {
  final VetContact vet;
  final VoidCallback? onTap;
  final bool showActions;
  
  const VetContactCard({
    super.key,
    required this.vet,
    this.onTap,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: vet.isEmergency ? Colors.red.shade200 : Colors.green.shade200,
                  child: Icon(
                    vet.isEmergency ? Icons.local_hospital : Icons.medical_services,
                    color: vet.isEmergency ? Colors.red : Colors.green,
                    size: 30,
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
                              vet.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (vet.isPrimary)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
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
                          if (vet.isEmergency)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
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
                        ],
                      ),
                      Text(
                        vet.clinicName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        vet.specialization,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, vet.address),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, vet.phone),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, vet.email),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, vet.availableHours.join('\n')),
            
            if (showActions) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone),
                      label: const Text('Call'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.email),
                      label: const Text('Email'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Book'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
