import 'package:flutter/material.dart';
import '../services/vet_service.dart';
import '../widgets/custom_app_bar.dart';

class VetContactsScreen extends StatefulWidget {
  final int petId;

  const VetContactsScreen({super.key, required this.petId});

  @override
  State<VetContactsScreen> createState() => _VetContactsScreenState();
}

class _VetContactsScreenState extends State<VetContactsScreen> {
  late List<VetContact> vetContacts;
  
  @override
  void initState() {
    super.initState();
    // Get the vet contacts for this pet
    vetContacts = VetService.getVetContacts(widget.petId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Veterinarian Contacts',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Display-only, show a message that this is display-only
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This is a display-only feature'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency vet contact (if available)
            _buildEmergencyVetSection(),
            
            const SizedBox(height: 16),
            
            // All vet contacts
            const Text(
              'All Veterinarians',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...vetContacts.map(
              (vet) => VetContactCard(
                vet: vet,
                onTap: () {
                  // Display-only, show a message that this is display-only
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking feature is display-only'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Display-only, show a message that this is display-only
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Adding vet contacts is display-only'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Veterinarian'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyVetSection() {
    // Get emergency vet if available
    final emergencyVet = VetService.getEmergencyVet(widget.petId);
    
    if (emergencyVet == null) {
      return const SizedBox.shrink(); // No emergency vet
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.emergency, color: Colors.red),
              const SizedBox(width: 8),
              const Text(
                'Emergency Contact',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        VetContactCard(
          vet: emergencyVet,
          onTap: () {
            // Display-only, show a message that this is display-only
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking feature is display-only'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }
}
