import 'package:flutter/material.dart';

/// Job Creation model for Pet Owners
/// Represents a new job request with pets, instructions, schedule, and timeline
class JobCreation {
  final String id;
  final List<String> selectedPetIds;
  final String specialInstructions;
  final String address;
  final DateTime startDate;
  final DateTime endDate;
  final List<DailyTask> dailyTasks;
  final String serviceType;
  final double? estimatedCost;
  final String status;
  final DateTime createdAt;

  JobCreation({
    required this.id,
    required this.selectedPetIds,
    required this.specialInstructions,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.dailyTasks,
    required this.serviceType,
    this.estimatedCost,
    this.status = 'draft',
    required this.createdAt,
  });

  factory JobCreation.fromJson(Map<String, dynamic> json) {
    return JobCreation(
      id: json['id'],
      selectedPetIds: List<String>.from(json['selectedPetIds']),
      specialInstructions: json['specialInstructions'],
      address: json['address'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      dailyTasks: (json['dailyTasks'] as List)
          .map((task) => DailyTask.fromJson(task))
          .toList(),
      serviceType: json['serviceType'],
      estimatedCost: json['estimatedCost']?.toDouble(),
      status: json['status'] ?? 'draft',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'selectedPetIds': selectedPetIds,
      'specialInstructions': specialInstructions,
      'address': address,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'dailyTasks': dailyTasks.map((task) => task.toJson()).toList(),
      'serviceType': serviceType,
      'estimatedCost': estimatedCost,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  JobCreation copyWith({
    String? id,
    List<String>? selectedPetIds,
    String? specialInstructions,
    String? address,
    DateTime? startDate,
    DateTime? endDate,
    List<DailyTask>? dailyTasks,
    String? serviceType,
    double? estimatedCost,
    String? status,
    DateTime? createdAt,
  }) {
    return JobCreation(
      id: id ?? this.id,
      selectedPetIds: selectedPetIds ?? this.selectedPetIds,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      address: address ?? this.address,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dailyTasks: dailyTasks ?? this.dailyTasks,
      serviceType: serviceType ?? this.serviceType,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }

  bool get isValid {
    return selectedPetIds.isNotEmpty &&
           address.trim().isNotEmpty &&
           startDate.isBefore(endDate) &&
           serviceType.isNotEmpty;
  }
}

/// Daily Task model for scheduled activities
class DailyTask {
  final String id;
  final String title;
  final String description;
  final TimeOfDay time;
  final String category; // feeding, walking, medication, etc.
  final bool isRequired;
  final String? petId; // specific pet or null for all pets

  DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    this.isRequired = true,
    this.petId,
  });

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: TimeOfDay(
        hour: json['time']['hour'],
        minute: json['time']['minute'],
      ),
      category: json['category'],
      isRequired: json['isRequired'] ?? true,
      petId: json['petId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'category': category,
      'isRequired': isRequired,
      'petId': petId,
    };
  }

  DailyTask copyWith({
    String? id,
    String? title,
    String? description,
    TimeOfDay? time,
    String? category,
    bool? isRequired,
    String? petId,
  }) {
    return DailyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      category: category ?? this.category,
      isRequired: isRequired ?? this.isRequired,
      petId: petId ?? this.petId,
    );
  }

  String get formattedTime {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get displayTime {
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final displayHour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    return '$displayHour:$minute $period';
  }
}

/// Service type options for job creation
class ServiceType {
  static const String petSitting = 'Pet Sitting';
  static const String dogWalking = 'Dog Walking';
  static const String dropInVisit = 'Drop-in Visit';
  static const String overnightCare = 'Overnight Care';
  static const String daycare = 'Daycare';

  static List<String> get all => [
    petSitting,
    dogWalking,
    dropInVisit,
    overnightCare,
    daycare,
  ];

  static String getDescription(String serviceType) {
    switch (serviceType) {
      case petSitting:
        return 'Full-time care at your home while you\'re away';
      case dogWalking:
        return 'Regular walks and exercise for your dog';
      case dropInVisit:
        return 'Short visits to check on and care for your pets';
      case overnightCare:
        return 'Overnight stays to provide continuous care';
      case daycare:
        return 'Daytime care and supervision for your pets';
      default:
        return 'Professional pet care services';
    }
  }
}

/// Task category options for daily tasks
class TaskCategory {
  static const String feeding = 'Feeding';
  static const String walking = 'Walking';
  static const String medication = 'Medication';
  static const String playtime = 'Playtime';
  static const String grooming = 'Grooming';
  static const String cleaning = 'Cleaning';
  static const String other = 'Other';

  static List<String> get all => [
    feeding,
    walking,
    medication,
    playtime,
    grooming,
    cleaning,
    other,
  ];

  static String getIcon(String category) {
    switch (category) {
      case feeding:
        return '🍽️';
      case walking:
        return '🚶';
      case medication:
        return '💊';
      case playtime:
        return '🎾';
      case grooming:
        return '✂️';
      case cleaning:
        return '🧹';
      default:
        return '📝';
    }
  }
}
