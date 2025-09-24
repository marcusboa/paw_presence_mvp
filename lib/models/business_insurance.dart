/// Business Insurance model for Pet Sitters
/// Represents insurance information and uploaded documents
class BusinessInsurance {
  final String id;
  final String provider;
  final String policyNumber;
  final String coverageAmount;
  final DateTime effectiveDate;
  final DateTime expiryDate;
  final bool isActive;
  final List<InsuranceDocument> documents;
  final DateTime lastUpdated;

  BusinessInsurance({
    required this.id,
    required this.provider,
    required this.policyNumber,
    required this.coverageAmount,
    required this.effectiveDate,
    required this.expiryDate,
    required this.isActive,
    required this.documents,
    required this.lastUpdated,
  });

  factory BusinessInsurance.fromJson(Map<String, dynamic> json) {
    return BusinessInsurance(
      id: json['id'],
      provider: json['provider'],
      policyNumber: json['policyNumber'],
      coverageAmount: json['coverageAmount'],
      effectiveDate: DateTime.parse(json['effectiveDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      isActive: json['isActive'],
      documents: (json['documents'] as List)
          .map((doc) => InsuranceDocument.fromJson(doc))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider,
      'policyNumber': policyNumber,
      'coverageAmount': coverageAmount,
      'effectiveDate': effectiveDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'isActive': isActive,
      'documents': documents.map((doc) => doc.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  BusinessInsurance copyWith({
    String? id,
    String? provider,
    String? policyNumber,
    String? coverageAmount,
    DateTime? effectiveDate,
    DateTime? expiryDate,
    bool? isActive,
    List<InsuranceDocument>? documents,
    DateTime? lastUpdated,
  }) {
    return BusinessInsurance(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      policyNumber: policyNumber ?? this.policyNumber,
      coverageAmount: coverageAmount ?? this.coverageAmount,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      documents: documents ?? this.documents,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get isExpiringSoon {
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate.difference(now).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiryDate);
  }
}

/// Insurance Document model
/// Represents uploaded insurance documents
class InsuranceDocument {
  final String id;
  final String name;
  final String type; // certificate, policy, receipt, etc.
  final String filePath;
  final DateTime uploadDate;
  final int fileSize;
  final String mimeType;

  InsuranceDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.filePath,
    required this.uploadDate,
    required this.fileSize,
    required this.mimeType,
  });

  factory InsuranceDocument.fromJson(Map<String, dynamic> json) {
    return InsuranceDocument(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      filePath: json['filePath'],
      uploadDate: DateTime.parse(json['uploadDate']),
      fileSize: json['fileSize'],
      mimeType: json['mimeType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'filePath': filePath,
      'uploadDate': uploadDate.toIso8601String(),
      'fileSize': fileSize,
      'mimeType': mimeType,
    };
  }

  String get formattedFileSize {
    if (fileSize < 1024) {
      return '${fileSize}B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }
}
