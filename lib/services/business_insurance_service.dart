import '../models/business_insurance.dart';

/// Business Insurance Service for Pet Sitters
/// Manages insurance information and document uploads
class BusinessInsuranceService {
  // Singleton pattern for consistent data access
  static final BusinessInsuranceService _instance = BusinessInsuranceService._internal();
  factory BusinessInsuranceService() => _instance;
  BusinessInsuranceService._internal();

  // Demo insurance data
  static BusinessInsurance? _currentInsurance;
  static final List<InsuranceDocument> _documents = [];

  // Initialize with demo data
  static void _initializeDemoData() {
    if (_currentInsurance == null) {
      _currentInsurance = BusinessInsurance(
        id: 'ins_001',
        provider: 'Pet Care Insurance Co.',
        policyNumber: 'PCI-2024-789456',
        coverageAmount: '\$2,000,000',
        effectiveDate: DateTime(2024, 1, 1),
        expiryDate: DateTime(2024, 12, 31),
        isActive: true,
        documents: [
          InsuranceDocument(
            id: 'doc_001',
            name: 'Insurance Certificate 2024',
            type: 'certificate',
            filePath: '/documents/insurance_cert_2024.pdf',
            uploadDate: DateTime(2024, 1, 15),
            fileSize: 245760, // 240KB
            mimeType: 'application/pdf',
          ),
          InsuranceDocument(
            id: 'doc_002',
            name: 'Policy Document',
            type: 'policy',
            filePath: '/documents/policy_full_2024.pdf',
            uploadDate: DateTime(2024, 1, 15),
            fileSize: 1048576, // 1MB
            mimeType: 'application/pdf',
          ),
          InsuranceDocument(
            id: 'doc_003',
            name: 'Premium Payment Receipt',
            type: 'receipt',
            filePath: '/documents/payment_receipt_jan2024.pdf',
            uploadDate: DateTime(2024, 1, 20),
            fileSize: 102400, // 100KB
            mimeType: 'application/pdf',
          ),
        ],
        lastUpdated: DateTime.now(),
      );
      
      _documents.addAll(_currentInsurance!.documents);
    }
  }

  /// Get current insurance information
  static BusinessInsurance? getInsuranceInfo() {
    _initializeDemoData();
    return _currentInsurance;
  }

  /// Upload a new insurance document
  static Future<void> uploadDocument(String filePath, String documentType) async {
    // Simulate upload delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final newDocument = InsuranceDocument(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      name: _generateDocumentName(documentType),
      type: documentType,
      filePath: filePath,
      uploadDate: DateTime.now(),
      fileSize: _generateRandomFileSize(),
      mimeType: _getMimeTypeForDocument(documentType),
    );
    
    _documents.add(newDocument);
    
    // Update insurance with new documents list
    if (_currentInsurance != null) {
      _currentInsurance = _currentInsurance!.copyWith(
        documents: List.from(_documents),
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Delete an insurance document
  static void deleteDocument(String documentId) {
    _documents.removeWhere((doc) => doc.id == documentId);
    
    // Update insurance with new documents list
    if (_currentInsurance != null) {
      _currentInsurance = _currentInsurance!.copyWith(
        documents: List.from(_documents),
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Update insurance information
  static void updateInsuranceInfo({
    String? provider,
    String? policyNumber,
    String? coverageAmount,
    DateTime? effectiveDate,
    DateTime? expiryDate,
  }) {
    if (_currentInsurance != null) {
      _currentInsurance = _currentInsurance!.copyWith(
        provider: provider,
        policyNumber: policyNumber,
        coverageAmount: coverageAmount,
        effectiveDate: effectiveDate,
        expiryDate: expiryDate,
        isActive: expiryDate?.isAfter(DateTime.now()) ?? _currentInsurance!.isActive,
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Check if insurance is expiring soon (within 30 days)
  static bool isInsuranceExpiringSoon() {
    _initializeDemoData();
    return _currentInsurance?.isExpiringSoon ?? false;
  }

  /// Check if insurance is expired
  static bool isInsuranceExpired() {
    _initializeDemoData();
    return _currentInsurance?.isExpired ?? true;
  }

  /// Get all uploaded documents
  static List<InsuranceDocument> getDocuments() {
    _initializeDemoData();
    return List.from(_documents);
  }

  /// Get documents by type
  static List<InsuranceDocument> getDocumentsByType(String type) {
    _initializeDemoData();
    return _documents.where((doc) => doc.type == type).toList();
  }

  /// Get insurance status summary
  static Map<String, dynamic> getInsuranceStatusSummary() {
    _initializeDemoData();
    
    if (_currentInsurance == null) {
      return {
        'hasInsurance': false,
        'isActive': false,
        'isExpiringSoon': false,
        'isExpired': true,
        'documentCount': 0,
        'message': 'No insurance information available',
      };
    }

    final insurance = _currentInsurance!;
    final now = DateTime.now();
    final daysUntilExpiry = insurance.expiryDate.difference(now).inDays;

    return {
      'hasInsurance': true,
      'isActive': insurance.isActive,
      'isExpiringSoon': insurance.isExpiringSoon,
      'isExpired': insurance.isExpired,
      'documentCount': insurance.documents.length,
      'daysUntilExpiry': daysUntilExpiry,
      'provider': insurance.provider,
      'policyNumber': insurance.policyNumber,
      'coverageAmount': insurance.coverageAmount,
      'expiryDate': insurance.expiryDate,
      'message': _getStatusMessage(insurance),
    };
  }

  /// Generate a realistic document name based on type
  static String _generateDocumentName(String type) {
    final timestamp = DateTime.now();
    final monthYear = '${_getMonthName(timestamp.month)}_${timestamp.year}';
    
    switch (type) {
      case 'certificate':
        return 'Insurance_Certificate_$monthYear';
      case 'policy':
        return 'Policy_Document_$monthYear';
      case 'receipt':
        return 'Payment_Receipt_$monthYear';
      default:
        return 'Insurance_Document_$monthYear';
    }
  }

  /// Generate random file size for demo purposes
  static int _generateRandomFileSize() {
    final sizes = [102400, 245760, 512000, 1048576, 2097152]; // 100KB to 2MB
    sizes.shuffle();
    return sizes.first;
  }

  /// Get MIME type for document type
  static String _getMimeTypeForDocument(String type) {
    switch (type) {
      case 'certificate':
      case 'policy':
      case 'receipt':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  /// Get status message for insurance
  static String _getStatusMessage(BusinessInsurance insurance) {
    if (insurance.isExpired) {
      return 'Your insurance has expired. Please update your policy.';
    } else if (insurance.isExpiringSoon) {
      final days = insurance.expiryDate.difference(DateTime.now()).inDays;
      return 'Your insurance expires in $days days. Consider renewing soon.';
    } else {
      return 'Your insurance is active and up to date.';
    }
  }

  /// Get month name
  static String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  /// Demo method to simulate different insurance states
  static void setDemoInsuranceState(String state) {
    switch (state) {
      case 'expired':
        _currentInsurance = _currentInsurance?.copyWith(
          expiryDate: DateTime.now().subtract(const Duration(days: 30)),
          isActive: false,
        );
        break;
      case 'expiring_soon':
        _currentInsurance = _currentInsurance?.copyWith(
          expiryDate: DateTime.now().add(const Duration(days: 15)),
          isActive: true,
        );
        break;
      case 'active':
        _currentInsurance = _currentInsurance?.copyWith(
          expiryDate: DateTime.now().add(const Duration(days: 300)),
          isActive: true,
        );
        break;
      case 'no_insurance':
        _currentInsurance = null;
        _documents.clear();
        break;
    }
  }
}
