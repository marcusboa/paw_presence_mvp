import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/receipt.dart';
import 'demo_data_service.dart';

class ReceiptService {
  static final List<Receipt> _receipts = [];
  static final ImagePicker _picker = ImagePicker();

  // Get all receipts
  static List<Receipt> getAllReceipts() {
    return List.from(_receipts);
  }

  // Get receipts by status
  static List<Receipt> getReceiptsByStatus(ReceiptStatus status) {
    return _receipts.where((receipt) => receipt.status == status).toList();
  }

  // Get receipts for a specific job
  static List<Receipt> getReceiptsForJob(String jobId) {
    return _receipts.where((receipt) => receipt.jobId == jobId).toList();
  }

  // Capture receipt photo from camera
  static Future<Receipt?> captureReceiptPhoto({
    required String jobId,
    required String petOwnerId,
    required String petOwnerName,
    required String petName,
    String? description,
    double? amount,
    String? notes,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final receipt = Receipt(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          imagePath: image.path,
          description: description ?? 'Receipt',
          amount: amount,
          dateTime: DateTime.now(),
          jobId: jobId,
          petOwnerId: petOwnerId,
          petOwnerName: petOwnerName,
          petName: petName,
          status: ReceiptStatus.pending,
          notes: notes,
        );

        _receipts.add(receipt);
        return receipt;
      }
    } catch (e) {
      debugPrint('Error capturing receipt photo: $e');
    }
    return null;
  }

  // Pick receipt photo from gallery
  static Future<Receipt?> pickReceiptPhoto({
    required String jobId,
    required String petOwnerId,
    required String petOwnerName,
    required String petName,
    String? description,
    double? amount,
    String? notes,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final receipt = Receipt(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          imagePath: image.path,
          description: description ?? 'Receipt',
          amount: amount,
          dateTime: DateTime.now(),
          jobId: jobId,
          petOwnerId: petOwnerId,
          petOwnerName: petOwnerName,
          petName: petName,
          status: ReceiptStatus.pending,
          notes: notes,
        );

        _receipts.add(receipt);
        return receipt;
      }
    } catch (e) {
      debugPrint('Error picking receipt photo: $e');
    }
    return null;
  }

  // Update receipt
  static bool updateReceipt(Receipt updatedReceipt) {
    final index = _receipts.indexWhere((r) => r.id == updatedReceipt.id);
    if (index != -1) {
      _receipts[index] = updatedReceipt;
      return true;
    }
    return false;
  }

  // Send receipt to pet owner immediately
  static bool sendReceiptToOwner(String receiptId) {
    final index = _receipts.indexWhere((r) => r.id == receiptId);
    if (index != -1) {
      _receipts[index] = _receipts[index].copyWith(status: ReceiptStatus.sent);
      return true;
    }
    return false;
  }

  // File receipt for end-of-job delivery
  static bool fileReceiptForLater(String receiptId) {
    final index = _receipts.indexWhere((r) => r.id == receiptId);
    if (index != -1) {
      _receipts[index] = _receipts[index].copyWith(status: ReceiptStatus.filed);
      return true;
    }
    return false;
  }

  // Mark receipt as delivered (for end-of-job)
  static bool markReceiptAsDelivered(String receiptId) {
    final index = _receipts.indexWhere((r) => r.id == receiptId);
    if (index != -1) {
      _receipts[index] = _receipts[index].copyWith(status: ReceiptStatus.delivered);
      return true;
    }
    return false;
  }

  // Delete receipt
  static bool deleteReceipt(String receiptId) {
    final index = _receipts.indexWhere((r) => r.id == receiptId);
    if (index != -1) {
      _receipts.removeAt(index);
      return true;
    }
    return false;
  }

  // Get active jobs for receipt creation
  static List<Map<String, dynamic>> getActiveJobsForReceipts() {
    // Use demo data that returns Map<String, dynamic> instead of Job objects
    final demoJobs = [
      {
        'jobId': 'job_1',
        'petOwnerId': 'owner_1',
        'petOwnerName': 'Sarah Johnson',
        'petName': 'Max',
        'jobTitle': 'Weekend Pet Sitting',
      },
      {
        'jobId': 'job_2',
        'petOwnerId': 'owner_2',
        'petOwnerName': 'Mike Chen',
        'petName': 'Luna',
        'jobTitle': 'Daily Dog Walking',
      },
      {
        'jobId': 'job_3',
        'petOwnerId': 'owner_3',
        'petOwnerName': 'Emma Wilson',
        'petName': 'Whiskers',
        'jobTitle': 'Cat Care Service',
      },
    ];
    return demoJobs;
  }

  // Get conversations for receipt sending
  static List<Map<String, dynamic>> getConversationsForReceipts() {
    return DemoDataService.getConversations().map((conversation) {
      return {
        'petOwnerId': conversation['petOwnerId'] ?? 'owner_${conversation['id']}',
        'petOwnerName': conversation['petOwnerName'],
        'petName': conversation['petName'],
        'conversationId': conversation['id'],
      };
    }).toList();
  }

  // Initialize with demo data
  static void initializeDemoReceipts() {
    if (_receipts.isEmpty) {
      final demoReceipts = [
        Receipt(
          id: 'receipt_1',
          imagePath: 'assets/images/demo_receipt_1.jpg',
          description: 'Pet food purchase',
          amount: 24.99,
          dateTime: DateTime.now().subtract(const Duration(hours: 2)),
          jobId: 'job_1',
          petOwnerId: 'owner_1',
          petOwnerName: 'Sarah Johnson',
          petName: 'Max',
          status: ReceiptStatus.sent,
          notes: 'Premium dog food as requested',
        ),
        Receipt(
          id: 'receipt_2',
          imagePath: 'assets/images/demo_receipt_2.jpg',
          description: 'Vet emergency visit',
          amount: 85.00,
          dateTime: DateTime.now().subtract(const Duration(hours: 5)),
          jobId: 'job_2',
          petOwnerId: 'owner_2',
          petOwnerName: 'Mike Chen',
          petName: 'Luna',
          status: ReceiptStatus.filed,
          notes: 'Minor cut on paw, treated and bandaged',
        ),
        Receipt(
          id: 'receipt_3',
          imagePath: 'assets/images/demo_receipt_3.jpg',
          description: 'Pet toys and treats',
          amount: 15.50,
          dateTime: DateTime.now().subtract(const Duration(minutes: 30)),
          jobId: 'job_1',
          petOwnerId: 'owner_1',
          petOwnerName: 'Sarah Johnson',
          petName: 'Max',
          status: ReceiptStatus.pending,
          notes: 'Replacement toys after playtime',
        ),
      ];

      _receipts.addAll(demoReceipts);
    }
  }
}
