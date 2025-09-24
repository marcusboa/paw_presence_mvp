

/// Comprehensive demo data service for Pet Owner functionality
/// Provides realistic data for bookings, pets, sitters, and notifications
class PetOwnerDemoDataService {
  // Singleton pattern for consistent data access
  static final PetOwnerDemoDataService _instance = PetOwnerDemoDataService._internal();
  factory PetOwnerDemoDataService() => _instance;
  PetOwnerDemoDataService._internal();

  // Static data that simulates a realistic pet owner experience
  static final List<Map<String, dynamic>> _petOwnerPets = [
    {
      'id': 'pet_1',
      'name': 'Max',
      'type': 'Dog',
      'breed': 'Golden Retriever',
      'age': 3,
      'weight': '65 lbs',
      'imageUrl': 'assets/images/golden_retriever.jpg',
      'description': 'Friendly and energetic golden retriever who loves walks and playing fetch.',
      'medicalNotes': 'Up to date on all vaccinations. Takes daily joint supplement.',
      'careInstructions': 'Needs 2 walks per day, loves treats, friendly with other dogs.',
      'emergencyContact': 'Dr. Smith - Animal Hospital (555) 123-4567',
      'insuranceInfo': {
        'provider': 'PetSure Insurance',
        'policyNumber': 'PS-789456123',
        'groupNumber': 'GRP-001',
        'memberID': 'MAX-001-GR',
        'coverageType': 'Comprehensive Plus',
        'deductible': '\$250 annual',
        'coverageLimit': '\$15,000 per year',
        'emergencyContact': '1-800-PET-SURE (1-800-738-7873)',
        'claimSubmission': 'claims@petsure.com',
        'preAuthRequired': 'For procedures over \$500',
        'notes': 'Covers accidents, illnesses, hereditary conditions, and wellness care. 90% reimbursement after deductible.'
      },
      'isActive': true,
      'lastBooking': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 'pet_2',
      'name': 'Luna',
      'type': 'Cat',
      'breed': 'Siamese',
      'age': 2,
      'weight': '8 lbs',
      'imageUrl': 'assets/images/siamese_cat.jpg',
      'description': 'Playful and curious Siamese cat who enjoys interactive toys.',
      'medicalNotes': 'Indoor cat, spayed, no known allergies.',
      'careInstructions': 'Feed twice daily, clean litter box, enjoys window perch.',
      'emergencyContact': 'Dr. Johnson - Pet Care Clinic (555) 987-6543',
      'insuranceInfo': {
        'provider': 'Healthy Paws Pet Insurance',
        'policyNumber': 'HP-456789012',
        'groupNumber': 'GRP-002',
        'memberID': 'LUNA-002-SI',
        'coverageType': 'Accident & Illness',
        'deductible': '\$100 annual',
        'coverageLimit': '\$10,000 per year',
        'emergencyContact': '1-855-898-8991',
        'claimSubmission': 'claims@healthypawspetinsurance.com',
        'preAuthRequired': 'For procedures over \$300',
        'notes': 'Covers accidents and illnesses with 80% reimbursement. Hereditary conditions covered after 12-month waiting period.'
      },
      'isActive': true,
      'lastBooking': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': 'pet_3',
      'name': 'Charlie',
      'type': 'Dog',
      'breed': 'Beagle',
      'age': 4,
      'weight': '22 lbs',
      'imageUrl': 'assets/images/beagle.jpg',
      'description': 'Calm and affectionate Beagle with a gentle personality.',
      'medicalNotes': 'Healthy and active, no known allergies.',
      'careInstructions': 'Enjoys long walks, loves treats, good with other dogs.',
      'emergencyContact': 'Dr. Brown - Specialty Vet (555) 456-7890',
      'insuranceInfo': {
        'provider': 'Embrace Pet Insurance',
        'policyNumber': 'EM-123789456',
        'groupNumber': 'GRP-003',
        'memberID': 'CHARLIE-003-FB',
        'coverageType': 'Complete Coverage',
        'deductible': '\$200 annual',
        'coverageLimit': '\$25,000 per year',
        'emergencyContact': '1-800-511-9172',
        'claimSubmission': 'claims@embracepetinsurance.com',
        'preAuthRequired': 'For procedures over \$750',
        'notes': 'Includes wellness coverage, prescription medications, and breed-specific conditions. 90% reimbursement with diminishing deductible.'
      },
      'isActive': true,
      'lastBooking': DateTime.now().subtract(const Duration(days: 30)),
    },
  ];

  static final List<Map<String, dynamic>> _availableSitters = [
    {
      'id': 'sitter_1',
      'name': 'Sarah Johnson',
      'hourlyRate': 25,
      'imageUrl': 'assets/images/sitter_sarah.jpg',
      'bio': 'Professional pet sitter with 5+ years experience. Specializes in dog walking and overnight care.',
      'services': ['Dog Walking', 'Pet Sitting', 'Overnight Care'],
      'availability': 'Available Today',
      'distance': '0.8 miles away',
      'responseTime': '< 1 hour',
      'isVerified': true,
      'totalJobs': 340,
    },
    {
      'id': 'sitter_2',
      'name': 'Mike Chen',
      'hourlyRate': 22,
      'imageUrl': 'assets/images/sitter_mike.jpg',
      'bio': 'Reliable pet care provider who loves all animals. Great with both dogs and cats.',
      'services': ['Pet Sitting', 'Drop-in Visits', 'Dog Walking'],
      'availability': 'Available Tomorrow',
      'distance': '1.2 miles away',
      'responseTime': '< 2 hours',
      'isVerified': true,
      'totalJobs': 256,
    },
    {
      'id': 'sitter_3',
      'name': 'Emma Rodriguez',
      'hourlyRate': 28,
      'imageUrl': 'assets/images/sitter_emma.jpg',
      'bio': 'Veterinary student with extensive knowledge of pet health and behavior.',
      'services': ['Pet Sitting', 'Medication Administration', 'Special Needs Care'],
      'availability': 'Available This Week',
      'distance': '2.1 miles away',
      'responseTime': '< 30 minutes',
      'isVerified': true,
      'totalJobs': 98,
    },
  ];

  static final List<Map<String, dynamic>> _activeBookings = [
    {
      'id': 'booking_1',
      'petId': 'pet_1',
      'sitterId': 'sitter_1',
      'serviceType': 'Dog Walking',
      'status': 'In Progress',
      'startDate': DateTime.now().subtract(const Duration(hours: 1)),
      'endDate': DateTime.now().add(const Duration(hours: 1)),
      'duration': '2 hours',
      'totalCost': 50.0,
      'specialInstructions': 'Please take Max to the dog park if weather is nice.',
      'location': 'Central Park Area',
      'lastUpdate': DateTime.now().subtract(const Duration(minutes: 15)),
      'updates': [
        {
          'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
          'message': 'Started walk with Max! He\'s very excited.',
          'type': 'status',
          'hasPhoto': true,
        },
        {
          'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
          'message': 'Max made a new friend at the park! 🐕',
          'type': 'update',
          'hasPhoto': true,
        },
      ],
    },
    {
      'id': 'booking_2',
      'petId': 'pet_2',
      'sitterId': 'sitter_2',
      'serviceType': 'Pet Sitting',
      'status': 'Scheduled',
      'startDate': DateTime.now().add(const Duration(hours: 4)),
      'endDate': DateTime.now().add(const Duration(hours: 8)),
      'duration': '4 hours',
      'totalCost': 88.0,
      'specialInstructions': 'Luna loves to play with the feather toy. Feed at 6 PM.',
      'location': 'Your Home',
      'lastUpdate': DateTime.now().subtract(const Duration(hours: 2)),
      'updates': [
        {
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'message': 'Confirmed for this evening! Looking forward to spending time with Luna.',
          'type': 'confirmation',
          'hasPhoto': false,
        },
      ],
    },
  ];

  static final List<Map<String, dynamic>> _pastBookings = [
    {
      'id': 'booking_3',
      'petId': 'pet_1',
      'sitterId': 'sitter_1',
      'serviceType': 'Dog Walking',
      'status': 'Completed',
      'startDate': DateTime.now().subtract(const Duration(days: 2)),
      'endDate': DateTime.now().subtract(const Duration(days: 2, hours: -2)),
      'duration': '2 hours',
      'totalCost': 50.0,
      'finalReport': 'Max had a great walk! We visited the park and he played with several other dogs. He was well-behaved and seemed to really enjoy the exercise.',
    },
    {
      'id': 'booking_4',
      'petId': 'pet_2',
      'sitterId': 'sitter_3',
      'serviceType': 'Pet Sitting',
      'status': 'Completed',
      'startDate': DateTime.now().subtract(const Duration(days: 5)),
      'endDate': DateTime.now().subtract(const Duration(days: 5, hours: -6)),
      'duration': '6 hours',
      'totalCost': 168.0,
      'finalReport': 'Luna was wonderful company! She played with her toys, took a nice nap by the window, and ate her dinner right on schedule. No issues at all.',
    },
  ];

  static final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_1',
      'type': 'booking_update',
      'title': 'Max is having a great walk!',
      'message': 'Sarah just shared a photo from the park',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'isRead': false,
      'bookingId': 'booking_1',
      'priority': 'normal',
    },
    {
      'id': 'notif_2',
      'type': 'booking_reminder',
      'title': 'Upcoming pet sitting appointment',
      'message': 'Mike will arrive in 4 hours for Luna\'s care',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'isRead': false,
      'bookingId': 'booking_2',
      'priority': 'high',
    },
    {
      'id': 'notif_3',
      'type': 'booking_completed',
      'title': 'Booking completed successfully',
      'message': 'Please rate your experience with Sarah',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'bookingId': 'booking_3',
      'priority': 'normal',
    },
  ];

  // Getter methods for accessing demo data
  static List<Map<String, dynamic>> getPets() => List.from(_petOwnerPets);
  
  static List<Map<String, dynamic>> getActivePets() =>
      _petOwnerPets.where((pet) => pet['isActive'] == true).toList();
  
  static List<Map<String, dynamic>> getAvailableSitters() => List.from(_availableSitters);
  
  static List<Map<String, dynamic>> getActiveBookings() => List.from(_activeBookings);
  
  static List<Map<String, dynamic>> getPastBookings() => List.from(_pastBookings);
  
  static List<Map<String, dynamic>> getAllBookings() => [..._activeBookings, ..._pastBookings];
  
  static List<Map<String, dynamic>> getNotifications() => List.from(_notifications);
  
  static List<Map<String, dynamic>> getUnreadNotifications() =>
      _notifications.where((notif) => !notif['isRead']).toList();

  // Helper methods
  static Map<String, dynamic>? getPetById(String petId) {
    try {
      return _petOwnerPets.firstWhere((pet) => pet['id'] == petId);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getSitterById(String sitterId) {
    try {
      return _availableSitters.firstWhere((sitter) => sitter['id'] == sitterId);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getBookingById(String bookingId) {
    try {
      return getAllBookings().firstWhere((booking) => booking['id'] == bookingId);
    } catch (e) {
      return null;
    }
  }

  // Utility methods for demo interactions
  static void markNotificationAsRead(String notificationId) {
    final notifIndex = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (notifIndex != -1) {
      _notifications[notifIndex]['isRead'] = true;
    }
  }

  static void markAllNotificationsAsRead() {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
  }

  static int getUnreadNotificationCount() => getUnreadNotifications().length;

  static int getActiveBookingCount() => _activeBookings.length;

  static int getTotalPetCount() => _petOwnerPets.length;

  // Demo simulation methods
  static void simulateNewUpdate(String bookingId, String message) {
    final bookingIndex = _activeBookings.indexWhere((b) => b['id'] == bookingId);
    if (bookingIndex != -1) {
      _activeBookings[bookingIndex]['updates'].add({
        'timestamp': DateTime.now(),
        'message': message,
        'type': 'update',
        'hasPhoto': true,
      });
      _activeBookings[bookingIndex]['lastUpdate'] = DateTime.now();
      
      // Add notification
      _notifications.insert(0, {
        'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
        'type': 'booking_update',
        'title': 'New update from your sitter!',
        'message': message,
        'timestamp': DateTime.now(),
        'isRead': false,
        'bookingId': bookingId,
        'priority': 'normal',
      });
    }
  }

  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (date == today) {
      return 'Today ${_formatTime(dateTime)}';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${_formatTime(dateTime)}';
    } else if (date == today.add(const Duration(days: 1))) {
      return 'Tomorrow ${_formatTime(dateTime)}';
    } else {
      return '${_getMonthName(dateTime.month)} ${dateTime.day} ${_formatTime(dateTime)}';
    }
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

}
