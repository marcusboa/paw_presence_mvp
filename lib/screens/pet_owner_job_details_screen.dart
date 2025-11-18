import 'package:flutter/material.dart';

import '../services/pet_owner_demo_data_service.dart';
import '../widgets/custom_app_bar.dart';
import '../models/photo_album.dart';
import '../models/pet_photo.dart';
import '../widgets/photo_slideshow.dart';

class PetOwnerJobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> booking;

  const PetOwnerJobDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final pet = PetOwnerDemoDataService.getPetById(booking['petId']);
    final sitter = PetOwnerDemoDataService.getSitterById(booking['sitterId']);

    // Build a demo photo album from this booking's context
    final PhotoAlbum album = _buildDemoAlbum(pet, sitter);

    return Scaffold(
      appBar: CustomAppBar(
        title: '${booking['serviceType']} with ${pet?['name'] ?? ''}',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context, pet, sitter),
              const SizedBox(height: 16),
              _buildTimelineSection(context),
              const SizedBox(height: 16),
              _buildPhotosSection(context, album),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, Map<String, dynamic>? pet, Map<String, dynamic>? sitter) {
    final statusColor = booking['status'] == 'In Progress'
        ? Colors.green
        : booking['status'] == 'Scheduled'
            ? Colors.orange
            : Colors.grey;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: pet != null && pet['imageUrl'] != null
                    ? AssetImage(pet['imageUrl'] as String)
                    : null,
                child: pet == null || pet['imageUrl'] == null
                    ? const Icon(Icons.pets, size: 32)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['serviceType'] ?? 'Pet Care',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (pet != null)
                      Text(
                        pet['name'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            booking['status'] ?? '',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.schedule, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          booking['duration'] ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            child: Icon(Icons.person, size: 20),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sitter?['name'] ?? 'Your sitter',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                sitter != null ? 'Verified pet sitter' : '',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${(booking['totalCost'] as num).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Total for this booking',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          PetOwnerDemoDataService.formatDateTime(booking['startDate']),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          booking['location'] ?? 'Your home',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                  if ((booking['specialInstructions'] as String).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes, size: 16, color: Colors.amber),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              booking['specialInstructions'],
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(BuildContext context) {
    final List<dynamic> updates = booking['updates'] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Job Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  if (updates.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Your sitter will share updates here once the job begins.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                      ),
                    )
                  else
                    ...updates.map((update) {
                      final ts = update['timestamp'] as DateTime;
                      final message = update['message'] as String;
                      final hasPhoto = update['hasPhoto'] == true;

                      return ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              hasPhoto ? Icons.photo_camera : Icons.update,
                              size: 20,
                              color: hasPhoto ? Colors.deepPurple : Colors.grey.shade600,
                            ),
                          ],
                        ),
                        title: Text(
                          message,
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          PetOwnerDemoDataService.formatTimeAgo(ts),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection(BuildContext context, PhotoAlbum album) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Photos from Your Sitter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 320,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: PhotoSlideshow(
                  album: album,
                  autoPlayDurationSeconds: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PhotoAlbum _buildDemoAlbum(Map<String, dynamic>? pet, Map<String, dynamic>? sitter) {
    final start = booking['startDate'] as DateTime;
    final end = booking['endDate'] as DateTime;
    final petName = pet?['name'] as String? ?? 'Your pet';
    final sitterName = sitter?['name'] as String? ?? 'Your sitter';

    final List<dynamic> updates = booking['updates'] ?? [];

    // Generate demo photos tied to timeline updates that have hasPhoto = true
    final List<PetPhoto> photos = [];
    int idCounter = 1;
    for (final update in updates) {
      if (update['hasPhoto'] == true) {
        final ts = update['timestamp'] as DateTime;
        photos.add(PetPhoto(
          id: idCounter++,
          imageUrl: pet?['imageUrl'] as String? ?? 'assets/images/golden_retriever.jpg',
          captureDate: ts,
          caption: update['message'] as String,
          petId: 1,
          jobId: 1,
          source: 'Pet Sitter',
        ));
      }
    }

    // If no photo updates, still provide a couple of nice demo photos
    if (photos.isEmpty) {
      photos.addAll([
        PetPhoto(
          id: idCounter++,
          imageUrl: pet?['imageUrl'] as String? ?? 'assets/images/golden_retriever.jpg',
          captureDate: start.add(const Duration(hours: 1)),
          caption: 'First check-in: All is well and they are settled in.',
          petId: 1,
          jobId: 1,
          source: 'Pet Sitter',
        ),
        PetPhoto(
          id: idCounter++,
          imageUrl: pet?['imageUrl'] as String? ?? 'assets/images/golden_retriever.jpg',
          captureDate: end.subtract(const Duration(hours: 1)),
          caption: 'End of visit: Happy, fed, and ready to nap.',
          petId: 1,
          jobId: 1,
          source: 'Pet Sitter',
        ),
      ]);
    }

    photos.sort((a, b) => a.captureDate.compareTo(b.captureDate));

    return PhotoAlbum(
      id: 1,
      jobId: 1,
      petId: 1,
      petName: petName,
      sitterName: sitterName,
      startDate: start,
      endDate: end,
      creationDate: DateTime.now(),
      photos: photos,
      coverPhotoUrl: photos.isNotEmpty ? photos.first.imageUrl : null,
    );
  }
}
