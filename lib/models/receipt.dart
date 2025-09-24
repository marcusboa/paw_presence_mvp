import 'package:flutter/material.dart';

class Receipt {
  final String id;
  final String imagePath;
  final String description;
  final double? amount;
  final DateTime dateTime;
  final String jobId;
  final String petOwnerId;
  final String petOwnerName;
  final String petName;
  final ReceiptStatus status;
  final String? notes;

  Receipt({
    required this.id,
    required this.imagePath,
    required this.description,
    this.amount,
    required this.dateTime,
    required this.jobId,
    required this.petOwnerId,
    required this.petOwnerName,
    required this.petName,
    required this.status,
    this.notes,
  });

  Receipt copyWith({
    String? id,
    String? imagePath,
    String? description,
    double? amount,
    DateTime? dateTime,
    String? jobId,
    String? petOwnerId,
    String? petOwnerName,
    String? petName,
    ReceiptStatus? status,
    String? notes,
  }) {
    return Receipt(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dateTime: dateTime ?? this.dateTime,
      jobId: jobId ?? this.jobId,
      petOwnerId: petOwnerId ?? this.petOwnerId,
      petOwnerName: petOwnerName ?? this.petOwnerName,
      petName: petName ?? this.petName,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'description': description,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'jobId': jobId,
      'petOwnerId': petOwnerId,
      'petOwnerName': petOwnerName,
      'petName': petName,
      'status': status.toString(),
      'notes': notes,
    };
  }

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      imagePath: json['imagePath'],
      description: json['description'],
      amount: json['amount']?.toDouble(),
      dateTime: DateTime.parse(json['dateTime']),
      jobId: json['jobId'],
      petOwnerId: json['petOwnerId'],
      petOwnerName: json['petOwnerName'],
      petName: json['petName'],
      status: ReceiptStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ReceiptStatus.pending,
      ),
      notes: json['notes'],
    );
  }
}

enum ReceiptStatus {
  pending,    // Captured but not sent
  sent,       // Sent to pet owner
  filed,      // Filed for end-of-job delivery
  delivered,  // Delivered to pet owner
}

extension ReceiptStatusExtension on ReceiptStatus {
  String get displayName {
    switch (this) {
      case ReceiptStatus.pending:
        return 'Pending';
      case ReceiptStatus.sent:
        return 'Sent';
      case ReceiptStatus.filed:
        return 'Filed';
      case ReceiptStatus.delivered:
        return 'Delivered';
    }
  }

  Color get color {
    switch (this) {
      case ReceiptStatus.pending:
        return Colors.orange;
      case ReceiptStatus.sent:
        return Colors.blue;
      case ReceiptStatus.filed:
        return Colors.purple;
      case ReceiptStatus.delivered:
        return Colors.green;
    }
  }
}
