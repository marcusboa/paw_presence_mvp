import '../models/job_creation.dart';
import '../services/pet_owner_demo_data_service.dart';
import 'package:flutter/material.dart';

/// Job Creation Service for Pet Owners
/// Manages job creation, validation, and persistence
class JobCreationService {
  // Singleton pattern for consistent data access
  static final JobCreationService _instance = JobCreationService._internal();
  factory JobCreationService() => _instance;
  JobCreationService._internal();

  // In-memory storage for demo purposes
  static final List<JobCreation> _draftJobs = [];
  static final List<JobCreation> _submittedJobs = [];

  /// Create a new job draft
  static JobCreation createNewJob() {
    final job = JobCreation(
      id: 'job_${DateTime.now().millisecondsSinceEpoch}',
      selectedPetIds: [],
      specialInstructions: '',
      address: '',
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 2)),
      dailyTasks: [],
      serviceType: ServiceType.petSitting,
      createdAt: DateTime.now(),
    );
    
    _draftJobs.add(job);
    return job;
  }

  /// Update an existing job
  static void updateJob(JobCreation updatedJob) {
    final index = _draftJobs.indexWhere((job) => job.id == updatedJob.id);
    if (index != -1) {
      _draftJobs[index] = updatedJob;
    }
  }

  /// Submit a job for processing
  static Future<bool> submitJob(JobCreation job) async {
    // Simulate submission delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!job.isValid) {
      return false;
    }

    // Move from draft to submitted
    _draftJobs.removeWhere((j) => j.id == job.id);
    _submittedJobs.add(job.copyWith(status: 'submitted'));
    
    return true;
  }

  /// Get all draft jobs
  static List<JobCreation> getDraftJobs() {
    return List.from(_draftJobs);
  }

  /// Get all submitted jobs
  static List<JobCreation> getSubmittedJobs() {
    return List.from(_submittedJobs);
  }

  /// Delete a draft job
  static void deleteDraftJob(String jobId) {
    _draftJobs.removeWhere((job) => job.id == jobId);
  }

  /// Get available pets for job creation
  static List<Map<String, dynamic>> getAvailablePets() {
    return PetOwnerDemoDataService.getActivePets();
  }

  /// Get pet details by ID
  static Map<String, dynamic>? getPetById(String petId) {
    return PetOwnerDemoDataService.getPetById(petId);
  }

  /// Create default daily tasks based on selected pets
  static List<DailyTask> createDefaultTasks(List<String> petIds) {
    final tasks = <DailyTask>[];
    final pets = petIds.map((id) => getPetById(id)).where((pet) => pet != null).toList();
    
    // Add feeding tasks
    tasks.add(DailyTask(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}_1',
      title: 'Morning Feeding',
      description: 'Feed all pets their morning meal',
      time: const TimeOfDay(hour: 8, minute: 0),
      category: TaskCategory.feeding,
    ));
    
    tasks.add(DailyTask(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}_2',
      title: 'Evening Feeding',
      description: 'Feed all pets their evening meal',
      time: const TimeOfDay(hour: 18, minute: 0),
      category: TaskCategory.feeding,
    ));

    // Add walking tasks for dogs
    final hasDogs = pets.any((pet) => pet!['type'] == 'Dog');
    if (hasDogs) {
      tasks.add(DailyTask(
        id: 'task_${DateTime.now().millisecondsSinceEpoch}_3',
        title: 'Morning Walk',
        description: 'Take dogs for their morning walk',
        time: const TimeOfDay(hour: 9, minute: 0),
        category: TaskCategory.walking,
      ));
      
      tasks.add(DailyTask(
        id: 'task_${DateTime.now().millisecondsSinceEpoch}_4',
        title: 'Evening Walk',
        description: 'Take dogs for their evening walk',
        time: const TimeOfDay(hour: 19, minute: 0),
        category: TaskCategory.walking,
      ));
    }

    return tasks;
  }

  /// Validate job before submission
  static Map<String, String> validateJob(JobCreation job) {
    final errors = <String, String>{};

    if (job.selectedPetIds.isEmpty) {
      errors['pets'] = 'Please select at least one pet';
    }

    if (job.address.trim().isEmpty) {
      errors['address'] = 'Address is required';
    }

    if (job.startDate.isBefore(DateTime.now())) {
      errors['startDate'] = 'Start date cannot be in the past';
    }

    if (job.endDate.isBefore(job.startDate)) {
      errors['endDate'] = 'End date must be after start date';
    }

    if (job.serviceType.isEmpty) {
      errors['serviceType'] = 'Please select a service type';
    }

    return errors;
  }

  /// Calculate estimated cost for a job
  static double calculateEstimatedCost(JobCreation job) {
    const baseRates = {
      ServiceType.petSitting: 40.0,
      ServiceType.dogWalking: 25.0,
      ServiceType.dropInVisit: 20.0,
      ServiceType.overnightCare: 60.0,
      ServiceType.daycare: 35.0,
    };

    final baseRate = baseRates[job.serviceType] ?? 30.0;
    final days = job.durationInDays;
    final petMultiplier = 1.0 + (job.selectedPetIds.length - 1) * 0.3; // 30% extra per additional pet

    return baseRate * days * petMultiplier;
  }

  /// Get suggested addresses based on user's previous jobs or profile
  static List<String> getSuggestedAddresses() {
    return [
      '123 Main Street, Sydney NSW 2000',
      '456 George Street, Sydney NSW 2000',
      '789 Pitt Street, Sydney NSW 2000',
    ];
  }

  /// Create a sample task for demonstration
  static DailyTask createSampleTask(String category, {String? petId}) {
    final taskId = 'task_${DateTime.now().millisecondsSinceEpoch}';
    
    switch (category) {
      case TaskCategory.feeding:
        return DailyTask(
          id: taskId,
          title: 'Feeding Time',
          description: 'Feed the pets according to their dietary requirements',
          time: const TimeOfDay(hour: 8, minute: 0),
          category: category,
          petId: petId,
        );
      case TaskCategory.walking:
        return DailyTask(
          id: taskId,
          title: 'Walk Time',
          description: 'Take the dogs for a walk around the neighborhood',
          time: const TimeOfDay(hour: 9, minute: 0),
          category: category,
          petId: petId,
        );
      case TaskCategory.medication:
        return DailyTask(
          id: taskId,
          title: 'Medication',
          description: 'Administer prescribed medication',
          time: const TimeOfDay(hour: 12, minute: 0),
          category: category,
          petId: petId,
        );
      case TaskCategory.playtime:
        return DailyTask(
          id: taskId,
          title: 'Play Time',
          description: 'Interactive play session with toys',
          time: const TimeOfDay(hour: 15, minute: 0),
          category: category,
          petId: petId,
        );
      case TaskCategory.grooming:
        return DailyTask(
          id: taskId,
          title: 'Grooming',
          description: 'Brush and groom the pets',
          time: const TimeOfDay(hour: 16, minute: 0),
          category: category,
          petId: petId,
        );
      case TaskCategory.cleaning:
        return DailyTask(
          id: taskId,
          title: 'Cleaning',
          description: 'Clean litter box or living area',
          time: const TimeOfDay(hour: 17, minute: 0),
          category: category,
          petId: petId,
        );
      default:
        return DailyTask(
          id: taskId,
          title: 'Custom Task',
          description: 'Custom care task',
          time: const TimeOfDay(hour: 10, minute: 0),
          category: category,
          petId: petId,
        );
    }
  }

  /// Get task suggestions based on service type and pets
  static List<String> getTaskSuggestions(String serviceType, List<String> petIds) {
    final suggestions = <String>[];

    switch (serviceType) {
      case ServiceType.petSitting:
        suggestions.addAll([
          'Morning and evening feeding',
          'Fresh water daily',
          'Litter box cleaning (cats)',
          'Daily walks (dogs)',
          'Playtime and interaction',
          'Medication if needed',
        ]);
        break;
      case ServiceType.dogWalking:
        suggestions.addAll([
          'Morning walk (30 minutes)',
          'Afternoon walk (20 minutes)',
          'Evening walk (30 minutes)',
          'Fresh water after walks',
        ]);
        break;
      case ServiceType.dropInVisit:
        suggestions.addAll([
          'Check food and water',
          'Quick playtime',
          'Litter box check',
          'Security check',
        ]);
        break;
      case ServiceType.overnightCare:
        suggestions.addAll([
          'Evening routine',
          'Overnight supervision',
          'Morning care',
          'Regular feeding schedule',
        ]);
        break;
    }

    return suggestions;
  }
}
