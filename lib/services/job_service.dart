import '../models/job.dart';

class JobService {
  // Sample pets
  static const List<Map<String, dynamic>> _pets = [
    {'id': 1, 'name': 'Max', 'type': 'Dog', 'breed': 'Golden Retriever', 'image': 'assets/images/golden_retriever.jpg'},
    {'id': 2, 'name': 'Luna', 'type': 'Cat', 'breed': 'Siamese', 'image': 'assets/images/siamese_cat.jpg'},
    {'id': 3, 'name': 'Charlie', 'type': 'Dog', 'breed': 'Beagle', 'image': 'assets/images/beagle.jpg'},
    {'id': 4, 'name': 'Bella', 'type': 'Dog', 'breed': 'Labrador', 'image': 'assets/images/golden_retriever.jpg'}, // Using golden_retriever image as placeholder for labrador
    {'id': 5, 'name': 'Oliver', 'type': 'Cat', 'breed': 'Persian', 'image': 'assets/images/persian_cat.jpg'},
  ];
  
  // Sample jobs for display purposes
  static List<Job> getSampleJobs() {
    final today = DateTime.now();
    
    return [
      // Completed jobs (in the past)
      Job(
        id: 1,
        petOwnerId: 101,
        petSitterId: 201,
        petSitterName: "Emily Johnson",
        petIds: [1, 2], // Max and Luna
        startDate: DateTime(today.year, today.month - 2, 10),
        endDate: DateTime(today.year, today.month - 2, 17),
        isCompleted: true,
        albumIds: [1], // This job has an album
      ),
      Job(
        id: 2,
        petOwnerId: 102,
        petSitterId: 201,
        petSitterName: "Emily Johnson",
        petIds: [3], // Charlie
        startDate: DateTime(today.year, today.month - 1, 5),
        endDate: DateTime(today.year, today.month - 1, 12),
        isCompleted: true,
        albumIds: [2], // This job has an album
      ),
      
      // Current active job
      Job(
        id: 3,
        petOwnerId: 103,
        petSitterId: 201,
        petSitterName: "Emily Johnson",
        petIds: [4], // Oliver
        startDate: DateTime(today.year, today.month, today.day - 2),
        endDate: DateTime(today.year, today.month, today.day + 5),
        isCompleted: false,
      ),
      
      // Future scheduled job
      Job(
        id: 4,
        petOwnerId: 101,
        petSitterId: 202,
        petSitterName: "Michael Wilson",
        petIds: [1], // Max
        startDate: DateTime(today.year, today.month + 1, 15),
        endDate: DateTime(today.year, today.month + 1, 22),
        isCompleted: false,
      ),
    ];
  }

  // Get all pets
  static List<Map<String, dynamic>> getAllPets() {
    return [..._pets];
  }
  
  // Get a pet by ID
  static Map<String, dynamic>? getPetById(int id) {
    try {
      return _pets.firstWhere((pet) => pet['id'] == id);
    } catch (_) {
      return null;
    }
  }
  
  // Get all jobs
  static List<Job> getJobs() {
    return getSampleJobs();
  }
  
  // Get jobs by pet ID
  static List<Job> getJobsByPet(int petId) {
    final allJobs = getSampleJobs();
    return allJobs.where((job) => job.petIds.contains(petId)).toList();
  }
  
  // Get completed jobs for a pet
  static List<Job> getCompletedJobsForPet(int petId) {
    final allJobs = getSampleJobs();
    return allJobs.where((job) => 
      job.petIds.contains(petId) && job.isCompleted
    ).toList();
  }
  
  // Get completed jobs by pet ID
  static List<Job> getCompletedJobsByPet(int petId) {
    final allJobs = getJobsByPet(petId);
    return allJobs.where((job) => job.isCompleted).toList();
  }
  
  // Get job by ID
  static Job? getJobById(int jobId) {
    final allJobs = getSampleJobs();
    try {
      return allJobs.firstWhere((job) => job.id == jobId);
    } catch (e) {
      return null;
    }
  }
  
  // Format date as Month Day, Year
  static String formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
