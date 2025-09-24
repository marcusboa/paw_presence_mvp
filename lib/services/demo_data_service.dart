import '../models/job.dart';

class DemoDataService {
  // Realistic pet profiles with detailed information
  static final List<Map<String, dynamic>> pets = [
    {
      'id': 1,
      'name': 'Max',
      'type': 'Golden Retriever',
      'age': '3 years old',
      'personality': 'Energetic and friendly, loves fetch and long walks',
      'specialNeeds': 'Needs medication twice daily',
      'imageUrl': 'assets/images/golden_retriever.jpg',
      'ownerId': 1,
      'weight': '32 kg',
      'vaccinated': true,
      'microchipped': true,
      'primaryVet': {
        'name': 'Dr. Sarah Johnson',
        'clinic': 'City Pet Clinic',
        'phone': '(555) 123-4567',
        'email': 'sarah.johnson@citypetclinic.com',
      },
      'emergencyVet': {
        'name': 'Dr. Michael Chen',
        'clinic': 'Emergency Animal Hospital',
        'phone': '(555) 987-6543',
        'email': 'emergency@animalhosp.com',
      },
    },
    {
      'id': 2,
      'name': 'Whiskers',
      'type': 'Persian Cat',
      'age': '5 years old',
      'personality': 'Calm and affectionate, enjoys quiet spaces',
      'specialNeeds': 'Daily brushing required, indoor only',
      'imageUrl': 'assets/images/persian_cat.jpg',
      'ownerId': 2,
      'weight': '4.5 kg',
      'vaccinated': true,
      'microchipped': true,
      'primaryVet': {
        'name': 'Dr. Emily Rodriguez',
        'clinic': 'Feline Care Center',
        'phone': '(555) 234-5678',
        'email': 'emily.rodriguez@felinecare.com',
      },
      'emergencyVet': {
        'name': 'Dr. Michael Chen',
        'clinic': 'Emergency Animal Hospital',
        'phone': '(555) 987-6543',
        'email': 'emergency@animalhosp.com',
      },
    },
    {
      'id': 3,
      'name': 'Luna',
      'type': 'Siamese Cat',
      'age': '2 years old',
      'personality': 'Playful and vocal, loves interactive toys',
      'specialNeeds': 'Prefers wet food, needs daily playtime',
      'imageUrl': 'assets/images/siamese_cat.jpg',
      'ownerId': 3,
      'weight': '3.8 kg',
      'vaccinated': true,
      'microchipped': true,
      'primaryVet': {
        'name': 'Dr. James Wilson',
        'clinic': 'Westside Veterinary',
        'phone': '(555) 345-6789',
        'email': 'james.wilson@westsidevet.com',
      },
      'emergencyVet': {
        'name': 'Dr. Michael Chen',
        'clinic': 'Emergency Animal Hospital',
        'phone': '(555) 987-6543',
        'email': 'emergency@animalhosp.com',
      },
    },
    {
      'id': 4,
      'name': 'Buddy',
      'type': 'Beagle',
      'age': '4 years old',
      'personality': 'Curious and gentle, great with children',
      'specialNeeds': 'Prone to overeating, measured portions only',
      'imageUrl': 'assets/images/beagle.jpg',
      'ownerId': 4,
      'weight': '15 kg',
      'vaccinated': true,
      'microchipped': true,
      'primaryVet': {
        'name': 'Dr. Lisa Thompson',
        'clinic': 'Northside Animal Care',
        'phone': '(555) 456-7890',
        'email': 'lisa.thompson@northsideanimal.com',
      },
      'emergencyVet': {
        'name': 'Dr. Michael Chen',
        'clinic': 'Emergency Animal Hospital',
        'phone': '(555) 987-6543',
        'email': 'emergency@animalhosp.com',
      },
    },
    {
      'id': 5,
      'name': 'Charlie',
      'type': 'Border Collie',
      'age': '6 years old',
      'personality': 'Highly intelligent and energetic, loves mental stimulation',
      'specialNeeds': 'Needs daily exercise and puzzle toys, separation anxiety',
      'imageUrl': 'assets/images/border_collie.jpg',
      'ownerId': 5,
      'weight': '22 kg',
      'vaccinated': true,
      'microchipped': true,
      'primaryVet': {
        'name': 'Dr. Robert Martinez',
        'clinic': 'Canine Health Center',
        'phone': '(555) 567-8901',
        'email': 'robert.martinez@caninehealth.com',
      },
      'emergencyVet': {
        'name': 'Dr. Michael Chen',
        'clinic': 'Emergency Animal Hospital',
        'phone': '(555) 987-6543',
        'email': 'emergency@animalhosp.com',
      },
    },
    {
      'id': 6,
      'name': 'Milo',
      'type': 'French Bulldog',
      'age': '3 years old',
      'personality': 'Calm and affectionate, Charlie\'s best friend',
      'specialNeeds': 'Breathing issues, avoid overexertion in hot weather',
      'imageUrl': 'assets/images/french_bulldog.jpg',
      'ownerId': 5,
      'weight': '12 kg',
      'vaccinated': true,
      'microchipped': true,
      'primaryVet': {
        'name': 'Dr. Robert Martinez',
        'clinic': 'Canine Health Center',
        'phone': '(555) 567-8901',
        'email': 'robert.martinez@caninehealth.com',
      },
      'emergencyVet': {
        'name': 'Dr. Michael Chen',
        'clinic': 'Emergency Animal Hospital',
        'phone': '(555) 987-6543',
        'email': 'emergency@animalhosp.com',
      },
    },
  ];

  // Realistic pet owner profiles
  static final List<Map<String, dynamic>> petOwners = [
    {
      'id': 1,
      'name': 'John Smith',
      'email': 'john.smith@email.com',
      'phone': '+61 412 345 678',
      'address': '123 Maple Street, Bondi Beach NSW 2026',
      'emergencyContact': 'Sarah Smith - +61 423 456 789',
      'totalBookings': 15,
      'memberSince': 'March 2023',
      'notes': 'Very communicative and caring pet owner. Always provides detailed instructions.',
    },
    {
      'id': 2,
      'name': 'Sarah Johnson',
      'email': 'sarah.johnson@email.com',
      'phone': '+61 434 567 890',
      'address': '456 Oak Avenue, Paddington NSW 2021',
      'emergencyContact': 'Mike Johnson - +61 445 678 901',
      'rating': 4.9,
      'totalBookings': 8,
      'memberSince': 'June 2023',
      'notes': 'First-time user, very appreciative of updates and photos.',
    },
    {
      'id': 3,
      'name': 'Emily Davis',
      'email': 'emily.davis@email.com',
      'phone': '+61 456 789 012',
      'address': '789 Pine Road, Surry Hills NSW 2010',
      'emergencyContact': 'Tom Davis - +61 467 890 123',
      'totalBookings': 22,
      'memberSince': 'January 2023',
      'notes': 'Regular client, travels frequently for work. Very organized.',
    },
    {
      'id': 4,
      'name': 'Michael Brown',
      'email': 'michael.brown@email.com',
      'phone': '+61 478 901 234',
      'address': '321 Cedar Close, Newtown NSW 2042',
      'emergencyContact': 'Lisa Brown - +61 489 012 345',
      'totalBookings': 12,
      'memberSince': 'April 2023',
      'notes': 'Works long hours, needs flexible scheduling. Very grateful for service.',
    },
    {
      'id': 5,
      'name': 'David Wilson',
      'email': 'david.wilson@email.com',
      'phone': '+61 490 123 456',
      'address': '567 Elm Street, Darlinghurst NSW 2010',
      'emergencyContact': 'Jennifer Wilson - +61 501 234 567',
      'rating': 4.9,
      'totalBookings': 18,
      'memberSince': 'February 2023',
      'notes': 'Has two pets that are best friends. Prefers them to be cared for together. Very detailed care instructions.',
    },
  ];

  // Realistic job scenarios with proper timelines and pricing
  static final List<Job> activeJobs = [
    Job(
      id: 1,
      petOwnerId: 1,
      petSitterId: 1,
      petSitterName: 'Sally Sitter',
      petIds: [1],
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      isCompleted: false,
    ),
    Job(
      id: 2,
      petOwnerId: 2,
      petSitterId: 1,
      petSitterName: 'Sally Sitter',
      petIds: [2],
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 3)),
      isCompleted: false,
    ),
    Job(
      id: 3,
      petOwnerId: 3,
      petSitterId: 1,
      petSitterName: 'Sally Sitter',
      petIds: [3],
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      isCompleted: false,
    ),
    // Multi-pet job with Charlie and Milo
    Job(
      id: 5,
      petOwnerId: 5,
      petSitterId: 1,
      petSitterName: 'Sally Sitter',
      petIds: [5, 6], // Both Charlie and Milo
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 4)),
      isCompleted: false,
    ),
  ];

  static final List<Job> pastJobs = [
    Job(
      id: 4,
      petOwnerId: 4,
      petSitterId: 1,
      petSitterName: 'Sally Sitter',
      petIds: [4],
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().subtract(const Duration(days: 7)),
      isCompleted: true,
    ),
    Job(
      id: 5,
      petOwnerId: 1,
      petSitterId: 1,
      petSitterName: 'Sally Sitter',
      petIds: [1],
      startDate: DateTime.now().subtract(const Duration(days: 20)),
      endDate: DateTime.now().subtract(const Duration(days: 17)),
      isCompleted: true,
    ),
    Job(
      id: 6,
      petOwnerId: 2,
      petSitterId: 1,
      petSitterName: 'Sally Sitter',
      petIds: [2],
      startDate: DateTime.now().subtract(const Duration(days: 35)),
      endDate: DateTime.now().subtract(const Duration(days: 32)),
      isCompleted: true,
    ),
  ];

  // Realistic message conversations
  static final List<Map<String, dynamic>> conversations = [
    {
      'id': 1,
      'petOwnerId': 1,
      'petOwnerName': 'John Smith',
      'petName': 'Max',
      'lastMessage': 'Thanks for the update! Max looks so happy 😊',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'unreadCount': 0,
      'messages': [
        {
          'id': 1,
          'senderId': 1,
          'senderName': 'Sally Sitter',
          'message': 'Hi John! Just wanted to let you know Max is doing great. We had a wonderful walk this morning and he\'s now resting comfortably.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'isFromSitter': true,
        },
        {
          'id': 2,
          'senderId': 1,
          'senderName': 'John Smith',
          'message': 'That\'s wonderful to hear! How did he handle his medication?',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          'isFromSitter': false,
        },
        {
          'id': 3,
          'senderId': 1,
          'senderName': 'Sally Sitter',
          'message': 'He took his medication without any issues. I mixed it with a bit of his favorite treat as you suggested. He\'s such a good boy!',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          'isFromSitter': true,
        },
        {
          'id': 4,
          'senderId': 1,
          'senderName': 'John Smith',
          'message': 'Thanks for the update! Max looks so happy 😊',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
          'isFromSitter': false,
        },
      ],
    },
    {
      'id': 2,
      'petOwnerId': 2,
      'petOwnerName': 'Sarah Johnson',
      'petName': 'Whiskers',
      'lastMessage': 'Perfect! See you tomorrow at 9 AM',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'unreadCount': 1,
      'messages': [
        {
          'id': 1,
          'senderId': 2,
          'senderName': 'Sarah Johnson',
          'message': 'Hi Sally! I\'m confirming our appointment for tomorrow. Whiskers will need her daily brushing around 2 PM.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
          'isFromSitter': false,
        },
        {
          'id': 2,
          'senderId': 1,
          'senderName': 'Sally Sitter',
          'message': 'Absolutely! I\'ll make sure to give Whiskers her brushing session. Is there anything else I should know?',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3, minutes: 30)),
          'isFromSitter': true,
        },
        {
          'id': 3,
          'senderId': 2,
          'senderName': 'Sarah Johnson',
          'message': 'Perfect! See you tomorrow at 9 AM',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
          'isFromSitter': false,
        },
      ],
    },
    {
      'id': 3,
      'petOwnerId': 3,
      'petOwnerName': 'Emily Davis',
      'petName': 'Luna',
      'lastMessage': 'Could you send a photo when you arrive?',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 2,
      'messages': [
        {
          'id': 1,
          'senderId': 3,
          'senderName': 'Emily Davis',
          'message': 'Hi Sally! I\'ll be traveling tomorrow. Luna loves her interactive feather toy - it\'s in the living room.',
          'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          'isFromSitter': false,
        },
        {
          'id': 2,
          'senderId': 3,
          'senderName': 'Emily Davis',
          'message': 'Could you send a photo when you arrive?',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'isFromSitter': false,
        },
      ],
    },
  ];

  // Realistic notifications with varied content
  static final List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'icon': 'pets',
      'color': 'blue',
      'title': 'New job request from Michael',
      'description': 'Michael Brown has requested pet sitting services for Buddy (Beagle) from Dec 15-18. Rate: \$45/day',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'unread': true,
      'type': 'job_request',
      'actionRequired': true,
    },
    {
      'id': 2,
      'icon': 'message',
      'color': 'green',
      'title': 'New message from Sarah',
      'description': 'Sarah Johnson: "Perfect! See you tomorrow at 9 AM" - regarding Whiskers\' care',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'unread': true,
      'type': 'message',
      'actionRequired': false,
    },
    {
      'id': 3,
      'icon': 'payment',
      'color': 'purple',
      'title': 'Payment received - \$135',
      'description': 'John Smith has paid \$135 for Max\'s 3-day pet sitting service. Payment method: Bank Transfer',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'unread': true,
      'type': 'payment',
      'actionRequired': false,
    },
    {
      'id': 4,
      'icon': 'calendar_today',
      'color': 'orange',
      'title': 'Upcoming visit reminder',
      'description': 'You have a scheduled visit for Luna (Siamese Cat) tomorrow at 10:00 AM. Address: 789 Pine Road, Surry Hills',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'unread': true,
      'type': 'reminder',
      'actionRequired': false,
    },
    {
      'id': 5,
      'icon': 'check_circle',
      'color': 'green',
      'title': 'Job completed successfully!',
      'description': 'Emily Davis confirmed job completion: "Sally was amazing with Luna! Great communication and care."',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unread': false,
      'type': 'job_completion',
      'actionRequired': false,
    },
    {
      'id': 6,
      'icon': 'photo_camera',
      'color': 'teal',
      'title': 'Photo album created',
      'description': 'Your photo album for Max\'s recent stay has been automatically created with 12 photos',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'unread': false,
      'type': 'album',
      'actionRequired': false,
    },
  ];

  // Activity feed with realistic entries
  static final List<Map<String, dynamic>> recentActivity = [
    {
      'id': 1,
      'type': 'job_completed',
      'icon': 'check_circle',
      'color': 'green',
      'title': 'Job completed',
      'description': 'Successfully completed 3-day stay with Max',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'details': 'Duration: 3 days • Earnings: \$135',
    },
    {
      'id': 2,
      'type': 'photo_uploaded',
      'icon': 'photo_camera',
      'color': 'blue',
      'title': 'Photos uploaded',
      'description': 'Added 5 new photos to Whiskers\' album',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'details': 'Album: "Whiskers - December 2024" • Total photos: 18',
    },
    {
      'id': 3,
      'type': 'message_sent',
      'icon': 'message',
      'color': 'purple',
      'title': 'Daily update sent',
      'description': 'Sent daily update to John about Max\'s activities',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'details': 'Included: Walk report, meal times, medication log',
    },
    {
      'id': 4,
      'type': 'job_accepted',
      'icon': 'handshake',
      'color': 'orange',
      'title': 'New job accepted',
      'description': 'Accepted pet sitting request for Luna',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'details': 'Duration: 4 days • Start date: Tomorrow • Rate: \$40/day',
    },
    {
      'id': 5,
      'type': 'job_completed',
      'icon': 'check_circle',
      'color': 'green',
      'title': 'Job completed',
      'description': 'Successfully completed job for Sarah Johnson',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'details': '"Excellent care for Whiskers. Great job Sally!"',
    },
  ];

  // Helper methods to get data
  static Map<String, dynamic>? getPetById(int petId) {
    try {
      return pets.firstWhere((pet) => pet['id'] == petId);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getPetOwnerById(int ownerId) {
    try {
      return petOwners.firstWhere((owner) => owner['id'] == ownerId);
    } catch (e) {
      return null;
    }
  }

  static List<Job> getActiveJobs() => activeJobs;
  static List<Job> getPastJobs() => pastJobs;
  static List<Map<String, dynamic>> getConversations() => conversations;
  static List<Map<String, dynamic>> getNotifications() => notifications;
  static List<Map<String, dynamic>> getRecentActivity() => recentActivity;

  // Get unread notification count
  static int getUnreadNotificationCount() {
    return notifications.where((notification) => notification['unread'] == true).length;
  }

  // Get unread message count
  static int getUnreadMessageCount() {
    return conversations.fold(0, (sum, conversation) => sum + (conversation['unreadCount'] as int));
  }

  // Mark notification as read
  static void markNotificationAsRead(int notificationId) {
    final notification = notifications.firstWhere((n) => n['id'] == notificationId);
    notification['unread'] = false;
  }

  // Mark all notifications as read
  static void markAllNotificationsAsRead() {
    for (var notification in notifications) {
      notification['unread'] = false;
    }
  }
}
